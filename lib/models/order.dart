// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:papi_burgers/models/menu_item.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<MenuItem> menuItems;
  final int deliveryPrice;
  final int totalPrice;
  final bool isTakeAway;
  // final String phone;
  // final String address;
  // final String name;
  // final String? comment;
  // final String datetime;
  // final bool isCashPayment;
  // final String orderStatus;
  // final DateTime orderTimestamp;
  // final String paymentStatus;

  OrderModel({
    required this.id,
    required this.userId,
    required this.menuItems,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.isTakeAway,
    // required this.phone,
    // required this.address,
    // required this.name,
    // required this.comment,
    // required this.datetime,
    // required this.isCashPayment,
    // required this.orderStatus,
    // required this.orderTimestamp,
    // required this.paymentStatus,
  });
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
