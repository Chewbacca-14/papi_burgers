import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/counter_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/extra_ingredients.dart';

// ignore: must_be_immutable
class UserCartCard extends StatefulWidget {
  final int id;
  final String imageUrl;
  final String name;
  final int price;
  int quantity;
  final int extraIngredientsPrice;
  final int weight;
  final updatestatep;
  final List<Map<String, dynamic>>? extraIngredients;

  UserCartCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.price,
      required this.quantity,
      required this.weight,
      required this.id,
      required this.updatestatep,
      required this.extraIngredientsPrice,
      this.extraIngredients});

  @override
  State<UserCartCard> createState() => _UserCartCardState();
}

class _UserCartCardState extends State<UserCartCard> {
  Future<void> _deleteItemAndUpdateList() async {
    await _databaseHelper.deleteDishFromCart(id: widget.id);
    widget
        .updatestatep(); // Call the updatestatep callback to trigger a state update
  }

  String extraIngredientsList = '';

  Future<void> updateQuantity(int quantity) async {
    await _databaseHelper.changeDishQuantity(widget.id, quantity);

    widget.updatestatep();
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  bool isLastDish = false;
  String concatenateItems(List<Map<String, dynamic>> items) {
    return items.map((item) => '${item['name']} - ${item['price']}₽').join(' ');
  }

  @override
  void initState() {
    if (widget.extraIngredients != null) {
      extraIngredientsList = concatenateItems(widget.extraIngredients!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 8,
              color: Color.fromARGB(9, 0, 0, 0),
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.fill)),
                  ),
                  w12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.extraIngredientsPrice == 0
                            ? widget.name
                            : '${widget.name} + Доп.',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      h6,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.weight} г',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 68, 68, 68),
                                fontSize: 12),
                          ),
                          Text(
                            ' / ${widget.price} ₽',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CounterButton(
                            onTap: () async {
                              if (widget.quantity != 1) {
                                int newQuantity = widget.quantity - 1;
                                // Call updateQuantity with the new quantity
                                updateQuantity(newQuantity);
                              } else if (widget.quantity == 1) {
                                setState(() {
                                  isLastDish = true;
                                });

                                showConfirmationDialog(
                                    context: context,
                                    onTapYes: () {
                                      _deleteItemAndUpdateList();
                                      Navigator.pop(context);
                                    });
                              } else {
                                setState(() {
                                  isLastDish = false;
                                });
                              }
                            },
                            isPlus: false,
                            isRedButton: isLastDish,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${widget.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          CounterButton(
                            onTap: () {
                              int newQuantity = widget.quantity + 1;
                              // Call updateQuantity with the new quantity
                              updateQuantity(newQuantity);
                              setState(() {
                                isLastDish = false;
                                widget.quantity = 5;
                              });
                            },
                            isPlus: true,
                          ),
                        ],
                      ),
                      h6,
                      Text(
                        '${(widget.extraIngredientsPrice + widget.price) * widget.quantity} ₽',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              h10,
              widget.extraIngredients != null
                  ? Text(
                      extraIngredientsList,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

void showConfirmationDialog({
  required BuildContext context,
  required void Function()? onTapYes,
}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      backgroundColor: greyf1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            h16,
            const Text(
              'Вы правда хотите удалить данное блюдо из корзины?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onTapYes,
                  child: const Text(
                    'Да',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Нет',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
