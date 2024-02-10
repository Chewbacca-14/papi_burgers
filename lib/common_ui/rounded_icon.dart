import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class RoundedIcon extends StatelessWidget {
  final IconData icon;
  const RoundedIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: grey9,
      ),
      child: Center(
        child: Icon(icon, color: const Color.fromARGB(226, 255, 255, 255)),
      ),
    );
  }
}
