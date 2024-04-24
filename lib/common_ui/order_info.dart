import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class OrderInfoPage extends StatefulWidget {
  final String orderNumber;
  final bool isTakeAway;
  final bool isPayedByCard;
  final String createdAt;
  final String status;
  final List<dynamic> menuList;
  final int totalPrice;
  final int? deliveryPrice;
  final String restaurantName;
  final String restarantAddress;
  final String? deliveredAddress;

  const OrderInfoPage({
    super.key,
    required this.createdAt,
    this.deliveredAddress,
    required this.deliveryPrice,
    required this.isPayedByCard,
    required this.isTakeAway,
    required this.menuList,
    required this.orderNumber,
    required this.restarantAddress,
    required this.restaurantName,
    required this.status,
    required this.totalPrice,
  });

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  @override
  void initState() {
    super.initState();
    printOrderData();
  }

  void printOrderData() {
    log('Order Number: ${widget.menuList}');
  }

  String extraIngredientsList = '';

  String concatenateItems(List<Map<String, dynamic>> items) {
    return items.map((item) => '${item['name']} - ${item['price']}₽').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyf1,
      appBar: AppBar(
        backgroundColor: greyf1,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height + 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Заказ №${widget.orderNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Заказано: ${widget.createdAt}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      h16,
                      Row(
                        children: [
                          const Column(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: primaryColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SmallDot(),
                                      SmallDot(),
                                      SmallDot(),
                                      SmallDot(),
                                      SmallDot(),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.location_on_outlined,
                                color: primaryColor,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Откуда',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${widget.restaurantName} - ${widget.restarantAddress}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Куда',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    widget.deliveredAddress ??
                                        'No adress - test',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      // const Padding(
                      //   padding: EdgeInsets.only(left: 40),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           SmallDot(),
                      //           SmallDot(),
                      //           SmallDot(),
                      //           SmallDot(),
                      //           SmallDot(),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      h16,
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: widget.menuList.length,
                              itemBuilder: (context, index) {
                                var dish = widget.menuList[index];
                                var extraIngredients =
                                    dish['extraIngredientsList'];
                                double extraIngredientPrice = 0;
                                extraIngredients != null
                                    ? extraIngredientPrice =
                                        calculateExtraIngredientsPrice(
                                            extraIngredients)
                                    : null;
                                var extraIngredientsWidget =
                                    extraIngredients != null
                                        ? Text(
                                            extraIngredients
                                                .map<String>((extraIngredient) =>
                                                    '${extraIngredient['name']} - ${extraIngredient['price']} ₽')
                                                .join('\n'),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          )
                                        : SizedBox.shrink();
                                var totalDishPrice =
                                    (extraIngredientPrice + dish['price']) *
                                        dish['quantity'];
                                int totalDishPriceInt = totalDishPrice.toInt();
                                return ListTile(
                                  leading: Text(
                                    '${dish['quantity']}X',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  title: Text(
                                    '${dish['name']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: extraIngredientsWidget,
                                  trailing: Text('$totalDishPriceInt ₽'),
                                );
                              },
                            ),
                          ),
                          h16,
                          Container(
                            height: 1.2,
                            width: MediaQuery.of(context).size.width - 32,
                            color: Colors.grey.shade300,
                          ),
                          h16,
                          PriceInfoRow(
                              name: 'Блюда',
                              value: (widget.totalPrice -
                                      widget.deliveryPrice!.toInt())
                                  .toInt()),
                          !widget.isTakeAway
                              ? PriceInfoRow(
                                  name: 'Доставка',
                                  value: widget.deliveryPrice!.toInt())
                              : const SizedBox(),
                          PriceInfoRow(name: 'Всего', value: widget.totalPrice),
                          h16,
                          Container(
                            height: 1.2,
                            width: MediaQuery.of(context).size.width - 32,
                            color: Colors.grey.shade300,
                          ),
                          h16,
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Способ оплаты',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          PriceInfoRow(
                              name: widget.isPayedByCard
                                  ? 'Оплата онлайн'
                                  : 'Оплата наличными',
                              value: widget.totalPrice),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateExtraIngredientsPrice(List<dynamic> extraIngredients) {
    double total = 0;
    for (var ingredient in extraIngredients) {
      total += ingredient['price'];
    }
    return total;
  }
}

class SmallDot extends StatelessWidget {
  const SmallDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 2,
        width: 2,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}

class PriceInfoRow extends StatelessWidget {
  final String name;
  final int value;
  const PriceInfoRow({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            '$value ₽',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
