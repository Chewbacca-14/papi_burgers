import 'dart:async';

import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  //Timer for the OTP code sending
  int seconds = 59;
  late Timer timer;
  bool canResendOTP = false;

  void startTimer() {
    seconds = 59;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (seconds > 0) {
        canResendOTP = false;
        seconds--;
        notifyListeners();
      } else {
        canResendOTP = true;
        notifyListeners();
      }
    });
    notifyListeners();
  }
}
