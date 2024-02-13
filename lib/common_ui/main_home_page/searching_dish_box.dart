import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class SearchingDishBox extends StatelessWidget {
  final String name;
  final int price;
  final String imageUrl;
  final int weight;

  const SearchingDishBox({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 246, 246, 246), width: 1),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(29, 0, 0, 0),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                ),
                w12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '$weight г',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 68, 68, 68),
                              fontSize: 12),
                        ),
                        Text(
                          ' / $price ₽',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
