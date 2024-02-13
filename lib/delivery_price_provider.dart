import 'package:flutter/material.dart';

class DeliveryPriceProvider extends ChangeNotifier {
  int deliveryPrice = 250;

  void changeDeliveryPrice(int newPrice) {
    deliveryPrice = newPrice;
    notifyListeners();
  }
}
