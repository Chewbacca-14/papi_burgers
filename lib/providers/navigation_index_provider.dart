import 'package:flutter/material.dart';

class NavigationIndexProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
