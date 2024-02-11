import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class CounterButton extends StatelessWidget {
  final bool isPlus;
  final void Function()? onTap;
  final bool isRedButton;
  const CounterButton({
    super.key,
    this.isPlus = false,
    required this.onTap,
    this.isRedButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: !isPlus && isRedButton ? primaryColor : grey4,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Icon(
            isPlus ? Icons.add : Icons.remove,
            color: Colors.white,
            size: 17,
          ),
        ),
      ),
    );
  }
}
