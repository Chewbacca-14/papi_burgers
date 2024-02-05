import 'package:flutter/material.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(16),
          border:
              Border.all(width: 1, color: Color.fromARGB(255, 241, 241, 241))),
      child: Center(
        child: Image.asset('assets/cart_icon.png'),
      ),
    );
  }
}
