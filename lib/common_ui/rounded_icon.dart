import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class RoundedIcon extends StatelessWidget {
  final IconData icon;
  final bool isWhite;
  final void Function()? onTap;
  final bool isRedIcon;
  const RoundedIcon(
      {super.key,
      required this.icon,
      this.isWhite = false,
      this.onTap,
      this.isRedIcon = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isWhite ? Colors.white : grey9,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isWhite
                ? const Color.fromARGB(255, 68, 68, 68)
                : isRedIcon
                    ? primaryColor
                    : const Color.fromARGB(226, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
