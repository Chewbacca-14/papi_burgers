import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/models/extra_ingredients.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/main_home_page/menu_item_card.dart';
import 'package:papi_burgers/common_ui/main_home_page/search_bottom_sheet.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/providers/navigation_index_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LikedDishesPage extends StatefulWidget {
  const LikedDishesPage({super.key});

  @override
  State<LikedDishesPage> createState() => _LikedDishesPageState();
}

class _LikedDishesPageState extends State<LikedDishesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List items = [];
  bool isEmptyList = false;

  Future<void> getLikedDishes() async {
    QuerySnapshot snapshot = await _firestore.collection('liked').get();

    setState(() {
      items = snapshot.docs;
    });
  }

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
    if (fetchedNames.isEmpty) {
      setState(() {
        isEmptyList = true;
      });
    } else {
      setState(() {
        isEmptyList = false;
      });
    }
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

  bool showLoading = true;

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
    });
  }

  @override
  void initState() {
    super.initState();
    getLikedDishes();
    fetchNames();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: greyf1,
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(34, 0, 0, 0),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.favorite_outline_rounded,
                                color: primaryColor,
                              )),
                            ),
                            h20,
                            h20,
                            const Text(
                              'Пока пусто',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            h20,
                            const Text(
                              'Добавьте свои любимые блюда и напитки для создания уникальной коллекции ваших кулинарных предпочтений.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            h25,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 94),
                              child: ClassicLongButton(
                                  onTap: () {
                                    navigationIndexProvider.changeIndex(0);
                                  },
                                  buttonText: 'Добавить'),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final menuItemData = items[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              context.router.push(
                                MenuItemDetailsRoute(
                                  calories: menuItemData['calories'],
                                  carbohydrates: menuItemData['carbohydrates'],
                                  description: menuItemData['description'],
                                  fat: menuItemData['fat'],
                                  imageUrl: menuItemData['imageUrl'],
                                  ingredients: menuItemData['ingredients'],
                                  name: menuItemData['name'],
                                  price: menuItemData['price'],
                                  proteins: menuItemData['proteins'],
                                  weight: menuItemData['weight'],
                                  allergens: menuItemData['allergens'],
                                  extraIngredients: ExtraIngredients(
                                    name: menuItemData['extraIngredients']
                                        .map((e) => e['name'])
                                        .toString(),
                                    price: int.parse(
                                        menuItemData['extraIngredients']
                                            .map((e) => e['price'])
                                            .first),
                                  ),
                                ),
                              );
                            },
                            child: MenuItemCard(
                              name: menuItemData['name'],
                              photo: menuItemData['imageUrl'],
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
                                    getLikedDishes();
                                  });
                                } else {
                                  addToSaved(
                                    calories: menuItemData['calories'],
                                    carbohydrates:
                                        menuItemData['carbohydrates'],
                                    description: menuItemData['description'],
                                    fat: menuItemData['fat'],
                                    imageUrl: menuItemData['photo'],
                                    ingredients: menuItemData['ingredients'],
                                    name: menuItemData['name'],
                                    price: menuItemData['price'],
                                    proteins: menuItemData['proteins'],
                                    weight: menuItemData['weight'],
                                    allergens: menuItemData['allergens'],
                                  );
                                  fetchNames();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
