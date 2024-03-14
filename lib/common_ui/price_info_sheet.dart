import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/providers/delivery_price_provider.dart';
import 'package:papi_burgers/providers/order_type_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:provider/provider.dart';

class PriceInfoSheet extends StatefulWidget {
  final int dishPrice;
  final int deliveryPrice;
  final int totalPrice;
  final bool isOrderDetailsPage;
  final void Function()? onTap;
  const PriceInfoSheet({
    super.key,
    required this.deliveryPrice,
    required this.dishPrice,
    required this.totalPrice,
    this.isOrderDetailsPage = false,
    this.onTap,
  });

  @override
  State<PriceInfoSheet> createState() => _PriceInfoSheetState();
}

class _PriceInfoSheetState extends State<PriceInfoSheet> {
  bool isDelivery = true;

  @override
  Widget build(BuildContext context) {
    DeliveryPriceProvider deliveryPriceProvider =
        Provider.of<DeliveryPriceProvider>(context);
    bool isDelivery = Provider.of<OrderTypeProvider>(context).isDelivery;
    OrderTypeProvider orderTypeProvider =
        Provider.of<OrderTypeProvider>(context);
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
              isTotalPrice: false,
              name: 'Сумма заказа',
              value: widget.dishPrice),
          h10,
          buildDividingLine(),
          h10,
          PriceInfoRow(
            isOrderDetailsPage: widget.isOrderDetailsPage,
            isTotalPrice: false,
            name: 'Доставка',
            value: widget.deliveryPrice,
            isDeliveryRow: true,
            isDelivery: isDelivery,
            deliveryOnTap: () {
              deliveryPriceProvider.changeDeliveryPrice(250);
              orderTypeProvider.changeType(true);
              setState(() {
                isDelivery = true;
              });
            },
            takeAwayOnTap: () {
              deliveryPriceProvider.changeDeliveryPrice(0);
              orderTypeProvider.changeType(false);
              setState(() {
                isDelivery = false;
              });
            },
          ),
          h10,
          buildDividingLine(),
          h10,
          PriceInfoRow(
              isTotalPrice: true, name: 'Итого', value: widget.totalPrice),
          h10,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ClassicLongButton(
              onTap: () {
                widget.onTap!();
              },
              buttonText: widget.isOrderDetailsPage ? 'Заказать' : 'Продолжить',
              showRightArrow: true,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceInfoRow extends StatefulWidget {
  final int value;
  final String name;
  final bool isTotalPrice;
  bool isDeliveryRow;
  bool isDelivery;
  final bool isOrderDetailsPage;
  final void Function()? deliveryOnTap;
  final void Function()? takeAwayOnTap;
  PriceInfoRow({
    super.key,
    required this.isTotalPrice,
    required this.name,
    required this.value,
    this.isDelivery = false,
    this.isDeliveryRow = false,
    this.deliveryOnTap,
    this.takeAwayOnTap,
    this.isOrderDetailsPage = false,
  });

  @override
  State<PriceInfoRow> createState() => _PriceInfoRowState();
}

class _PriceInfoRowState extends State<PriceInfoRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: !widget.isDeliveryRow
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: widget.isTotalPrice ? FontWeight.w700 : null,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.value} ₽',
                    style: TextStyle(
                      fontSize: widget.isTotalPrice ? 16 : 14,
                      color: widget.isTotalPrice ? primaryColor : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.deliveryOnTap,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.isDeliveryRow && !widget.isDelivery
                              ? Colors.black
                              : primaryColor,
                          fontWeight: widget.isTotalPrice || widget.isDelivery
                              ? FontWeight.w700
                              : null,
                        ),
                      ),
                    ),
                    !widget.isOrderDetailsPage
                        ? Row(
                            children: [
                              Text(
                                ' | ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: widget.isTotalPrice
                                      ? FontWeight.w700
                                      : null,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.takeAwayOnTap,
                                child: Text(
                                  'Самовывоз',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: widget.isDeliveryRow &&
                                            widget.isDelivery
                                        ? Colors.black
                                        : primaryColor,
                                    fontWeight: widget.isTotalPrice ||
                                            !widget.isDelivery
                                        ? FontWeight.w700
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    const Spacer(),
                    Text(
                      '${widget.value} ₽',
                      style: TextStyle(
                        fontSize: widget.isTotalPrice ? 16 : 14,
                        color: widget.isTotalPrice ? primaryColor : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ));
  }
}

Widget buildDividingLine() {
  return Container(
    height: 2,
    color: greyf1,
  );
}
