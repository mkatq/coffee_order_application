// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:coffee_order_application/services/database.dart';
// import 'package:random_string/random_string.dart';
// import 'dart:io';

// class AddCoffee extends StatefulWidget {
//   @override
//   State<AddCoffee> createState() => _AddCoffeePanel();
// }

// class _AddCoffeePanel extends State<AddCoffee> {
//   String _selectedOption = 'Hot Coffee';

//   File? file;
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

//   // Variables
//   late GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   TextEditingController nameController = new TextEditingController();
//   TextEditingController priceController = new TextEditingController();
//   TextEditingController ingredientsController = new TextEditingController();
//   late String catagoryController;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final firestorage = FirebaseStorage.instance;
//   @override
//   void dispose() {
//     // Clean up the controllers when the widget is disposed
//     super.dispose();
//   }

//   void _submitForm() {
//     final form = _formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       // TODO: Implement form submission logic
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(15),
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
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.black,
//                         size: 35,
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {},
//                       child: Icon(
//                         Icons.notifications,
//                         color: Colors.black,
//                         size: 35,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   "Add Panel",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: "Name of Coffee",
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter the name of the coffee';
//                           }
//                           return null;
//                         },
//                         controller: nameController,
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: "Price of Coffee",
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter the price of the coffee';
//                           }
//                           return null;
//                         },
//                         controller: priceController,
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: "Catagory",
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter the Catagory of the coffee';
//                           }
//                           return null;
//                         },
//                         onSaved: (newValue) {
//                           catagoryController = newValue!;
//                         },
//                       ),
//                       SizedBox(height: 20),
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
//                       SizedBox(height: 20),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: "Ingredients of Coffee",
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter the ingredients of the coffee';
//                           }
//                           return null;
//                         },
//                         controller: ingredientsController,
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           // String id = randomAlphaNumeric(10);

//                           _formKey.currentState!.save();

//                           var storageRef = FirebaseStorage.instance
//                               .ref()
//                               .child('items/${_auth.currentUser!.uid}.jpg');
//                           var uploadTask = storageRef.putFile(image!);
//                           late int intValue;
//                           try {
//                             intValue = int.parse(priceController.text!);
//                             print('Received integer value: $intValue');
//                           } catch (e) {
//                             // Handle invalid input
//                           }

//                           var downloadUrl =
//                               await (await uploadTask).ref.getDownloadURL();
//                           Map<String, dynamic> ProductInfoMap = {
//                             "itemname": nameController.text,
//                             "itemprice": intValue,
//                             "ingredients": ingredientsController.text,
//                             "catagory": catagoryController,
//                             "imagepath": downloadUrl
//                           };
//                           await DatabaseMethods()
//                               .AddProduct(ProductInfoMap)
//                               .then((value) {
//                             Fluttertoast.showToast(
//                                 msg: "Product added succufully",
//                                 toastLength: Toast.LENGTH_SHORT,
//                                 timeInSecForIosWeb: 1,
//                                 backgroundColor: Colors.green,
//                                 textColor: Colors.white,
//                                 fontSize: 16.0);
//                           });
//                         },
//                         child: Text("Submit"),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coffee_order_application/services/database.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';

class AddCoffee extends StatefulWidget {
  @override
  State<AddCoffee> createState() => _AddCoffeePanel();
}

class _AddCoffeePanel extends State<AddCoffee> {
  String _selectedOption = 'Hot Coffee';

  File? file;
  File? image;

  void imagepick() async {
    var i = ImagePicker();

    var pickedimage = await i.pickImage(source: ImageSource.gallery);

    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
      });

      // widget.pickedimage(image!);
    }
  }

  // Variables
  late GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController ingredientsController = new TextEditingController();
  late String catagoryController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestorage = FirebaseStorage.instance;
  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    super.dispose();
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // TODO: Implement form submission logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Add Panel",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name of Coffee",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the name of the coffee';
                          }
                          return null;
                        },
                        controller: nameController,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Price of Coffee",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the price of the coffee';
                          }
                          return null;
                        },
                        controller: priceController,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Catagory",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Catagory of the coffee';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          catagoryController = newValue!;
                        },
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ingredients of Coffee",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the ingredients of the coffee';
                          }
                          return null;
                        },
                        controller: ingredientsController,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // String id = randomAlphaNumeric(10);

                          _formKey.currentState!.save();

                          var storageRef = FirebaseStorage.instance.ref().child(
                              'items/${DateTime.now().millisecondsSinceEpoch}.jpg');
                          var uploadTask = storageRef.putFile(image!);
                          late int intValue;
                          try {
                            intValue = int.parse(priceController.text!);
                            print('Received integer value: $intValue');
                          } catch (e) {
                            // Handle invalid input
                          }

                          var downloadUrl =
                              await (await uploadTask).ref.getDownloadURL();
                          Map<String, dynamic> ProductInfoMap = {
                            "itemname": nameController.text,
                            "itemprice": intValue,
                            "ingredients": ingredientsController.text,
                            "catagory": catagoryController,
                            "imagepath": downloadUrl
                          };
                          await DatabaseMethods()
                              .AddProduct(ProductInfoMap)
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "Product added succufully",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        },
                        child: Text("Submit"),
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
