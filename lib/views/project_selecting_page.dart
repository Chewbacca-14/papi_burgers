import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/project_selecting_box/project_box.dart';

@RoutePage()
class ProjectSelectingPage extends StatefulWidget {
  const ProjectSelectingPage({super.key});

  @override
  State<ProjectSelectingPage> createState() => _ProjectSelectingPageState();
}

class _ProjectSelectingPageState extends State<ProjectSelectingPage> {
  List projects = [];

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    List<Map<String, dynamic>> restaurantList = [];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        restaurantList.add(data);
      }

      return restaurantList;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      body: FutureBuilder(
        future: getRestaurantData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> restaurantList = snapshot.data!;
            return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                return ProjectBox(logoImage: restaurantList[index]['logourl'], mainImage: restaurantList[index]['mainImage'],  projectName: restaurantList[index]['name'],);
              },
            );
          }
        },
      ),
    );
  }
}
