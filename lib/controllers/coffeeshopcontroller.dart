import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/coffeeshop.dart';

class CoffeeShopController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static List<CoffeeShop> _coffeeShops = [];

  Future<List<CoffeeShop>> getCoffeeShops() async {
    // if (_coffeeShops.isNotEmpty) {
    //   return _coffeeShops;
    // }

    QuerySnapshot snapshot = await _firestore.collection('coffeeshops').get();
    var docs = snapshot.docs.map((doc) => doc).toList();
    _coffeeShops = docs
        .map((e) => CoffeeShop(
            name: e['coffeeShopName'],
            location: e['location'],
            email: e['email'],
            id: e.id,
            status: e['status'],
            imagepath: e['imagepath']))
        .toList();
    return _coffeeShops;
  }

  // Future<void> addCoffeeShop(CoffeeShop coffeeShop) async {
  //   await _firestore.collection('coffee_shops').add(coffeeShop.toMap());
  //   _coffeeShops.add(coffeeShop);
  // }

  // Future<void> updateCoffeeShop(CoffeeShop coffeeShop) async {
  //   await _firestore.collection('coffee_shops').doc(coffeeShop.id).update(coffeeShop.toMap());
  //   int index = _coffeeShops.indexWhere((shop) => shop.id == coffeeShop.id);
  //   if (index != -1) {
  //     _coffeeShops[index] = coffeeShop;
  //   }
  // }

  // Future<void> deleteCoffeeShop(CoffeeShop coffeeShop) async {
  //   await _firestore.collection('coffee_shops').doc(coffeeShop.id).delete();
  //   _coffeeShops.removeWhere((shop) => shop.id == coffeeShop.id);
  // }
}
