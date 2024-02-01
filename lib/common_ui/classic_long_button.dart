import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class ClassicLongButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  const ClassicLongButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
