import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class ExtraIngredientsRow extends StatelessWidget {
  final String name;
  final int price;
  final bool isSelected;
  final void Function()? onTap;
  const ExtraIngredientsRow(
      {super.key,
      required this.isSelected,
      required this.name,
      required this.price,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$price ₽',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              w12,
              isSelected
                  ? const CustomCheckBox(
                      isSelected: true,
                    )
                  : const CustomCheckBox(
                      isSelected: false,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final bool isSelected;
  const CustomCheckBox({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      width: 21,
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : null,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.8),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: isSelected ? Colors.white : Colors.grey.shade300,
          size: 12,
        ),
      ),
    );
  }
}
