import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class CounterButton extends StatelessWidget {
  final bool isPlus;
  final void Function()? onTap;
  const CounterButton({
    super.key,
    this.isPlus = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: grey4,
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
