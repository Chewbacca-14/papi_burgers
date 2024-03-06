import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/project_selecting_box/project_box.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/providers/restaurant_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProjectSelectingPage extends StatefulWidget {
  const ProjectSelectingPage({super.key});

  @override
  State<ProjectSelectingPage> createState() => _ProjectSelectingPageState();
}

class _ProjectSelectingPageState extends State<ProjectSelectingPage> {
  List projects = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    FirestoreDBProvider firestoreDBProvider =
        Provider.of<FirestoreDBProvider>(context, listen: false);
    return await firestoreDBProvider.getRestaurantsList();
  }

  void loadingTimer() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    loadingTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      body: FutureBuilder(
        future: getRestaurantData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> restaurantList = snapshot.data!;
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : ListView.builder(
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
          }
        },
      ),
    );
  }
}
