// // ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_order_application/screens/Auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:coffee_order_application/screens/Auth/LogIn.dart';

final _formKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final keyf = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String FisrtName;

  late String LastName;

  late String Email;

  late String PhoneNumuber;

  late String Password;

  String? ValidEmail(String? email) {
    RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[com]{3,3})$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^05\d{8}$').hasMatch(phoneNumber);
  }

  bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(name);
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$').hasMatch(password);
  }

  Future<void> deleteUserIfNotVerified(User? user) async {
    if (!user!.emailVerified) {
      await user.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 45),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'First name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onSaved: (newValue) {
                            FisrtName = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (!isValidName(value)) {
                              return 'Please enter a valid name (only characters are allowed)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Last name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          onSaved: (newValue) {
                            LastName = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (!isValidName(value)) {
                              return 'Please enter a valid name (only characters are allowed)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) {
                            Email = newValue!;
                          },
                          validator: ValidEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) {
                            PhoneNumuber = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!isValidPhoneNumber(value)) {
                              return 'Please enter a valid phone number (must start with 05 and contain 10 digits)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onSaved: (newValue) {
                            Password = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the password';
                            }
                            if (!isValidPassword(value!)) {
                              return 'Please enter a valid password \n'
                                  '(only characters and numbers allowed, minimum length 8)';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(200, 50),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 49, 49, 49),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              try {
                                final user =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: Email, password: Password);

                                if (user.user != null) {
                                  await user.user!.sendEmailVerification();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Verification email has been sent. Please verify your email.'),
                                    ),
                                  );

                                  String? deviceToken = await FirebaseMessaging
                                      .instance
                                      .getToken();

                                  await _firestore
                                      .collection('users')
                                      .doc(user.user!.uid)
                                      .set({
                                    'first name': FisrtName,
                                    'last name': LastName,
                                    'email': Email,
                                    'phone': PhoneNumuber,
                                    'token': deviceToken ?? ''
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Something is wrong!'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Do you have an account?'),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  top: 3,
                                  bottom: 2,
                                ),
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
