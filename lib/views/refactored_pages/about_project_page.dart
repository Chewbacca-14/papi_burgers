import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/work_position_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AboutProjectPage extends StatefulWidget {
  const AboutProjectPage({super.key});

  @override
  State<AboutProjectPage> createState() => _AboutProjectPageState();
}

class _AboutProjectPageState extends State<AboutProjectPage> {
  String restaurantDescription = '';
  String restaurantName = '';
  String logoUrl =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fdesignpowers.com%2Fblog%2Furl-best-practices&psig=AOvVaw0s9pgomSGUclZDl9HovM-v&ust=1708864361930000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKD_8Pv9w4QDFQAAAAAdAAAAABAE';

  List positions = [];

  Future<void> getAllRestaurantData() async {
    FirestoreDBProvider firestoreDBProvider =
        Provider.of<FirestoreDBProvider>(context, listen: false);

    DocumentSnapshot<Map<String, dynamic>> restaurantData =
        await firestoreDBProvider.getAllRestaurantData();

    setState(() {
      restaurantDescription = restaurantData['restaurantDescription'];
      restaurantName = restaurantData['name'];
      logoUrl = restaurantData['logoUrl'];
      positions = restaurantData['positions'];
    });
  }

  @override
  void initState() {
    getAllRestaurantData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  w12,
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                  const Text(
                    'О проекте & Вакансии',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                decoration: const BoxDecoration(
                  color: greyf1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          w20,
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 1, color: greyf1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(34, 0, 0, 0),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(logoUrl)),
                          ),
                          w20,
                          Text(
                            restaurantName,
                            style: const TextStyle(
                                fontSize: 25,
                                color: grey4,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                      h25,
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryColor,
                          ),
                          w12,
                          Text(
                            'О проекте',
                            style: TextStyle(
                              color: grey7,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      h16,
                      Text(
                        restaurantDescription,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      h30,
                      const Row(
                        children: [
                          Icon(
                            Icons.business_center_outlined,
                            color: primaryColor,
                          ),
                          w12,
                          Text(
                            'Вакансии',
                            style: TextStyle(
                              color: grey7,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      h16,
                      Expanded(
                        child: ListView.builder(
                          itemCount: positions.length,
                          itemBuilder: (context, index) {
                            var positionData = positions[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: WorkPositionCard(
                                  description: positionData['description'],
                                  positionName: positionData['positionName'],
                                  salary: positionData['salary']),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
