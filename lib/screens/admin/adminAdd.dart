// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AdminAdd extends StatefulWidget {
//   @override
//   State<AdminAdd> createState() => _AdminAddPageState();
// }

// class _AdminAddPageState extends State<AdminAdd>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late String _coffeeShopNameController;
//   late String _locationController;
//   late String _emailController;
//   late String _passwordController;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final firestorage = FirebaseStorage.instance;

//   File? image;

//   void imagepick() async {
//     var i = ImagePicker();

//     var pickedimage = await i.pickImage(source: ImageSource.gallery);

//     if (pickedimage != null) {
//       setState(() {
//         image = File(pickedimage.path);
//       });

//       // widget.pickedimage(image!);
//     }
//   }

//   // Declare a global key for the form
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
//     _tabController.addListener(_handleTabSelection);

//     super.initState();
//   }

//   _handleTabSelection() {
//     if (_tabController.indexIsChanging) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _addCoffeeShop() async {
//     // Validate the form before performing any action
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       try {
//         final user = await _auth.createUserWithEmailAndPassword(
//             email: _emailController, password: _passwordController);

//         await _firestore.collection('coffeeshops').doc(user.user!.uid).set({
//           'coffeeShopName': _coffeeShopNameController,
//           'location': _locationController,
//           'email': _emailController,
//           'status': 0,
//         });

//         var storageRef = FirebaseStorage.instance
//             .ref()
//             .child('images/${user.user!.uid}.jpg');
//         var uploadTask = storageRef.putFile(image!);

//         var downloadUrl = await (await uploadTask).ref.getDownloadURL();

//         await _firestore.collection('coffeeshops').doc(user.user!.uid).update({
//           'imagepath': downloadUrl,
//         });
//       } catch (e) {}
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.black,
//                         size: 35,
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {},
//                       child: const Icon(
//                         Icons.notifications,
//                         color: Colors.black,
//                         size: 35,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Add Panel",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Form(
//                   key: _formKey, // Assign the global key to the form
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter the name of the coffee shop";
//                           }
//                           return null;
//                         },
//                         onSaved: (newValue) {
//                           _coffeeShopNameController = newValue!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: "Name of Coffee Shop",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       CircleAvatar(
//                         maxRadius: 80,
//                         foregroundImage:
//                             image == null ? null : FileImage(image!),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: imagepick,
//                         child: const Text("Upload Image"),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter the location";
//                           }
//                           return null;
//                         },
//                         onSaved: (newValue) {
//                           _locationController = newValue!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: "Location",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter the email";
//                           }
//                           return null;
//                         },
//                         onSaved: (newValue) {
//                           _emailController = newValue!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: "Email",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter the password";
//                           }
//                           return null;
//                         },
//                         onSaved: (newValue) {
//                           _passwordController = newValue!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: "Password",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _addCoffeeShop,
//                         child: const Text("Add"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAdd extends StatefulWidget {
  @override
  State<AdminAdd> createState() => _AdminAddPageState();
}

class _AdminAddPageState extends State<AdminAdd>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _coffeeShopNameController;
  late double _latitude;
  late double _longitude;
  late String _emailController;
  late String _passwordController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestorage = FirebaseStorage.instance;

  File? image;

  void imagepick() async {
    var i = ImagePicker();

    var pickedimage = await i.pickImage(source: ImageSource.gallery);

    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
      });
    }
  }

  // Declare a global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addCoffeeShop() async {
    // Validate the form before performing any action
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final user = await _auth.createUserWithEmailAndPassword(
            email: _emailController, password: _passwordController);

        await _firestore.collection('coffeeshops').doc(user.user!.uid).set({
          'coffeeShopName': _coffeeShopNameController,
          'location': GeoPoint(_latitude, _longitude), // Saving GeoPoint
          'email': _emailController,
          'status': 0,
        });

        var storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${user.user!.uid}.jpg');
        var uploadTask = storageRef.putFile(image!);

        var downloadUrl = await (await uploadTask).ref.getDownloadURL();

        await _firestore.collection('coffeeshops').doc(user.user!.uid).update({
          'imagepath': downloadUrl,
        });
      } catch (e) {}
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Add Panel",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey, // Assign the global key to the form
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the name of the coffee shop";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _coffeeShopNameController = newValue!;
                        },
                        decoration: const InputDecoration(
                          labelText: "Name of Coffee Shop",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      CircleAvatar(
                        maxRadius: 80,
                        foregroundImage:
                            image == null ? null : FileImage(image!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: imagepick,
                        child: const Text("Upload Image"),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the latitude";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _latitude = double.tryParse(value) ?? 0.0;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Latitude",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the longitude";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _longitude = double.tryParse(value) ?? 0.0;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Longitude",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the email";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _emailController = newValue!;
                        },
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the password";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _passwordController = newValue!;
                        },
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addCoffeeShop,
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
