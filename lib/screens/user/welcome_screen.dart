// import 'dart:io';
import 'dart:io';

import 'package:coffee_order_application/services/notify.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/coffeeshop.dart';
import 'Select_Screen.dart';
// import 'package:image_picker/image_picker.dart';

import '/controllers/coffeeshopcontroller.dart';
import 'order_screen_page.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference ordersCollection =
    FirebaseFirestore.instance.collection('orders');

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

// ...

  Widget build(BuildContext context) {
    List<String> itemOffer = [
      'assets/star_offer.jpg',
      'assets/dunkin2_offer.png',
      'assets/tim_offer.jpeg',
      'assets/ratio_offer.avif',
      'assets/half2.png',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Adjust the width as needed
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            // Handle settings option
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Account Information'),
                          onTap: () {
                            // Handle account information option
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip),
                          title: const Text('Privacy Settings'),
                          onTap: () {
                            // Handle privacy settings option
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.security),
                          title: const Text('Security Settings'),
                          onTap: () {
                            // Handle security settings option
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Log Out'),
                          onTap: () {
                            Navigator.of(context).pop();

                            _auth.signOut(); // Close the dialog
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.sort_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OrderScreen()));
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});

          return Future<void>.delayed(
            const Duration(milliseconds: 500),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Find your coffee shop",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => SelectScreen(),
                    // ));
                  },
                  child: Container(
                    height: 180,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: -20,
                          right: 0,
                          child: Container(
                            height: 180,
                            child: PageView.builder(
                                controller:
                                    PageController(viewportFraction: 0.8),
                                itemCount: 5,
                                itemBuilder: (_, i) {
                                  return Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: AssetImage(itemOffer[i]),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: CoffeeShopController().getCoffeeShops(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          heightFactor: 100,
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('There is no shops open...'));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('something went wrong! try agian..'));
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return item(
                            snapshot.data![index].imagepath,
                            snapshot.data![index].name,
                            snapshot.data![index].location,
                            snapshot.data![index].name,
                            snapshot.data![index].name,
                            snapshot.data![index].name,
                            snapshot.data![index].status,
                            snapshot.data![index].id,
                            context,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget item(String itemPath, String itemName, var itemLocation, String itemTime,
    String itemPeople, String itemRating, int itemStatus, String id, context) {
  List<int> rating = [];
  double calculateAverageRating(List<int> ratings) {
    if (ratings.isEmpty) return 0.0;

    final sum = ratings.reduce((value, element) => value + element);
    return sum / ratings.length;
  }

  _locateMe(var p) async {
    LatLng? currentUserLocation;

    LatLng s = CoffeeShop.geoPointToLatLng(p);

    double lat = s.latitude;
    double lng = s.longitude;

    // double lat1 = 25.4407868;
    // double lng2 = 49.5837471;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentUserLocation = LatLng(position.latitude, position.longitude);

    // setState(() {
    //   currentUserLocation = LatLng(position.latitude, position.longitude);
    //   // mapController.animateCamera(CameraUpdate.newLatLng(currentUserLocation!));
    // });
    var das = Geolocator.distanceBetween(currentUserLocation!.latitude,
            currentUserLocation!.longitude, lat, lng) /
        1000;

    return das.round();
  }

  Future<void> classifyComments() async {
    final coffeeShopId = id;
    final commentsCollection = FirebaseFirestore.instance
        .collection('coffeeshops')
        .doc(coffeeShopId)
        .collection('comments');

    final commentsSnapshot =
        await commentsCollection.orderBy('timestamp').get();
    final comments =
        commentsSnapshot.docs.map((doc) => doc.data()['text']).toList();

    var url = Uri.parse('https://backend-oblc.onrender.com/predict');

    var headers = {
      'Content-Type': 'application/json',
    };

    for (var comment in comments) {
      var body = json.encode({'text': comment});

      try {
        var response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          Map responseData = json.decode(response.body);

          print(responseData);

          rating.add(responseData['predicted_rating']);
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (error) {
        print('Error sending POST request: $error');
      }
    }
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SelectScreen(id),
        ));
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 160,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: Image.network(itemPath).image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 20),
                            SizedBox(width: 1),
                            FutureBuilder(
                              future: _locateMe(itemLocation),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    heightFactor: 4,
                                    child: SizedBox(
                                        height: 4,
                                        width: 4,
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(child: Text(''));
                                }
                                if (snapshot.hasError) {
                                  return const Center(child: Text('...'));
                                }

                                return Text(
                                  "${(double.parse(snapshot.data.toString()) / 80 * 60).toStringAsFixed(0)} min",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 4),
                            FutureBuilder(
                              future: _locateMe(itemLocation),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    heightFactor: 4,
                                    child: SizedBox(
                                        height: 4,
                                        width: 4,
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(child: Text(''));
                                }
                                if (snapshot.hasError) {
                                  return const Center(child: Text('...'));
                                }

                                return Text(
                                  "${snapshot.data.toString()} km",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Icon(Icons.people, size: 20),
                            SizedBox(width: 4),
                            StreamBuilder<QuerySnapshot>(
                              stream: ordersCollection
                                  .where('orderStatus', whereIn: [2])
                                  .where('shopId', isEqualTo: id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    heightFactor: 4,
                                    child: SizedBox(
                                        height: 4,
                                        width: 4,
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(child: Text(''));
                                }
                                if (snapshot.hasError) {
                                  return const Center(child: Text('...'));
                                }

                                return Text(
                                    snapshot.data!.docs.length.toString());
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: itemStatus == 0
                      ? const Color.fromARGB(255, 177, 36, 26)
                      : Colors.green,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Text(
                  itemStatus == 0 ? 'Closed' : 'Open',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 0,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CommentDialog(id, rating);
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 44, 40, 40),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: classifyComments(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                                width: 7,
                                height: 7,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                          }

                          var a = calculateAverageRating(rating);
                          return Text(
                            '${a.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CommentDialog extends StatefulWidget {
  final String shopid;
  final List rating;
  CommentDialog(this.shopid, this.rating);
  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
  //     String userId) async {
  //   final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  //   final userData = await userRef.get();
  //   return userData;
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('coffeeshops')
                .doc(widget.shopid)
                .collection('comments')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Something went wrong! Please try again.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('There are no items...'));
              }

              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              // Process the retrieved documents here

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final documentData =
                      documents[index].data() as Map<String, dynamic>;
                  final r = widget.rating[index];
                  final comment = documentData['text'];
                  final timestamp = documentData['timestamp'].toDate();
                  final userId = documentData['userid'];
                  // String username = '';
                  // String email = '';

                  final formattedTimestamp =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                          title: Text(
                            comment,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            formattedTimestamp,
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: SizedBox(
                            height: 50,
                            width: 90,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: List.generate(
                                  r,
                                  (index) => const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      )),
                            ),
                          )),
                    ),
                  );
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      hintText: 'Enter your comment',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 60,
                  child: TextButton(
                    onPressed: () async {
                      String comment = _commentController.text;
                      if (comment.isNotEmpty) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('coffeeshops')
                              .doc(widget.shopid)
                              .collection('comments')
                              .doc()
                              .set({
                            'text': comment,
                            'timestamp': DateTime.now(),
                            'userid': FirebaseAuth.instance.currentUser!.uid
                          });

                          _commentController.clear();
                        } catch (e) {
                          print('Error adding comment: $e');
                        }
                      }
                    },
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
