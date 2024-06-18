// import 'package:coffee_order_application/screens/order_screen_page.dart';
import 'package:coffee_order_application/screens/user/order_screen_page.dart';
import 'package:coffee_order_application/screens/user/orders.dart';
import 'package:coffee_order_application/screens/user/profile.dart';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenindex = 0;
  List screens = [
    WelcomeScreen(),
    const Placeholder(),
    OrdersPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(color: Colors.black),
        currentIndex: screenindex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.coffee_maker), label: 'My orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        onTap: (value) {
          setState(() {
            screenindex = value;
          });
        },
      ),
      body: screens[screenindex],
    ));
  }
}
