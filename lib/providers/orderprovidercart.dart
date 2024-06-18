import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cartitem.dart';

final cartProviderCart = StateNotifierProvider<CartModelCart, String>((ref) {
  return CartModelCart();
});

// Define the CartModel class
class CartModelCart extends StateNotifier<String> {
  CartModelCart() : super('');

  void addItem(shop) {
    state = shop;
  }

  void removeItem() {
    state = '';
  }
}
