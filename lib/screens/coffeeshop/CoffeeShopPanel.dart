import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coffee_order_application/screens/coffeeshop/BlockUsers.dart';
import 'package:coffee_order_application/screens/coffeeshop/BlockedUsers.dart';
import 'package:coffee_order_application/screens/coffeeshop/ChangeIngredients.dart';
import 'package:coffee_order_application/screens/coffeeshop/ChangePriceScreen.dart';
import 'package:coffee_order_application/screens/coffeeshop/CurrentOrder.dart';
import 'package:coffee_order_application/screens/coffeeshop/DeleteCoffee.dart';
import 'package:coffee_order_application/screens/coffeeshop/PreviousOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffee_order_application/screens/coffeeshop/AddCoffee.dart';

class CoffeeShopPanel extends StatefulWidget {
  const CoffeeShopPanel({Key? key}) : super(key: key);

  @override
  State<CoffeeShopPanel> createState() => _CoffeeShopPage();
}

class _CoffeeShopPage extends State<CoffeeShopPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isButtonOn = false; // Initial state of the button

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

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _auth.signOut();
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  Switch(
  value: isButtonOn,
  onChanged: (value) async {
    setState(() {
      isButtonOn = value;
    });
    final coffeeShopRef = FirebaseFirestore.instance.collection('coffeeshops').doc(_auth.currentUser!.uid);
    await coffeeShopRef.update({'status': isButtonOn ? 1 : 0});
  },
  activeColor: Colors.blue,
),
                  GestureDetector(
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
                "CoffeeShop Panel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    buildCustomButton(
                      context,
                      'Add Coffee',
                      Colors.green,
                      Colors.white,
                      Icons.add,
                      AddCoffee(),
                    ),
                    buildCustomButton(
                      context,
                      'Delete Coffee',
                      Colors.red,
                      Colors.white,
                      Icons.delete,
                      DeleteCoffee(_auth.currentUser!.uid),
                    ),
                    buildCustomButton(
                      context,
                      'Change Price',
                      Colors.orange,
                      Colors.white,
                      Icons.attach_money,
                      ChangePrice(_auth.currentUser!.uid),
                    ),
                    buildCustomButton(
                      context,
                      'Change Ingredients',
                      Colors.blue,
                      Colors.white,
                      Icons.settings,
                      ChangeIngredients(_auth.currentUser!.uid),
                    ),
                    buildCustomButton(
                      context,
                      'Current Order',
                      Colors.purple,
                      Colors.white,
                      Icons.shopping_cart,
                      CurrentOrder(),
                    ),
                    buildCustomButton(
                      context,
                      'Previous Order',
                      Colors.teal,
                      Colors.white,
                      Icons.history,
                      PreviousOrder(),
                    ),
                    buildCustomButton(
                      context,
                      'Block Users',
                      Colors.indigo,
                      Colors.white,
                      Icons.block,
                      BlockUsers(),
                    ),
                    buildCustomButton(
                      context,
                      'Blocked Users',
                      Colors.brown,
                      Colors.white,
                      Icons.block_outlined,
                      BlockedUsers(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    IconData icon,
    Widget? screen,
  ) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          // Perform action for buttons without a screen
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

