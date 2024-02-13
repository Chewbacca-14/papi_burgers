import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/app_router.dart';
import 'package:papi_burgers/common_ui/main_home_page/app_bar_restaurant_selection.dart';
import 'package:papi_burgers/common_ui/main_home_page/custom_tab_box.dart';
import 'package:papi_burgers/common_ui/main_home_page/menu_item_card.dart';
import 'package:papi_burgers/common_ui/main_home_page/more_icon.dart';
import 'package:papi_burgers/common_ui/main_home_page/search_bottom_sheet.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/restaurant_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
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

  void searchBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const SearchBottomSheet();
      },
    );
  }

  Future<List<String>> getNamesFromFirestore() async {
    List<String> names = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('liked').get();

    querySnapshot.docs.forEach((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          names.add(data['name']);
        }
      }
    });

    return names;
  }

  Future<void> fetchNames() async {
    List<String> fetchedNames = await getNamesFromFirestore();
    setState(() {
      savedNames = fetchedNames;
    });
    log(savedNames.toString());
  }

  List<String> savedNames = [];

  Future<void> removeFromSaved(String name) async {
    CollectionReference<Map<String, dynamic>> firestoreCollection =
        FirebaseFirestore.instance.collection('liked');

    var querySnapshot =
        await firestoreCollection.where('name', isEqualTo: name).get();
    // Check if there's any document matching the query
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the first document found (assuming there's only one document with this name)
      var docRef = querySnapshot.docs[0].reference;
      await docRef.delete();
    } else {}
  }

  Future<void> addToSaved({
    required int calories,
    required int carbohydrates,
    required String description,
    required int fat,
    required String imageUrl,
    required String ingredients,
    required String name,
    required int price,
    required int proteins,
    required int weight,
  }) async {
    CollectionReference<Map<String, dynamic>> firestoreCollection =
        FirebaseFirestore.instance.collection('liked');

    await firestoreCollection.add({
      'calories': calories,
      'carbohydrates': carbohydrates,
      'description': description,
      'fat': fat,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'name': name,
      'price': price,
      'proteins': proteins,
      'weight': weight,
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getRestaurantInfo();
    _tabController = TabController(length: categories.length, vsync: this);
    fetchNames();
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
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: greyf1,
      appBar: AppBar(
        backgroundColor: greyf1,
        title: Row(
          children: [
            Expanded(
              child: const AppBarRestaurantSelection(
                  logoImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/papi-burgers-project.appspot.com/o/restaurants_images%2FGroup%202549.png?alt=media&token=a41aa87f-1395-4d0a-a081-9a8545a779eb'),
            ),
            w12,
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: MoreIcon(),
                )),
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
                // projectName,
                'Papi Burgers',
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
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        searchBottomSheet();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromARGB(255, 246, 246, 246),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              w12,
                              Text(
                                'Найдите любимое блюдо...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 153, 153, 153),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  w12,
                  RoundedIcon(
                    icon: Icons.location_on_outlined,
                    isWhite: true,
                  )
                ],
              ),
              h20,
              TabBar(
                splashBorderRadius: BorderRadius.circular(22),
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,

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
                            'https://static.vecteezy.com/system/resources/previews/030/683/548/large_2x/burgers-high-quality-4k-hdr-free-photo.jpg',
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
                              context.router.push(
                                MenuItemDetailsRoute(
                                    calories: 545,
                                    carbohydrates: 412,
                                    description: 'bla bla bla',
                                    fat: 587,
                                    imageUrl: menuItemData['photo'],
                                    ingredients: 'jkadsf fsdjkl dfkl jfsd',
                                    name: menuItemData['name'],
                                    price: menuItemData['price'],
                                    proteins: 777,
                                    weight: 458),
                              );
                            },
                            child: MenuItemCard(
                              name: menuItemData['name'],
                              photo: menuItemData['photo'],
                              price: menuItemData['price'],
                              weight: 123,
                              isSaved:
                                  savedNames.contains(menuItemData['name']),
                              onSave: () {
                                if (savedNames.contains(menuItemData['name'])) {
                                  removeFromSaved(menuItemData['name']);
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    fetchNames();
                                  });
                                } else {
                                  addToSaved(
                                      calories: 44,
                                      carbohydrates: 548,
                                      description: 'description',
                                      fat: 87,
                                      imageUrl: menuItemData['photo'],
                                      ingredients: 'ing',
                                      name: menuItemData['name'],
                                      price: menuItemData['price'],
                                      proteins: 74,
                                      weight: 125);
                                  fetchNames();
                                }
                              },
                            ),
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
