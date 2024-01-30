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
