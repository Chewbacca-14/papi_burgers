import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/models/menu_item.dart';
import 'package:papi_burgers/models/order.dart';
import 'package:papi_burgers/providers/order_provider.dart';
import 'package:papi_burgers/providers/order_type_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/price_info_sheet.dart';

import 'package:papi_burgers/common_ui/user_cart_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/providers/delivery_price_provider.dart';
import 'package:papi_burgers/providers/navigation_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

@RoutePage()
class UserCartPage extends StatefulWidget {
  const UserCartPage({super.key});

  @override
  State<UserCartPage> createState() => _UserCartPageState();
}

class _UserCartPageState extends State<UserCartPage> {
  late Stream<List<Map<String, dynamic>>> _itemsStream;

  @override
  void initState() {
    super.initState();

    _itemsStream = _getItemsFromDatabase();
  }

  Stream<List<Map<String, dynamic>>> _getItemsFromDatabase() async* {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    Database db = await databaseHelper.database;
    yield* db.query(userCartDb).asStream();
  }

  void updateList() {
    setState(() {
      _itemsStream = _getItemsFromDatabase();
    });
  }

  int extraIngredientsPrice = 0;
  int totalExtraIngredientsPrice = 0;

  void calculateTotalExtraIngredientsPrice(
      List<Map<String, dynamic>>? itemList) {
    double totalPrice = 0.0;
    if (itemList != null) {
      for (var item in itemList) {
        double price = double.parse(item['price'].toString());

        totalPrice += price;
      }
    }

    totalExtraIngredientsPrice = totalPrice.toInt();
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int dishPrice = 0;
  int totalPrice = 0;

  bool isEmptyCart = true;

  Future<void> calculatePrice() async {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context);
    DeliveryPriceProvider deliveryPriceProvider =
        Provider.of<DeliveryPriceProvider>(context, listen: false);
    int getDishPrice = await _databaseHelper.calculatePrice();
    setState(() {
      dishPrice = getDishPrice;
      totalPrice = dishPrice + deliveryPriceProvider.deliveryPrice;
    });
  }

  List<Map<String, dynamic>>? _snapshotData;

  // void checkIsEmptyCart(bool istrue) {
  //   isEmptyCart = istrue;
  // }

