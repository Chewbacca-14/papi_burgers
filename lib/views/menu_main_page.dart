import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/app_bar_restaurant_selection.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});

  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}

class _MenuMainPageState extends State<MenuMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> categories = [];
  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Fetch categories
    DocumentSnapshot restaurantDoc =
        await _firestore.collection('restaurants').doc('PB1').get();

    setState(() {
      categories = List<String>.from(restaurantDoc['categories']);

      // Fetch menu items
      menuItems = List<Map<String, dynamic>>.from(restaurantDoc['menu']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: const AppBarRestaurantSelection(
                  logoImageUrl:
                      'https://miro.medium.com/v2/resize:fit:1400/0*Y5h3pR1GAGTSk3yG.jpg'),
            ),
            w12,
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/menu_icon.png',
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: categories.length,
        child: Column(
          children: [
            TabBar(
              tabs: categories
                  .map((category) => CustomTab(text: category))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: categories.map((category) {
                  List<Map<String, dynamic>> items = menuItems
                      .where((item) => item['cat'] == category)
                      .toList();
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]['name']),
                        subtitle: Text('Price: \$${items[index]['price']}'),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: categories.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Restaurant Menu'),
//           bottom: TabBar(
//             tabs: categories.map((category) => Tab(text: category)).toList(),
//           ),
//         ),

//     );
//   }
// }

class CustomTab extends StatelessWidget {
  final String text;

  CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
