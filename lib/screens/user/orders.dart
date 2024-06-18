import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/notify.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.coffee_maker), onPressed: () {}),
        title: const Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'Previous'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Current Orders Tab
          StreamBuilder<QuerySnapshot>(
            stream: ordersCollection
                .where('orderStatus', whereIn: [0, 1, 2])
                .where('userId', isEqualTo: _auth.currentUser!.uid)
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
                    final orderData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final orderDocument = snapshot.data!.docs[index];
                    final orderId = orderDocument.id;
                    final orderStatus = orderData['orderStatus'] ?? '';
                    final createdAt = orderData['createdAt'] ?? '';
                    final formattedCreatedAt = DateFormat('MMM d, yyyy h:mm a')
                        .format(createdAt.toDate());

                    final items = orderData['items'] as List<dynamic>;

                    return Card(
                      elevation: 4, // Add elevation for a raised effect
                      color:
                          Colors.white, // Set the background color of the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Add rounded corners to the card
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 1), // Add a border around the card
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
                                        : const Color.fromARGB(255, 255, 255,
                                            255), // Set a background color for the ListTile
                            title: Text(
                              'Order #$orderId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${orderStatus == 0 ? 'Rejected' : orderStatus == 1 ? 'Waiting' : orderStatus == 2 ? 'Accepted, ready soon' : 'Done'}',
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index] as Map<String, dynamic>;
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
                        ],
                      ),
                    );
                  },
                );
              }

              return const Center(child: Text('No current orders available.'));
            },
          ),
          // Previous Orders Tab
          StreamBuilder<QuerySnapshot>(
            stream: ordersCollection
                .where('orderStatus', isEqualTo: 3)
                .where('userId', isEqualTo: _auth.currentUser!.uid)
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
                    final orderData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final orderDocument = snapshot.data!.docs[index];
                    final orderId = orderDocument.id;
                    final orderStatus = orderData['orderStatus'] ?? '';
                    final createdAt = orderData['createdAt'] ?? '';
                    final formattedCreatedAt = DateFormat('MMM d, yyyy h:mm a')
                        .format(createdAt.toDate());

                    final items = orderData['items'] as List<dynamic>;

                    return Card(
                      elevation: 4, // Add elevation for a raised effect
                      color:
                          Colors.white, // Set the background color of the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Add rounded corners to the card
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 1), // Add a border around the card
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: Colors.blue[
                                100], // Set a background color for the ListTile
                            title: Text(
                              'Order #$orderId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Status: Done ',
                              style: TextStyle(
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index] as Map<String, dynamic>;
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
                        ],
                      ),
                    );
                  },
                );
              }

              return const Center(child: Text('No current orders available.'));
            },
          ),
        ],
      ),
    );
  }
}
