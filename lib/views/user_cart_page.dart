import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/price_info_sheet.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/common_ui/user_cart_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserCartPage extends StatefulWidget {
  const UserCartPage({super.key});

  @override
  State<UserCartPage> createState() => _UserCartPageState();
}

class _UserCartPageState extends State<UserCartPage> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _getItemsFromDatabase();
  }

  Future<List<Map<String, dynamic>>> _getItemsFromDatabase() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    Database db = await databaseHelper.database;
    return await db.query(userCartDb);
  }

  void updateList() {
    setState(() {
      _itemsFuture = _getItemsFromDatabase();
    });
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int deliveryPrice = 250;
  int dishPrice = 0;
  int totalPrice = 0;

  bool isEmptyCart = false;

  Future<void> calculatePrice() async {
    int getDishPrice = await _databaseHelper.calculatePrice();
    setState(() {
      dishPrice = getDishPrice;
      totalPrice = dishPrice + deliveryPrice;
    });
  }

  void checkIsEmptyCart(bool istrue) {
    setState(() {
      isEmptyCart = istrue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedIcon(icon: Icons.arrow_back),
                    Text(
                      'Корзина',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    RoundedIcon(icon: Icons.info_outlined)
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
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
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _itemsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                checkIsEmptyCart(true);

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
                                          boxShadow: [
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
                                            onTap: () {},
                                            buttonText: 'Перейти в меню'),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                checkIsEmptyCart(false);

                                calculatePrice();
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final item = snapshot.data![index];

                                    return UserCartCard(
                                      id: item['id'],
                                      imageUrl: item['imageurl'],
                                      name: item['name'],
                                      price: item['price'],
                                      quantity: item['quantity'],
                                      weight: item['weight'],
                                      updatestatep: () {
                                        setState(() {
                                          _itemsFuture =
                                              _getItemsFromDatabase();
                                        });
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      isEmptyCart
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: PriceInfoSheet(
                                deliveryPrice: deliveryPrice,
                                dishPrice: dishPrice,
                                totalPrice: totalPrice,
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
}
