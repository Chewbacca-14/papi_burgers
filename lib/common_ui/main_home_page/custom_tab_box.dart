import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class CustomTabBox extends StatelessWidget {
  final String name;
  final String photo;
  bool isSelected;
  CustomTabBox({
    super.key,
    this.isSelected = false,
    required this.name,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 190,
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              photo,
              width: 80,
              height: 80,
            ),
            h10,
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 15,
                  color: isSelected ? const Color.fromARGB(115, 255, 255, 255) : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
