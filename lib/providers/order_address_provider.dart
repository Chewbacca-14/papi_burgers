import 'package:flutter/cupertino.dart';
import 'package:papi_burgers/models/address_model.dart';

class OrderAddressProvider extends ChangeNotifier {
  Address _orderAddress = Address(
      address: 'Выберите адрес',
      frontDoorNumber: -1,
      numberFlat: -1,
      floor: -1);

  Address get orderAddress => _orderAddress;

  void changeOrderAddress(Address value) {
    _orderAddress = value;
    notifyListeners();
  }
}
