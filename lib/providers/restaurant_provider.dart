import 'dart:developer';

import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  String restaurantName = '';

  void changeRestaurantName(String newRestaurantName) {
    restaurantName = newRestaurantName;
    log('[RESTAURANT PROVIDER] new restauran name = $restaurantName');
    notifyListeners();
  }
}
