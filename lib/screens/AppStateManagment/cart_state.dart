import 'package:flutter/material.dart';

class CartState {
  // 🔔 Notifier for cart count
  static ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  // 🛒 Store cart items (basic structure)
  static List<Map<String, dynamic>> cartItems = [];

  // ➕ Add item
  static void addToCart(Map<String, dynamic> product) {
    cartItems.add(product);
    cartCount.value = cartItems.length;
  }

  // ➖ Remove item
  static void removeFromCart(Map<String, dynamic> product) {
    cartItems.remove(product);
    cartCount.value = cartItems.length;
  }

  // 🧹 Clear cart
  static void clearCart() {
    cartItems.clear();
    cartCount.value = 0;
  }
}