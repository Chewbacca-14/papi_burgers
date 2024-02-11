import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class PriceInfoSheet extends StatelessWidget {
  final int dishPrice;
  final int deliveryPrice;
  final int totalPrice;
  const PriceInfoSheet({
    super.key,
    required this.deliveryPrice,
    required this.dishPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 188,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 3,
            color: Color.fromARGB(26, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          h16,
          PriceInfoRow(
              isTotalPrice: false, name: 'Сумма заказа', value: dishPrice),
          h10,
          buildDividingLine(),
          h10,
          PriceInfoRow(
              isTotalPrice: false, name: 'Доставка', value: deliveryPrice),
          h10,
          buildDividingLine(),
          h10,
          PriceInfoRow(isTotalPrice: true, name: 'Итого', value: totalPrice),
          h10,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ClassicLongButton(
              onTap: () {},
              buttonText: 'Продолжить',
              showRightArrow: true,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceInfoRow extends StatelessWidget {
  final int value;
  final String name;
  final bool isTotalPrice;
  const PriceInfoRow({
    super.key,
    required this.isTotalPrice,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotalPrice ? FontWeight.w700 : null,
            ),
          ),
          const Spacer(),
          Text(
            '$value ₽',
            style: TextStyle(
              fontSize: isTotalPrice ? 16 : 14,
              color: isTotalPrice ? primaryColor : null,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDividingLine() {
  return Container(
    height: 2,
    color: greyf1,
  );
}
