import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cartitem.dart';

final cartProvider = StateNotifierProvider<CartModel, List<CartItem>>((ref) {
  return CartModel();
});

// Define the CartModel class
class CartModel extends StateNotifier<List<CartItem>> {
  CartModel() : super([]);

  void addItem(CartItem item) {
    state = [item, ...state];
  }

  void removeItem(CartItem? item) {
    if (item != null) {
      state.removeWhere((element) => element.itemid == item.itemid);
    }
  }
}
