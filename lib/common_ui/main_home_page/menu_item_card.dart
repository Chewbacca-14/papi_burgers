import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papi_burgers/common_ui/main_home_page/cart_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String photo;
  final int weight;
  final bool isSaved;
  final void Function()? onSave;
  const MenuItemCard({
    super.key,
    required this.name,
    required this.photo,
    required this.price,
    required this.weight,
    this.isSaved = false,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  CachedNetworkImage(
                    imageUrl: photo,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      height: 155,
                      width: 155,
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 155,
                      width: 155,
                      color: Colors.grey[200], // Placeholder color
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red, // Error icon color
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(60, 255, 255, 255),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: photo,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 155,
                        width: 155,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        height: 155,
                        width: 155,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 155,
                        width: 155,
                        color: Colors.grey[200], // Placeholder color
                        child: const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red, // Error icon color
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: onSave,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color.fromARGB(218, 255, 255, 255),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: isSaved
                                  ? primaryColor
                                  : const Color.fromARGB(255, 119, 119, 119),
                            ),
                          ),
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
    );
  }
}
