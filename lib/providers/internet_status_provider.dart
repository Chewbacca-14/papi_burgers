import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetStatusProvider extends ChangeNotifier {
  InternetStatus _status = InternetStatus.connected;

  InternetStatus get status => _status;

  void updateStatus(InternetStatus status) {
    _status = status;
    notifyListeners();
  }
}
