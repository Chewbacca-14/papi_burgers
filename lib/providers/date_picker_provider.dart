import 'package:flutter/material.dart';

class DateTimeProvider extends ChangeNotifier {

  

  var date = DateTime.now();
  late String _selectedDate; // Declare as late

  int _selectedHour = 00;
  int _selectedMinute = 00;

  DateTimeProvider() {
    _selectedDate = getFormattedText(date);
  }

  String get selectedDate => _selectedDate;
  int get selectedHour => _selectedHour;
  int get selectedMinute => _selectedMinute;

  void updateDate(String newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void updateTime(int newHour, int newMinute) {
    _selectedHour = newHour;
    _selectedMinute = newMinute;
    notifyListeners();
  }

  //new test
  //new test
  //new test
  List<int> hours = [];
  List<int> minutes = [];
  void generateTimeList(
      {required int minTime, required int maxTime, required bool isToday}) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    int currentMinute = now.minute;

    if (isToday) {
      if (currentMinute < 30) {
        minutes = List.generate(
            30 - currentMinute, (index) => currentMinute + 30 + index).toList();
        hours = List.generate(
            maxTime - currentHour + 1, (index) => currentHour + index).toList();
      } else {
        int minutesOfNextHour = 30 - (60 - currentMinute);
        hours = List.generate(
                maxTime - currentHour + 0, (index) => currentHour + index + 1)
            .toList();
        minutes = List.generate(
                60 - minutesOfNextHour, (index) => minutesOfNextHour + index)
            .toList();
      }
    } else {
      minutes = List.generate(60, (index) => index)
          .where((hour) => hour >= 0 && hour <= 59)
          .toList();
    hours = List.generate(maxTime - minTime + 1, (index) => index + minTime)
    .where((hour) => hour >= minTime && hour <= maxTime)
    .toList();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
    print('$hours');
    print('$minutes');
  }
}


String getFormattedText(DateTime date) {
    var daysOfWeek = ["пн.", "вт.", "ср.", "чт.", "пт.", "сб.", "вс."];
    var currentDay = date.day;
    var months = [
      "янв.",
      "фев.",
      "мар.",
      "апр.",
      "май",
      "июн.",
      "июл.",
      "авг.",
      "сен.",
      "окт.",
      "ноя.",
      "дек."
    ];
    var currentMonth = date.month;

    if (date == DateTime.now()) {
      return 'Сегодня';
    } else {
      return '${daysOfWeek[(date.weekday - 1) % 7]} $currentDay ${months[currentMonth - 1]}';
    }
  }