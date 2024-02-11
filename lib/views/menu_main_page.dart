import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/app_bar_restaurant_selection.dart';
import 'package:papi_burgers/common_ui/main_home_page/custom_tab_box.dart';
import 'package:papi_burgers/common_ui/main_home_page/menu_item_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/restaurant_provider.dart';
import 'package:provider/provider.dart';

class MenuMainPage extends StatefulWidget {
  const MenuMainPage({super.key});

  @override
  State<MenuMainPage> createState() => _MenuMainPageState();
}

class _MenuMainPageState extends State<MenuMainPage>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> categories = [];
  List<Map<String, dynamic>> menuItems = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchData();
    getRestaurantInfo();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void fetchData() async {
    // Fetch categories
    DocumentSnapshot restaurantDoc =
        await _firestore.collection('restaurants').doc('PB1').get();

    setState(() {
      categories = List<String>.from(restaurantDoc['categories']);

      _tabController = TabController(length: categories.length, vsync: this);
      _tabController.addListener(() {
        log('${_tabController.index}');
        setState(() {});
      });

      // Fetch menu items
      menuItems = List<Map<String, dynamic>>.from(restaurantDoc['menu']);
    });
  }

  String projectName = '';

  Future<void> getRestaurantInfo() async {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);

    try {
      QuerySnapshot<Map<String, dynamic>> restaurantSnapshot =
          await FirebaseFirestore.instance
              .collection('restaurants')
              .where('id', isEqualTo: restaurantProvider.restaurantName)
              .limit(1)
              .get();

      // Check if any documents were returned
      if (restaurantSnapshot.docs.isNotEmpty) {
        final restaurantData = restaurantSnapshot.docs.first.data();
        projectName = restaurantData['name'];
      } else {
        // Handle case where no documents were found
        print('No restaurant found with the given ID.');
      }
    } catch (e) {
      // Handle any other errors
      print('Error fetching restaurant information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DefaultTabController(
          length: categories.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              Text(
                projectName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Доставка еды и напитков',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              h20,
              Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromARGB(255, 246, 246, 246),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Найдите любимое блюдо...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 153, 153, 153),
                      ),
                    ),
                  )),
              h20,
              TabBar(
                splashBorderRadius: BorderRadius.circular(22),

                onTap: (value) {
                  _tabController.animateTo(value);
                  setState(() {});
                },
                controller: _tabController,
                dividerColor: Colors.transparent,
                // isScrollable: true,
                indicatorColor: Colors.transparent,
                tabs: categories
                    .map(
                      (category) => CustomTabBox(
                        name: category,
                        photo:
                            'https://d27jswm5an3efw.cloudfront.net/app/uploads/2019/07/how-to-make-a-url-for-a-picture-on-your-computer-4.jpg',
                        isSelected: _tabController.index ==
                            categories.indexOf(category),
                      ),
                    )
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _tabController,
                  children: categories.map((category) {
                    List<Map<String, dynamic>> items = menuItems
                        .where((item) => item['cat'] == category)
                        .toList();
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final menuItemData = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              // context.router.push();
                            },
                            child: MenuItemCard(
                                name: menuItemData['name'],
                                photo: menuItemData['photo'],
                                price: menuItemData['price'],
                                weight: 123),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
