import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cartitem.dart';
import '../../providers/orderprovider.dart';
import '../../providers/orderprovidercart.dart';
import 'order_screen_page.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String id;
  final String nameitem;
  final int priceitem;
  final String imagepath;
  final String ingredients;
  final itemid;

  ProductScreen(
    this.itemid, {
    Key? key,
    required this.nameitem,
    required this.priceitem,
    required this.ingredients,
    required this.imagepath,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  int quantity = 1;
  double totalprice = 0;
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  int? status;

  @override
  void initState() {
    super.initState();
    totalprice = widget.priceitem.toDouble();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    statuscoffee();
  }

  Future<void> statuscoffee() async {
    var data =
        await _firestore.collection('coffeeshops').doc(widget.id).get();
    status = data.data()!['status'];
  }

  int size = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.imagepath,
                    fit: BoxFit.contain,
                    height: 300,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: IconButton(
                      iconSize: 28,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nameitem,
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.ingredients,
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Text(
                          widget.nameitem,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                              totalprice += widget.priceitem;
                            });
                          },
                        ),
                        Text(
                          '$quantity x',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                                totalprice -= widget.priceitem;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Text('Size', style: TextStyle(fontSize: 16)),
                        Spacer(),
                        buildSizeButton(0, 'Small'),
                        SizedBox(width: 10),
                        buildSizeButton(1, 'Medium'),
                        SizedBox(width: 10),
                        buildSizeButton(2, 'Large'),
                      ],
                    ),
                    SizedBox(height: 60),
                    getcontent(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSizeButton(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          size = index;
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/${index == size ? 'selected_' : ''}$label.svg',
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'sans-serif',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getcontent(BuildContext context) {
    String cart = ref.read(cartProviderCart);

    if (cart.isEmpty || cart == widget.id) {
      return SizedBox(
        height: 73,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF2B2D2F)),
          ),
          onPressed: () async {
            if (status == 1) {
              bool isUserBlocked = false;
              try {
                isUserBlocked = await FirebaseFirestore.instance
                    .collection('Block')
                    .doc(widget.id)
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .get()
                    .then((doc) => doc.exists);
              } catch (e) {
                print(e);
              }

              if (!isUserBlocked) {
                CartItem item = CartItem(
                  widget.itemid,
                  id: widget.id,
                  name: widget.nameitem,
                  price: totalprice,
                  quantity: quantity,
                  size: size,
                  image: widget.imagepath,
                );

                ref.read(cartProvider.notifier).addItem(item);
                ref.read(cartProviderCart.notifier).addItem(widget.id);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${item.name} Added'),
                      content: Text('The item has been added to your cart.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cannot Place Order'),
                      content: Text('You are not allowed to place an order.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Closed now',
                      style: TextStyle(color: Color.fromARGB(255, 244, 104, 94)),
                    ),
                    content: Text(
                      'It will open soon... , dont worry!',
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 241, 44)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add to Cart',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(width: 20),
              Text(
                '|',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(width: 20),
              Text(
                '$totalprice SAR',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                '   ${quantity}x',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add to Cart',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(width: 20),
            Text(
              '|',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(width: 20),
            Text(
              '$totalprice SAR',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              '   ${quantity}x',
              style: TextStyle(fontSize: 20, color: Colors.white),
            )
          ],
        ),
      );
    }
  }
}
