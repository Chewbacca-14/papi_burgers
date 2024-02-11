import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/counter_button.dart';
import 'package:papi_burgers/common_ui/main_home_page/food_energy_column.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/menu_item.dart';
import 'package:papi_burgers/views/user_cart_page.dart';
import 'package:sqflite/sqflite.dart';

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
  });

  @override
  State<MenuItemDetailsPage> createState() => _MenuItemDetailsPageState();
}

class _MenuItemDetailsPageState extends State<MenuItemDetailsPage> {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedIcon(icon: Icons.arrow_back),
                    RoundedIcon(icon: Icons.favorite_outlined)
                  ],
                ),
              ),
              const Spacer(),
              //start of main area
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 220,
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
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(widget.imageUrl),
                                  fit: BoxFit.fill)),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserCartPage()));
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
