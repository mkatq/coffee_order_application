import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_order_application/screens/user/order_screen_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_order_application/screens/user/welcome_screen.dart';
import 'package:coffee_order_application/widgets/item_widget_PriceChange.dart';

class ChangePrice extends StatefulWidget {
  final String id;

  const ChangePrice(this.id, {Key? key}) : super(key: key);

  @override
  _ChangePricePage createState() => _ChangePricePage();
}

class _ChangePricePage extends State<ChangePrice>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _firestore
                .collection('coffeeshops')
                .doc(widget.id)
                .collection('items')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('There are no items...'));
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Something went wrong! Please try again.'));
              }

              var data = snapshot.data!.docs;

              // Extracting unique categories from the items
              var categories =
                  data.map((e) => e['catagory']).toSet().toList();

              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
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
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderScreen()));
                            },
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Category",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 76, 0, 255),
                        unselectedLabelColor: Colors.black,
                        isScrollable: true,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 76, 0, 255),
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        labelStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        tabs: categories
                            .map((category) => Tab(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(category),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: categories.map((category) {
                        var categoryItems = data
                            .where((item) => item['catagory'] == category)
                            .toList();
                        return GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: (150 / 195),
                          children: categoryItems
                              .map((e) => ItemWidget(
                                    nameitem: e['itemname'],
                                    priceitem: e['itemprice'],
                                    imagepath: e['imagepath'],
                                    ingredients: e['ingredients'],
                                    iditem: e.id,
                                    id: widget.id,
                                  ))
                              .toList(),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
