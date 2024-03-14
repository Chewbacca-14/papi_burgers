// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:papi_burgers/providers/date_picker_provider.dart';

import 'package:provider/provider.dart';

class DatePicker extends StatefulWidget {
  final int minTime;
  final int maxTime;
  const DatePicker({
    super.key,
    required this.maxTime,
    required this.minTime,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final dateController = FixedExtentScrollController();
  final hourController = FixedExtentScrollController();
  final minuteController = FixedExtentScrollController();
  List<DateTime> _dates = [];
  int _currentPage1 = 0;

  int _currentPage2 = 0;

  int _currentPage = 0;

  DateTime currentDate = DateTime.now();
  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);

    dateTimeProvider.generateTimeList(
        minTime: widget.minTime, maxTime: widget.maxTime, isToday: true);

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextDay = today.add(const Duration(days: 2));

    _dates = [today, tomorrow, nextDay];
    if (dateTimeProvider.hours.toString().contains('${currentDate.hour}')) {
      _currentPage1 = selectedHour = currentDate.hour;
    } else if (dateTimeProvider.minutes
        .toString()
        .contains('${currentDate.minute}')) {
      _currentPage2 = selectedMinute = currentDate.minute;
    }

    Future.delayed(const Duration(seconds: 1), () {
      hourController.animateToItem(selectedHour,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      minuteController.animateToItem(selectedMinute,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    });
  }

  List<DateTime> getDates() {
    DateTime currentDate = DateTime.now();
    List<DateTime> dates = [];

    for (int i = -1; i <= 2; i++) {
      DateTime date = currentDate.add(Duration(days: i));
      dates.add(date);
    }

    return dates;
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

  @override
  Widget build(BuildContext context) {
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          // date
          Container(
            alignment: Alignment.centerLeft,
            height: 95,
            width: 165,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: ListWheelScrollView.useDelegate(
                renderChildrenOutsideViewport: false,
                clipBehavior: Clip.none,
                itemExtent: 50,
                useMagnifier: true,
                physics: const FixedExtentScrollPhysics(),
                controller: dateController,
                onSelectedItemChanged: (index) {
                  if (index == 0) {}
                  dateTimeProvider.generateTimeList(
                      minTime: 12, maxTime: 18, isToday: index == 0);
                  final date = _dates[index];
                  setState(() {});
                  final formattedDate = getFormattedText(date);
                  setState(() {
                    _currentPage = index;
                    if (index >= 0 && index < _dates.length) {
                      context
                          .read<DateTimeProvider>()
                          .updateDate(formattedDate);
                    }
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _dates.length,
                  builder: (BuildContext context, int index) {
                    final date = _dates[index];
                    final formattedDate = getFormattedText(date);
                    return Row(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 16,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: _currentPage == index
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          // hour
          SizedBox(
            height: 95,
            width: 20,
            child: ListWheelScrollView.useDelegate(
              renderChildrenOutsideViewport: false,
              clipBehavior: Clip.none,
              itemExtent: 50,
              controller: hourController,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _currentPage1 = index;
                  selectedHour = dateTimeProvider.hours[index];
                  context
                      .read<DateTimeProvider>()
                      .updateTime(selectedHour, selectedMinute);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: dateTimeProvider.hours.length,
                builder: (BuildContext context, int index) {
                  final hour =
                      dateTimeProvider.hours[index].toString().padLeft(2, '0');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Center(
                      child: Container(
                        width: 102,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hour,
                              style: TextStyle(
                                fontSize: 16,
                                color: _currentPage1 == index
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: _currentPage1 == index
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 19.5),
          Text(
            ':',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
          ),

          const SizedBox(width: 19.5),
          // minute
          SizedBox(
            height: 95,
            width: 20,
            child: ListWheelScrollView.useDelegate(
              renderChildrenOutsideViewport: false,
              clipBehavior: Clip.none,
              itemExtent: 50,
              controller: minuteController,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _currentPage2 = index;
                  selectedMinute = dateTimeProvider.minutes[index];
                  context
                      .read<DateTimeProvider>()
                      .updateTime(selectedHour, selectedMinute);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: dateTimeProvider.minutes.length,
                builder: (BuildContext context, int index) {
                  final hour = dateTimeProvider.minutes[index]
                      .toString()
                      .padLeft(2, '0');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hour,
                              style: TextStyle(
                                fontSize: 16,
                                color: _currentPage2 == index
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: _currentPage2 == index
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void dateTaxiBottomSheet({
  required BuildContext context,
  required int minTime,
  required int maxTime,
}) {
  showModalBottomSheet<void>(
      backgroundColor: Colors.black,
      context: context,
      elevation: 25,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(30).copyWith(top: 0),
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            children: [
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 225, 225, 225),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Stack(
                children: [
                  DatePicker(minTime: minTime, maxTime: maxTime),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            height: 1,
                            width: 160,
                          ),
                          const Spacer(),
                          Container(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            height: 1,
                            width: 40,
                          ),
                          const SizedBox(width: 25),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Container(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              height: 1,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 71),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            height: 1,
                            width: 160,
                          ),
                          const Spacer(),
                          Container(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            height: 1,
                            width: 40,
                          ),
                          const SizedBox(width: 24.9),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Container(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              height: 1,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
