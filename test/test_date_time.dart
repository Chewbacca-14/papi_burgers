void main() {
  void generateTimeList({required int minTime, required int maxTime}) {
  DateTime now = DateTime.now();
  int currentHour = now.hour;
  int currentMinute = now.minute;

  List<int> hours = List.generate(24, (index) => index)
      .where((hour) => hour >= minTime && hour <= maxTime)
      .toList();

  List<int> minutes;
  if (currentMinute < 30) {
    minutes = List.generate(30 - currentMinute, (index) => currentMinute + index);
  } else {
    minutes = List.generate(60 - currentMinute + 30, (index) => currentMinute + index - 60);
    if (hours.isNotEmpty) {
      hours = hours.map((hour) => hour == 23 ? 0 : hour + 1).toList();
    }
  }

  print('Hours: $hours');
  print('Minutes: $minutes');
}

}