  @override
  Widget build(BuildContext context) {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);
    DeliveryPriceProvider deliveryPriceProvider =
        Provider.of<DeliveryPriceProvider>(context, listen: true);
    bool isDelivery = Provider.of<OrderTypeProvider>(context).isDelivery;
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          body: Column(
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Корзина',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    // const Spacer(),
                    // RoundedIcon(icon: Icons.info_outlined)
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  decoration: const BoxDecoration(
                    color: greyf1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: _itemsStream,
                            builder: (context, snapshot) {
                              _snapshotData = snapshot.data;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.red,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    isEmptyCart = true;
                                  });
                                });
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(34, 0, 0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child:
                                            Image.asset('assets/cart_icon.png'),
                                      ),
                                      h20,
                                      h20,
                                      const Text(
                                        'Ваша корзина',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      h20,
                                      const Text(
                                        'Пока здесь пусто. Наполните корзину вкусными блюдами и напитками из нашего меню, чтобы начать кулинарное путешествие.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      h25,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 94),
                                        child: ClassicLongButton(
                                            onTap: () {
                                              navigationIndexProvider
                                                  .changeIndex(0);
                                            },
                                            buttonText: 'Перейти в меню'),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                calculatePrice();

                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    isEmptyCart = false;
                                  });
                                });
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    // totalPriceCalc(snapshot);
                                    final item = snapshot.data![index];
                                    // Декодирование JSON и преобразование в список карт
                                    List<dynamic> decodedExtraIngredients =
                                        jsonDecode(item['extraIngredients']);
                                    List<Map<String, dynamic>>
                                        extraIngredients =
                                        decodedExtraIngredients
                                            .cast<Map<String, dynamic>>();
                                    double extraIngredientsPriceSum =
                                        extraIngredients.fold(
                                            0,
                                            (sum, item) =>
                                                sum + (item['price'] ?? 0));
                                    extraIngredientsPrice =
                                        extraIngredientsPriceSum.toInt();
                                    calculateTotalExtraIngredientsPrice(
                                        extraIngredients);
                                    return UserCartCard(
                                      extraIngredients: extraIngredients,
                                      id: item['id'],
                                      imageUrl: item['imageurl'],
                                      name: item['name'],
                                      price: item['price'],
                                      quantity: item['quantity'],
                                      extraIngredientsPrice:
                                          extraIngredientsPrice.toInt(),
                                      weight: item['weight'],
                                      updatestatep: () {
                                        _itemsStream = _getItemsFromDatabase();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isEmptyCart,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: PriceInfoSheet(
                            deliveryPrice: deliveryPriceProvider.deliveryPrice,
                            dishPrice: dishPrice,
                            totalPrice: totalPrice,
                            extraIngredientsPrice: totalExtraIngredientsPrice,
                            onTap: () {
                              if (FirebaseAuth.instance.currentUser == null) {
                                navigationIndexProvider.changeIndex(3);
                              } else {
                                orderProvider.addOrder(
                                  [
                                    OrderModel(
                                        id: '1',
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        isTakeAway: isDelivery,
                                        menuItems: _snapshotData!.map((item) {
                                          List<dynamic>
                                              decodedExtraIngredients =
                                              jsonDecode(
                                                  item['extraIngredients']);
                                          List<Map<String, dynamic>>
                                              extraIngredients =
                                              decodedExtraIngredients
                                                  .cast<Map<String, dynamic>>();
                                          return MenuItem(
                                            id: '77',
                                            quantity: item['quantity'],
                                            extraIngredientsList:
                                                extraIngredients,
                                            name: item['name'],
                                            price: item['price'],
                                            images: item['imageurl'],
                                            ingredients: item['ingredients'],
                                            allergens: item['allergens'],
                                            calories: item['calories'],
                                            carbohydrate: item['carbohydrate'],
                                            fat: item['fat'],
                                            proteins: item['proteins'],
                                            weigth: item['weight'],
                                          );
                                        }).toList(),
                                        deliveryPrice:
                                            deliveryPriceProvider.deliveryPrice,
                                        totalPrice: totalPrice)
                                  ],
                                );
                                context.pushRoute(
                                  OrderDetailsRoute(
                                    order: [
                                      OrderModel(
                                          id: '1',
                                          userId: '',
                                          isTakeAway: isDelivery,
                                          menuItems: _snapshotData!.map((item) {
                                            List<dynamic>
                                                decodedExtraIngredients =
                                                jsonDecode(
                                                    item['extraIngredients']);
                                            List<Map<String, dynamic>>
                                                extraIngredients =
                                                decodedExtraIngredients.cast<
                                                    Map<String, dynamic>>();
                                            return MenuItem(
                                              id: '77',
                                              quantity: item['quantity'],
                                              extraIngredientsList:
                                                  extraIngredients,
                                              name: item['name'],
                                              price: item['price'],
                                              images: item['imageurl'],
                                              ingredients: item['ingredients'],
                                              allergens: item['allergens'],
                                              calories: item['calories'],
                                              carbohydrate:
                                                  item['carbohydrate'],
                                              fat: item['fat'],
                                              proteins: item['proteins'],
                                              weigth: item['weight'],
                                            );
                                          }).toList(),
                                          deliveryPrice: deliveryPriceProvider
                                              .deliveryPrice,
                                          totalPrice: totalPrice)
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  // void totalPriceCalc(var snapshot) {
  //   // Calculate total price
  //   double cartTotalPrice = 0.0;
  //   for (var item in snapshot.data!) {
  //     // Calculate the price of the item including quantity
  //     double itemPrice = (double.parse(item['price'].toString()) ?? 0) *
  //         (double.parse(item['quantity'].toString()) ?? 0);

  //     // Check if the item has extra ingredients
  //     if (item['extraIngredients'] != null) {
  //       // Decode extra ingredients from JSON string
  //       List<dynamic> decodedExtraIngredients =
  //           jsonDecode(item['extraIngredients']);

  //       // Cast extra ingredients to list of maps
  //       List<Map<String, dynamic>> extraIngredients =
  //           decodedExtraIngredients.cast<Map<String, dynamic>>();

  //       // Calculate the total price of extra ingredients
  //       double extraIngredientsPriceSum =
  //           extraIngredients.fold(0, (sum, item) => sum + (item['price'] ?? 0));

  //       // Add the price of extra ingredients to the item's price
  //       itemPrice += extraIngredientsPriceSum;
  //     }

  //     // Add the item's total price to the cart's total price
  //     cartTotalPrice += itemPrice;
  //   }

  //   // Print total price
  //   print('Total Price: $cartTotalPrice');
  // }

  // Update the total price state
  // setState(() {
  //   totalPrice = cartTotalPrice;
  // });

  // Print total price
}
