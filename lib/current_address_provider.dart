import 'package:flutter/material.dart';

class CurrentAddressProvider extends ChangeNotifier{
 String currentAddress = 'Выбрать вручную';

  void changeCurrentAddress(String newAddress) {
    currentAddress = newAddress;
     notifyListeners();
  }
}