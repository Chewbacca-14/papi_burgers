import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class UserOrdersBox extends StatelessWidget {
  final String type;
  final int dishCount;
  final int totalPrice;
  final String date;
  const UserOrdersBox({
    super.key,
    required this.date,
    required this.dishCount,
    required this.totalPrice,
    required this.type,
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
                     const OrderStatusBox(orderStatus: 'confirmed'),
                    const Spacer(),
                    Text(
                      date,
                      style: TextStyle(color: grey7, fontSize: 12),
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
  const OrderStatusBox({
    super.key,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String status;
    IconData icon;
    switch (orderStatus) {
      case 'waiting':
        color = Colors.orange;
        status = 'Ожидание';
        icon = Icons.timer;
        break;
      case 'confirmed':
        color = Colors.green;
        status = 'Подтверждено';
        icon = Icons.check;
        break;
      case 'payed':
        color = Colors.blue;
        status = 'Оплачено';
        icon = Icons.monetization_on;
        break;
      case 'notPayed':
      case 'canceled':
        color = Colors.red;
        status = 'Отменено';
        icon = Icons.close;
        break;
      default:
        color = Colors.blue;
        status = 'Ошибка статуса';
        icon = Icons.question_mark_rounded;
        break;
    }

    return Container(
      height: 26,
      width: 116,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
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
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Text(
              status,
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
