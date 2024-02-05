import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papi_burgers/common_ui/main_home_page/cart_button.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String photo;
  final int weight;
  const MenuItemCard({
    super.key,
    required this.name,
    required this.photo,
    required this.price,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 244,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(photo), fit: BoxFit.fill)),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color.fromARGB(218, 255, 255, 255),
                          ),
                          child: const Center(
                            child: Icon(Icons.favorite,
                                color: Color.fromARGB(255, 119, 119, 119)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              h20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
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
                                  fontSize: 14),
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
                    const CartButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
