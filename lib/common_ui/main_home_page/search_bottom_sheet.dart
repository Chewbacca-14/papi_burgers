import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/searching_dish_box.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  late Stream<QuerySnapshot<Object?>>? stream;

  @override
  void initState() {
    stream = FirebaseFirestore.instance.collection('restaurants').snapshots();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 130,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16).copyWith(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 231, 231),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 246, 246, 246),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Найдите любимое блюдо...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 153, 153, 153),
                  ),
                ),
              ),
            ),
            h20,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  final restaurants = snapshot.data!.docs;
                  List<Map<String, dynamic>> menuItems = [];
                  restaurants.forEach((restaurantDoc) {
                    final menu = restaurantDoc['menu'] as List<dynamic>;
                    menuItems.addAll(menu.cast<Map<String, dynamic>>());
                  });
                  final filteredMenuItems = menuItems
                      .where((menuItem) => menuItem['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredMenuItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = filteredMenuItems[index];
                      return SearchingDishBox(
                        calories: menuItem['calories'],
                        carbohydrates: menuItem['carbohydrates'],
                        description: menuItem['description'],
                        fat: menuItem['fat'],
                        imageUrl: menuItem['photo'],
                        ingredients: menuItem['ingredients'],
                        name: menuItem['name'],
                        price: menuItem['price'],
                        proteins: menuItem['proteins'],
                        weight: menuItem['weight'],
                        allergens: menuItem['allergens'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
