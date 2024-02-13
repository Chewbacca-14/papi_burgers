import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class AppBarRestaurantSelection extends StatelessWidget {
  final String logoImageUrl;
  const AppBarRestaurantSelection({
    super.key,
    required this.logoImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,

      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5).copyWith(left: 11),
        child: Row(
          children: [
            Image.network(logoImageUrl),
            const Spacer(),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 250, 250, 250)),
              ),
              child: const Center(
                child: Icon(
                  Icons.more_horiz_outlined,
                  size: 15,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
