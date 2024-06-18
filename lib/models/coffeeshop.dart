import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'order.dart';

class CoffeeShop {
  String id;
  String name;
  var location;
  String email;
  int status;
  String imagepath;

  CoffeeShop({
    required this.id,
    required this.name,
    required this.location,
    required this.email,
    required this.status,
    required this.imagepath,
  });

// Function to convert GeoPoint to LatLng
  static LatLng geoPointToLatLng(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  void addShop() {
    // Code to add a new coffee shop
  }

  void updateShopInfo() {
    // Code to update the coffee shop's information
  }

  void deleteShop() {
    // Code to delete a coffee shop
  }

  // void acceptOrder(Order order) {
  //   // Code to accept an order
  // }

  // void fulfillOrder(Order order) {
  //   // Code to fulfill an order
  // }

  // void rejectOrder(Order order) {
  //   // Code to reject an order
  // }
}
