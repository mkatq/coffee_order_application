// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_order_application/screens/user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cartitem.dart';
import '../../providers/orderprovider.dart';
import '../../providers/orderprovidercart.dart';
import '../../services/notify.dart';

class OrderScreen extends ConsumerStatefulWidget {
  String? coffeeshopid;
  OrderScreen({
    super.key,
    this.coffeeshopid,
  });

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  // ignore: non_constant_identifier_names
  bool OnsiteTakeawaystate = false;

  int size = 1;
  int groupValue = 0;

  double totalpriceorder = 0;
  Map? coffeedata;
  @override
  void updates() {
    List<CartItem> items = ref.watch(cartProvider);

    if (items.isEmpty) {
      ref.read(cartProviderCart.notifier).removeItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> items = ref.watch(cartProvider);

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('There is no item in cart'),
            )
          ],
        ),
      );
    }

    // Calculate the total price
    totalpriceorder = items.fold(0, (double sum, CartItem item) {
      return sum + (item.price);
    });
    totalpriceorder = double.parse(totalpriceorder.toStringAsFixed(2));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Order',
                            style: TextStyle(
                                fontFamily: 'sans-serif',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Coffee shop Address',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Coffee',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 20)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Saudi Arabia, Al-hasa , Al hofuf',
                                        style: TextStyle(
                                            color: Color(0xFF7E8999),
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit,
                                            color: Color.fromARGB(
                                                255, 154, 154, 154)),
                                        label: const Text(
                                          'Edit Address',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.note_add,
                                            color: Color.fromARGB(
                                                255, 154, 154, 154)),
                                        label: const Text('Add notes',
                                            style:
                                                TextStyle(color: Colors.black)))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: ListTile(
                                  trailing: IconButton(
                                      onPressed: () {
                                        ref
                                            .watch(cartProvider.notifier)
                                            .removeItem(items[index]);

                                        updates();

                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete)),
                                  leading: Image.network(
                                      fit: BoxFit.cover, items[index].image),
                                  title: Column(
                                    children: [
                                      Text(
                                        '${items[index].quantity.toString()}x   ${items[index].name}',
                                        style: const TextStyle(
                                          fontFamily: 'sans-serif',
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${items[index].price.toString()} SAR  ',
                                        style: const TextStyle(
                                          fontFamily: 'sans-serif',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Payment Summary',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text('Price',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                    const SizedBox(width: 180),
                                    Text(
                                        '${totalpriceorder..toStringAsFixed(2)} SAR',
                                        style: const TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text('Tax 15%',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                    const SizedBox(width: 160),
                                    Text(
                                        '${(totalpriceorder * 0.15).toStringAsFixed(2)} SAR ',
                                        style: const TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text('Total Payment',
                                        style: TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                    const SizedBox(width: 110),
                                    Text(
                                        '${((totalpriceorder * 0.15) + totalpriceorder).toStringAsFixed(2)} SAR',
                                        style: const TextStyle(
                                            fontFamily: 'sans-serif',
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 73,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xFF2B2D2F))),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Column(
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Order payment',
                                                  style: TextStyle(
                                                      fontFamily: 'sans-serif',
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 230,
                                              child: Column(
                                                children: [
                                                  Card(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: RadioListTile(
                                                        value: 0,
                                                        groupValue: groupValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            groupValue = value!;
                                                          });
                                                        },
                                                        title: Row(
                                                          children: [
                                                            const Text(
                                                              'Online payment',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'sans-serif',
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 40,
                                                            ),
                                                            Image.asset(
                                                                fit: BoxFit
                                                                    .cover,
                                                                'assets/visa.png'),
                                                            Image.asset(
                                                                fit: BoxFit
                                                                    .cover,
                                                                'assets/Card.png'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: RadioListTile(
                                                        value: 1,
                                                        groupValue: groupValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            groupValue = value!;
                                                          });
                                                        },
                                                        title: const Text(
                                                          'Cash payment',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'sans-serif',
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Total Price',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'sans-serif',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        '${((totalpriceorder * 0.15) + totalpriceorder).toString()} SAR',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'sans-serif',
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 60,
                                                ),
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                      icon: const Icon(
                                                        Icons.payment,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color(
                                                                      0xFF2B2D2F))),
                                                      onPressed: makeorder,
                                                      label: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Pay Now',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Checkout',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  makeorder() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final firestorage = FirebaseStorage.instance;

    List<CartItem> items = ref.watch(cartProvider);
    String coffeeid = ref.watch(cartProviderCart);

    try {
      await _firestore.collection('orders').doc().set({
        'userId': _auth.currentUser!.uid,
        'shopId': coffeeid,
        'items': items.map((CartItem item) {
          return {
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
            'size': item.size,
            'image': item.image,
          };
        }).toList(),
        'totalPrice': totalpriceorder,
        'orderStatus': 1,
        'createdAt': DateTime.now()
      });

      // await _firestore.collection('block').doc(coffeeid);

      ref.read(cartProvider).clear();
      ref.read(cartProviderCart.notifier).removeItem();


      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Order Requested Successfully'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Your order has been successfully requested.'),
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 44,
                ), // Add the icon here
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              ),
            ],
          );
        },
      );
    } catch (e) {}
  }
}
