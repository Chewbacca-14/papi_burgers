import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isNotificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 241, 241, 241),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: grey9,
                  size: 28,
                ),
                const Text(
                  'Уведомления',
                  style: TextStyle(
                      fontSize: 16, color: grey9, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 28,
                  width: 36,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: grey9,
                        activeTrackColor: const Color.fromARGB(255, 47, 73, 34),
                        activeColor: Colors.white,
                        value: isNotificationsOn,
                        onChanged: (value) {
                          setState(() {
                            isNotificationsOn = value;
                          });
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
