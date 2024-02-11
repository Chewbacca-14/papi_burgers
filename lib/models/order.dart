// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:papi_burgers/models/menu_item.dart';

class Order {
  final String id;
  final String userId;
  final List<MenuItem> menuItems;
  final int deliveryPrice;
  final int totalPrice;

  Order(
      {required this.id,
      required this.userId,
      required this.menuItems,
      required this.deliveryPrice,
      required this.totalPrice});
}

enum OrderStatus { f }

class CartItem {
  final MenuItem menuItem;
  int quantity;
  CartItem({
    required this.menuItem,
    required this.quantity,
  });

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'menuItem': menuItem.toMap(),
      'quantity': quantity,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CartItem(menuItem: $menuItem, quantity: $quantity)';

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.menuItem == menuItem && other.quantity == quantity;
  }

  @override
  int get hashCode => menuItem.hashCode ^ quantity.hashCode;
}
