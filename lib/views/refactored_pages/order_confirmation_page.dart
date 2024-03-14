import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/router/app_router.dart';

@RoutePage()
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
          ),
          h16,
          const Text(
            'Заказ успешно создан',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          h20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClassicLongButton(
                onTap: () {
                  context.router.push(HomeRoute());
                },
                buttonText: 'ОК'),
          )
        ],
      ),
    );
  }
}
