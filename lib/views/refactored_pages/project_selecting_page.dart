import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:papi_burgers/providers/internet_status_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/project_selecting_box/project_box.dart';

import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/providers/restaurant_provider.dart';
import 'package:papi_burgers/views/refactored_pages/not_connected_page.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProjectSelectingPage extends StatefulWidget {
  const ProjectSelectingPage({super.key});

  @override
  State<ProjectSelectingPage> createState() => _ProjectSelectingPageState();
}

class _ProjectSelectingPageState extends State<ProjectSelectingPage> {
  List projects = [];

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    FirestoreDBProvider firestoreDBProvider =
        Provider.of<FirestoreDBProvider>(context, listen: false);
    return await firestoreDBProvider.getRestaurantsList();
  }

  void loadingTimer() {}

  bool internetConnected = true;

  @override
  void initState() {
    loadingTimer();
    super.initState();
    checkInternetConnection();
  }

  void checkInternetConnection() {
    final connectionProvider =
        Provider.of<InternetStatusProvider>(context, listen: false);
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      connectionProvider.updateStatus(status);
      if (status == InternetStatus.disconnected) {
        Navigator.pushReplacementNamed(context, '/not-connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    return internetConnected
        ? Scaffold(
            backgroundColor: const Color.fromARGB(255, 43, 43, 43),
            body: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SvgPicture.asset(
                    'assets/project_bg.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                FutureBuilder(
                  future: getRestaurantData(),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SvgPicture.asset('assets/pb_logo.svg'),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      List<Map<String, dynamic>> restaurantList =
                          snapshot.data!;
                      return ListView.builder(
                        itemCount: restaurantList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                restaurantProvider.changeRestaurantName(
                                    restaurantList[index]['id']);
                                context.router.replace(HomeRoute());
                              } catch (e) {
                                showCustomSnackBar(
                                    context, '$e', AnimatedSnackBarType.error);
                              }
                            },
                            child: ProjectBox(
                              logoImage: restaurantList[index]['logoUrl'],
                              mainImage: restaurantList[index]['mainImage'],
                              projectName: restaurantList[index]['name'],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                  },
                ),
              ],
            ),
          )
        : const NotConnectedPage();
  }
}
