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
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 12,
            spreadRadius: 8,
            offset: Offset(0, 8),
          ),
        ],
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image: DecorationImage(
                    image: NetworkImage(photo), fit: BoxFit.fill),
              ),
            ),
            h10,
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
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
                color: isSelected
                    ? const Color.fromARGB(255, 199, 65, 65)
                    : const Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
