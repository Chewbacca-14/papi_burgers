import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/main_home_page/menu_item_details.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/views/login_code_page.dart';
import 'package:papi_burgers/views/login_page.dart';
import 'package:papi_burgers/views/menu_main_page.dart';
import 'package:papi_burgers/views/project_selecting_page.dart';
import 'package:papi_burgers/views/user_profile_page.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [
    const MenuMainPage(),
    const MenuItemDetails(calories: 2, carbohydrates: 2, description: '', fat: 2, imageUrl: '', ingredients: '', name: '', price: 2, proteins: 2, weight: 2),
    const ProjectSelectingPage(),
    const UserProfilePage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded,
                color: _selectedIndex == 0 ? primaryColor : primaryGrey),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _selectedIndex == 1 ? primaryColor : primaryGrey),
            label: 'Любимое',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_rounded,
                color: _selectedIndex == 2 ? primaryColor : primaryGrey),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 3 ? primaryColor : primaryGrey),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryGrey,
        iconSize: 28,
        onTap: _onItemTapped,
      ),
    );
  }
}
