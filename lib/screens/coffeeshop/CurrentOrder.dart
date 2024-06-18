import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/notify.dart';
import 'package:http/http.dart' as http;

class CurrentOrder extends StatefulWidget {
  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder>
    with SingleTickerProviderStateMixin {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<String> orderStatusOptions = [
    'Rejected',
    'Waiting',
    'Accepted, ready soon',
    'Done'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection
            .where('orderStatus', whereIn: [0, 1, 2])
            .where('shopId', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final orderData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final orderDocument = snapshot.data!.docs[index];
                final orderId = orderDocument.id;
                final orderStatus = orderData['orderStatus'] ?? '';
                final createdAt = orderData['createdAt'] ?? '';
                final formattedCreatedAt =
                    DateFormat('MMM d, yyyy h:mm a').format(createdAt.toDate());

                final items = orderData['items'] as List<dynamic>;
                final userId = orderData['userId'];

                return FutureBuilder<DocumentSnapshot>(
                    future: usersCollection.doc(userId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        return Text('Error: ${userSnapshot.error}');
                      }

                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (userSnapshot.hasData) {
                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final userNamef = userData['first name'] ?? '';
                        final userNamel = userData['last name'] ?? '';

                        final userPhone = userData['phone'] ?? '';
                        final userEmail = userData['email'] ?? '';
                        final token = userData['token'] ?? '';
                        return Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: orderStatus == 0
                                    ? const Color.fromARGB(255, 251, 119, 110)
                                    : orderStatus == 1
                                        ? Color.fromARGB(255, 247, 247, 95)
                                        : orderStatus == 2
                                            ? const Color.fromARGB(
                                                255, 124, 244, 54)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                title: Text(
                                  'Order #$orderId',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Status: ${orderStatusText(orderStatus)}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Created At: $formattedCreatedAt',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Customer: $userNamef $userNamel',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone: $userPhone',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      'Email: $userEmail',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      items[index] as Map<String, dynamic>;
                                  final itemName = item['name'] ?? '';
                                  final itemPrice = item['price'] ?? '';
                                  final itemQuantity = item['quantity'] ?? '';

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        item['image'],
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                    title: Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Price: $itemPrice, Quantity: $itemQuantity',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<int>(
                                  value: orderStatus,
                                  items: orderStatusOptions.map((String value) {
                                    return DropdownMenuItem<int>(
                                      value: orderStatusOptions.indexOf(value),
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      updateOrderStatus(context, orderDocument,
                                          newValue, token);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox(); // Return an empty SizedBox if user data not available
                    });
              },
            );
          }

          return const Center(child: Text('No current orders available.'));
        },
      ),
    );
  }

  String orderStatusText(int orderStatus) {
    switch (orderStatus) {
      case 0:
        return 'Rejected';
      case 1:
        return 'Waiting';
      case 2:
        return 'Accepted, ready soon';
      case 3:
        return 'Done';
      default:
        return '';
    }
  }

  void updateOrderStatus(BuildContext context, DocumentSnapshot orderDocument,
      int newStatus, token) async {
    final orderId = orderDocument.id;
    final orderRef =
        FirebaseFirestore.instance.collection('orders').doc(orderId);

    orderRef.update({'orderStatus': newStatus}).then((value) {
      // Send notification to the client
      final userId = orderDocument['userId'];

      if (newStatus == 2) {
        sendnotifcation(
            title: 'Update your order status',
            body: 'Your ordrer Accepted, ready soon',
            token);
      } else if (newStatus == 3) {
        sendnotifcation(
            title: 'Update your order status',
            body: 'Your ordrer Done .. Take it',
            token);
      } else {
        sendnotifcation(
            title: 'Update your order status',
            body: 'Your ordrer Rejected',
            token);
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(
                'Order status updated to "${orderStatusText(newStatus)}" successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update order status: $error'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void sendnotifcation(token,
      {required String title, required String body}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAANpyixcE:APA91bGra46d8U0mLrDgrZ3ChxjyCfe4Q1rFCALGCHlNhrmBu-_PwDAvDS5-bZDqqns4bY0x663vftOcLeC_Vk1sJzzU7dRb9DxQy8MUB7086zCT8NTjt0e_z64g2JcebGziFehYjGPQ'
      };

      body = json.encode({
        "to": token,
        "notification": {"title": title, "body": body}
      });
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http.post(url, headers: headers, body: body);

      // request.headers.addAll(headers);

      // var response = await request.send();
      if (response.statusCode == 200) {
        print(response);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}
