import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/main_home_page/app_bar_restaurant_selection.dart';
import 'package:papi_burgers/common_ui/main_home_page/custom_tab_box.dart';
import 'package:papi_burgers/common_ui/main_home_page/menu_item_card.dart';
import 'package:papi_burgers/common_ui/main_home_page/more_icon.dart';
import 'package:papi_burgers/common_ui/main_home_page/search_bottom_sheet.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';

import 'package:papi_burgers/providers/navigation_index_provider.dart';
import 'package:papi_burgers/providers/restaurant_provider.dart';
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
  List<String> catImages = [];
  List<Map<String, dynamic>> menuItems = [];

  // TabController? _tabController;

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

    for (var doc in querySnapshot.docs) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          names.add(data['name']);
        }
      }
    }

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

  int selectedIndex = 0;
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

  var user = FirebaseAuth.instance.currentUser;

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
    required String allergens,
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
      'allergens': allergens,
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getRestaurantInfo();
    // _tabController = TabController(length: categories.length, vsync: this);
    fetchNames();
    request();
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void request() async {
    await Geolocator.requestPermission();
  }

  void fetchData() async {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    // Fetch categories
    DocumentSnapshot restaurantDoc = await _firestore
        .collection('restaurants')
        .doc(restaurantProvider.restaurantName)
        .get();

    setState(() {
      categories = List<String>.from(restaurantDoc['categories']);
      catImages = List<String>.from(restaurantDoc['catImages']);
      // _tabController = TabController(length: categories.length, vsync: this);
      // _tabController?.addListener(() {
      //   log('${_tabController?.index}');
      //   setState(() {});
      // });

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

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: greyf1,
      appBar: AppBar(
        backgroundColor: greyf1,
        title: Row(
          children: [
            const Expanded(
              child: AppBarRestaurantSelection(
                  logoImageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/papi-burgers-project.appspot.com/o/restaurants_images%2FGroup%202549.png?alt=media&token=a41aa87f-1395-4d0a-a081-9a8545a779eb'),
            ),
            w12,
            GestureDetector(
              onTap: () {
                context.router.push(const AboutProjectRoute());
              },
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: MoreIcon(),
                  )),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTabController(
                length: categories.length,
                initialIndex: 0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h20,
                      const Text(
                        // projectName,
                        //TODO
                        'Papi Burgers',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
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
                                  color:
                                      const Color.fromARGB(255, 246, 246, 246),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search),
                                      w12,
                                      Text(
                                        'Найдите любимое блюдо...',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 153, 153, 153),
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
                            onTap: () {
                              context.router.push(const RestaurantMapRoute());
                            },
                          )
                        ],
                      ),
                      h20,
                      TabBar(
                        splashBorderRadius: BorderRadius.circular(22),
                        labelPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        onTap: (value) {
                          setState(() {
                            selectedIndex = value;
                          });
                        },
                        dividerColor: Colors.transparent,
                        // isScrollable: true,
                        indicatorColor: Colors.transparent,
                        tabs: categories
                            .map(
                              (category) => CustomTabBox(
                                name: category,
                                photo: catImages[categories.indexOf(category)],
                                isSelected: selectedIndex ==
                                    categories.indexOf(category),
                              ),
                            )
                            .toList(),
                      ),
                      h20,
                      categories.isNotEmpty
                          ? categories.map((category) {
                              List<Map<String, dynamic>> items = menuItems
                                  .where((item) => item['cat'] == category)
                                  .toList();
                              return GroupedListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                elements: items,
                                groupBy: (element) {
                                  return element['subcat'];
                                },
                                groupSeparatorBuilder: (value) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      '$value',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, element) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        context.router.push(
                                          MenuItemDetailsRoute(
                                            calories: element['calories'],
                                            carbohydrates:
                                                element['carbohydrates'],
                                            description: element['description'],
                                            fat: element['fat'],
                                            imageUrl: element['photo'],
                                            ingredients: element['ingredients'],
                                            name: element['name'],
                                            price: element['price'],
                                            proteins: element['proteins'],
                                            weight: element['weight'],
                                            allergens: element['allergens'],
                                          ),
                                        );
                                      },
                                      child: MenuItemCard(
                                        name: element['name'],
                                        photo: element['photo'],
                                        price: element['price'],
                                        weight: element['weight'],
                                        isSaved: savedNames
                                            .contains(element['name']),
                                        onSave: () {
                                          if (savedNames
                                              .contains(element['name'])) {
                                            removeFromSaved(element['name']);
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              fetchNames();
                                            });
                                          } else {
                                            if (user != null) {
                                              addToSaved(
                                                calories: element['calories'],
                                                carbohydrates:
                                                    element['carbohydrates'],
                                                description:
                                                    element['description'],
                                                fat: element['fat'],
                                                imageUrl: element['photo'],
                                                ingredients:
                                                    element['ingredients'],
                                                name: element['name'],
                                                price: element['price'],
                                                proteins: element['proteins'],
                                                weight: element['weight'],
                                                allergens: element['allergens'],
                                              );
                                              fetchNames();
                                            } else {
                                              showCustomSnackBar(
                                                  context,
                                                  'Ой! Кажется вы не авторизированы',
                                                  AnimatedSnackBarType.warning);
                                              navigationIndexProvider
                                                  .changeIndex(3);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                              // return ListView.builder(
                              //   physics: NeverScrollableScrollPhysics(),
                              //   itemCount: items.length,
                              //   shrinkWrap: true,
                              //   itemBuilder: (context, index) {
                              //     final  element = items[index];

                              //   },
                              // );
                            }).toList()[selectedIndex]
                          : const SizedBox.shrink(),
                    ],
                  ),
                )),
          ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: SvgPicture.asset('assets/pb_logo.svg'),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String text;

  const CustomTab({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
// GroupedListView<dynamic, String>(
//                     order: GroupedListOrder.DESC,
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     elements: showSearchField ? filteredData : historyData,
//                     groupBy: (element) {
//                       String timestampstring = element['date'];

//                       int timestampMillis = int.parse(timestampstring);

//                       DateTime timestamp =
//                           DateTime.fromMillisecondsSinceEpoch(timestampMillis);

//                       String formattedDate = formatDate(
//                           timestamp, 'dd MMMM yyyy', isRu ? 'ru' : 'en');

//                       return formattedDate;
//                     },
//                     groupSeparatorBuilder: (String groupByValue) => Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 36.w,
//                       ),
//                       child: Text(
//                         groupByValue == formattedDate
//                             ? '${localizations.today} - ${groupByValue}'
//                             : groupByValue == formattedYesterday
//                                 ? '${localizations.yesterday} - ${groupByValue}'
//                                 : groupByValue,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color.fromARGB(255, 78, 150, 213),
//                         ),
//                       ),
//                     ),
//                     itemBuilder: (context, dynamic element) {