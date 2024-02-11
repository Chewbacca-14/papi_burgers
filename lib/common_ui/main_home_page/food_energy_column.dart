import 'package:flutter/material.dart';

class FoodEnergyColumn extends StatelessWidget {
  final int value;
  final String text;
  final bool isGrams;
  const FoodEnergyColumn({
    super.key,
    required this.text,
    required this.value,
    required this.isGrams,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          '$value${isGrams ? 'г' : ''}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
