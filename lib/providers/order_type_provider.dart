import 'package:flutter/cupertino.dart';

class OrderTypeProvider extends ChangeNotifier {
  bool _isDelivery = true;

  bool get isDelivery => _isDelivery;

  void changeType(bool value) {
    _isDelivery = value;
    notifyListeners();
  }
}
