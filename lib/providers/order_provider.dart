import 'package:flutter/cupertino.dart';
import 'package:papi_burgers/models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> orders = [];

  void addOrder(List<OrderModel> newOrders) {
    orders = newOrders;
  }
}
