import 'package:flutter/material.dart';

class MoreIcon extends StatelessWidget {
  const MoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            baseIconContainer(),
            const SizedBox(width: 1.5),
            baseIconContainer(),
          ],
        ),
        const SizedBox(height: 1.5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            baseIconContainer(),
            const SizedBox(width: 1.5),
            baseIconContainer(),
          ],
        )
      ],
    );
  }
}

Widget baseIconContainer() {
  return Container(
    height: 9.17,
    width: 9.17,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        width: 1.8,
        color: const Color.fromARGB(255, 51, 51, 51),
      ),
    ),
  );
}
