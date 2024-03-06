import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:papi_burgers/models/location_model.dart';

class CurrentAddressProvider extends ChangeNotifier {
  String currentAddress = 'Выбрать вручную';
  double latitude = -1;
  double longtitude = -1;
  bool isAddressFromMap = true;

  void changeCurrentAddress(LocationModel newAddress) {
    if (isAddressFromMap) {
      currentAddress = newAddress.address;
      latitude = -1;
      longtitude = -1;
    } else {
      currentAddress = newAddress.address;
      latitude = newAddress.latitude;
      longtitude = newAddress.longtitude;
    }
    log('''
[CURRENT LOCATION PROVIDER]

---------

Current address: $currentAddress
Latitude: $latitude
Longtitude: $longtitude
isFromMap: $isAddressFromMap
''');
    notifyListeners();
  }
}
