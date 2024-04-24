import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class UserOrdersBox extends StatelessWidget {
  final String type;
  final int dishCount;
  final int totalPrice;
  final String date;
  final Color? color;
  final String orderStatus;
  final IconData statusIcon;
  const UserOrdersBox({
    super.key,
    required this.date,
    required this.dishCount,
    required this.totalPrice,
    required this.type,
    required this.color,
    required this.orderStatus,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 8,
              color: Color.fromARGB(26, 0, 0, 0),
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            width: 1,
            color: greyf1,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_basket_outlined),
                    const SizedBox(width: 4),
                    Text(
                      '$dishCount позиций',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$totalPrice ₽',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                h10,
                Row(
                  children: [
                    OrderStatusBox(
                      orderStatus: orderStatus,
                      color: color,
                      statusIcon: statusIcon,
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: const TextStyle(color: grey7, fontSize: 12),
                    ),
                  ],
                )
              ],
            )

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             const Icon(Icons.shopping_basket_outlined),
            //             const SizedBox(width: 4),
            //             Text(
            //               '$dishCount позиций',
            //               style: const TextStyle(
            //                 fontWeight: FontWeight.w700,
            //                 fontSize: 16,
            //               ),
            //             ),
            //           ],
            //         ),
            //         h10,
            //         const OrderStatusBox(orderStatus: 'without'),
            //       ],
            //     ),
            //     const Spacer(),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Text(
            //               '$totalPrice ₽',
            //               style: const TextStyle(
            //                   fontSize: 16, fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         h10,
            //         Text(
            //           date,
            //           style: TextStyle(color: grey7, fontSize: 12),
            //         ),
            //       ],
            //     )
            //   ],
            // ),
            ),
      ),
    );
  }
}

class OrderStatusBox extends StatelessWidget {
  final String orderStatus;
  final Color? color;
  final IconData statusIcon;
  const OrderStatusBox(
      {super.key,
      required this.orderStatus,
      required this.color,
      required this.statusIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 116,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Icon(
                statusIcon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Text(
              orderStatus,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
