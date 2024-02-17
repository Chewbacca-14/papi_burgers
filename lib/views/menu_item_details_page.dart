import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/counter_button.dart';
import 'package:papi_burgers/common_ui/main_home_page/food_energy_column.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/menu_item.dart';
import 'package:papi_burgers/navigation_index_provider.dart';
import 'package:papi_burgers/views/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

@RoutePage()
class MenuItemDetailsPage extends StatefulWidget {
  final String name;
  final int price;
  final String description;
  final String ingredients;
  final String imageUrl;
  final int weight;
  final int calories;
  final int proteins;
  final int fat;
  final int carbohydrates;
  final String allergens;

  const MenuItemDetailsPage({
    super.key,
    required this.calories,
    required this.carbohydrates,
    required this.description,
    required this.fat,
    required this.imageUrl,
    required this.ingredients,
    required this.name,
    required this.price,
    required this.proteins,
    required this.weight,
    required this.allergens,
  });

  @override
  State<MenuItemDetailsPage> createState() => _MenuItemDetailsPageState();
}

class _MenuItemDetailsPageState extends State<MenuItemDetailsPage> {
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

  Future<void> fetchNames() async {
    List<String> fetchedNames = await getNamesFromFirestore();
    setState(() {
      savedNames = fetchedNames;
    });
  }

  List<String> savedNames = [];

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int dishQuantity = 1;

  Future<void> addToCart(String name) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    Database db = await databaseHelper.database;

    List<Map<String, dynamic>> items = await db.query(userCartDb);

    bool hasDish = items.any((item) => item['name'] == name);

    if (hasDish) {
      List<Map<String, dynamic>> items =
          await db.query(userCartDb, where: 'name = ?', whereArgs: [name]);
      int oldQuantity = items.first['quantity'];
      int newQuantity = oldQuantity + dishQuantity;
      _databaseHelper.changeDishQuantity(items.first['id'], newQuantity);
    } else {
      _databaseHelper.addDishToCart(
          dish: MenuItem(
              id: '',
              name: widget.name,
              price: widget.price,
              images: widget.imageUrl,
              ingredients: widget.ingredients,
              allergens: '',
              calories: widget.calories,
              carbohydrate: widget.carbohydrates,
              fat: widget.fat,
              proteins: widget.proteins,
              weigth: widget.weight),
          quantity: dishQuantity);
    }
  }

  @override
  void initState() {
    fetchNames();
    super.initState();
  }

  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);

    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedIcon(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    RoundedIcon(
                      icon: Icons.favorite_outlined,
                      isRedIcon: savedNames.contains(widget.name),
                      onTap: () {
                        if (savedNames.contains(widget.name)) {
                          removeFromSaved(widget.name);
                          Future.delayed(Duration(milliseconds: 100), () {
                            fetchNames();
                          });
                        } else {
                          if (user != null) {
                            addToSaved(
                                calories: 44,
                                carbohydrates: 548,
                                description: 'description',
                                fat: 87,
                                imageUrl: widget.imageUrl,
                                ingredients: 'ing',
                                name: widget.name,
                                price: widget.price,
                                proteins: 74,
                                weight: 125);
                            fetchNames();
                          } else {
                            showCustomSnackBar(
                                context,
                                'Ой! Кажется вы не авторизированы',
                                AnimatedSnackBarType.warning);
                            navigationIndexProvider.changeIndex(3);
                            Navigator.pop(context);
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
              const Spacer(),
              //start of main area
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 170,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //image of menu item
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(widget.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0)),
                                ),
                              ),
                            ),
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 198,
                                  width: 198,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(widget.imageUrl),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[200],
                                  ),
                                  height: 155,
                                  width: 155,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 155,
                                  width: 155,
                                  color: Colors.grey[200], // Placeholder color
                                  child: const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red, // Error icon color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        h30,
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.weight} г',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 68, 68, 68),
                                  fontSize: 16),
                            ),
                            Text(
                              ' / ${widget.price} ₽',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        h10,
                        Text(
                          widget.description,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        h30,
                        const Text(
                          'Состав',
                          style: TextStyle(
                              color: grey7,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        h10,
                        Text(
                          widget.ingredients,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        h30,
                        const Text(
                          'Аллергены',
                          style: TextStyle(
                              color: grey7,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        h10,
                        Text(
                          widget.allergens,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        h30,
                        const Text(
                          'Пищевая ценность',
                          style: TextStyle(
                              color: grey7,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FoodEnergyColumn(
                                text: 'Ккал',
                                value: widget.calories,
                                isGrams: false),
                            FoodEnergyColumn(
                                text: 'Белки',
                                value: widget.proteins,
                                isGrams: true),
                            FoodEnergyColumn(
                                text: 'Жиры', value: widget.fat, isGrams: true),
                            FoodEnergyColumn(
                                text: 'Углеводы',
                                value: widget.carbohydrates,
                                isGrams: true),
                            FoodEnergyColumn(
                                text: 'Вес',
                                value: widget.weight,
                                isGrams: true),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //finish of main area
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CounterButton(
                                  onTap: () {
                                    if (dishQuantity != 1) {
                                      setState(() {
                                        dishQuantity--;
                                      });
                                    }
                                  },
                                  isPlus: false,
                                ),
                                Text(
                                  '$dishQuantity',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                CounterButton(
                                  onTap: () {
                                    if (dishQuantity != 99) {
                                      setState(() {
                                        dishQuantity++;
                                      });
                                    }
                                  },
                                  isPlus: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    w12,
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          addToCart(widget.name);
                          navigationIndexProvider.changeIndex(2);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.price * dishQuantity} ₽',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'В корзину',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  w12,
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          )),
    );
  }
}
