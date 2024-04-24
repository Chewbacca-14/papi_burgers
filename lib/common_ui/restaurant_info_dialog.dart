import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class RestaurantInfoPage extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String address;
  final String schedule;
  const RestaurantInfoPage({
    super.key,
    required this.address,
    required this.logoUrl,
    required this.name,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 177,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(logoUrl)),
              title: Text(
                name,
                style: const TextStyle(
                    fontSize: 18, color: grey4, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  color: grey9,
                ),
              ),
            ),
            h20,
            const Row(
              children: [
                Icon(Icons.watch_later_outlined),
                SizedBox(width: 5),
                Text(
                  'Время работы',
                  style: TextStyle(
                    fontSize: 16,
                    color: grey7,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                schedule,
                style: const TextStyle(
                  fontSize: 14,
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
