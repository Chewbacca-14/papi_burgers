import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/notification_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {


  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Max Bulanovich',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  h6,
                  Text(
                    '+7 987 453 45 22',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 153, 153, 153),
                    ),
                  ),
                  h25,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 57),
                    child: NotificationCard(),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
