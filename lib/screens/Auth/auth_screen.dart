import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_order_application/screens/Auth/LogIn.dart';
import 'package:coffee_order_application/screens/admin/admin.dart';
// import 'package:coffee_order_application/screens/coffeeshop/CoffeeShopPanel2.dart';
import 'package:coffee_order_application/screens/coffeeshop/coffeeshopscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../coffeeshop/CoffeeShopPanel.dart';
import '../user/home_screen.dart';

// import 'home_screen.dart';

// ignore: must_be_immutable
class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              semanticsLabel: 'Login...',
            ),
          );
        }

        // && _auth.currentUser!.emailVerified

        if (snapshot.hasData) {
          final user = snapshot.data!.uid;
          return FutureBuilder(
            future: _firestore.collection('admins').doc(user).get(),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    semanticsLabel: 'Loading...',
                  ),
                );
              }

              if (adminSnapshot.hasData && adminSnapshot.data!.exists) {
                // User is an admin
                return Admin();
              } else {
                return FutureBuilder(
                  future: _firestore.collection('users').doc(user).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                          semanticsLabel: 'Loading...',
                        ),
                      );
                    }

                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      // User is a regular user
                      return const HomeScreen();
                    } else {
                      return FutureBuilder(
                        future: _firestore
                            .collection('coffeeshops')
                            .doc(user)
                            .get(),
                        builder: (context, coffeeShopSnapshot) {
                          if (coffeeShopSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                                semanticsLabel: 'Loading...',
                              ),
                            );
                          }

                          if (coffeeShopSnapshot.hasData &&
                              coffeeShopSnapshot.data!.exists) {
                            // User is a coffee shop owner
                            return CoffeeShopPanel();
                          } else {
                            // User is not found in any of the collections, show the login page

                            return LoginPage();
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        } else {
          // User is not logged in, show the login page
          return LoginPage();
        }
      },
    );
  }
}
