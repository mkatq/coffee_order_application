// import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> loginUser(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       await _checkUserRole();
//     } catch (e) {
//       throw Exception('Error logging in: $e');
//     }
//   }

//   Future<void> _checkUserRole() async {
//     User? currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       DocumentSnapshot userDoc = await _firestore.collection('admins').doc(currentUser.uid).get();
//       if (userDoc.exists) {
//         // User is an admin
//         updateUI('admin');
//       } else {
//         DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
//         if (userDoc.exists) {
//           // User is a regular user
//           updateUI('user');
//         } else {
//           DocumentSnapshot userDoc = await _firestore.collection('coffee_shops').doc(currentUser.uid).get();
//           if (userDoc.exists) {
//             // User is a coffee shop owner
//             updateUI('coffee_shop');
//           } else {
//             // User is not found in any collection
//             updateUI('unknown');
//           }
//         }
//       }
//     } else {
//       // No user is signed in
//       updateUI('not_signed_in');
//     }
//   }

//    void updateUI(BuildContext context, String role) {
//     switch (role) {
//       case 'admin':
//         // Navigate to the admin dashboard or home screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AdminDashboard()),
//         );
//         break;
//       case 'customer':
//         // Navigate to the customer home screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CustomerHomeScreen()),
//         );
//         break;
//       default:
//         // Handle the case when the role is not recognized
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Invalid user role.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//         break;
//     }
//   }
// }