import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/navigation_index_provider.dart';
import 'package:papi_burgers/views/liked_dishes_page.dart';
import 'package:papi_burgers/views/menu_item_details_page.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/views/login_code_page.dart';
import 'package:papi_burgers/views/login_page.dart';
import 'package:papi_burgers/views/menu_main_page.dart';
import 'package:papi_burgers/views/project_selecting_page.dart';
import 'package:papi_burgers/views/user_cart_page.dart';
import 'package:papi_burgers/views/user_profile_page.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  final int selectedPage;

  const HomePage({super.key, this.selectedPage = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [
    const MenuMainPage(),
    const LikedDishesPage(),
    const UserCartPage(),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);
    return Scaffold(
      body: Center(
        child: pages.elementAt(navigationIndexProvider.selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            navigationIndexProvider.selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded,
                color: navigationIndexProvider.selectedIndex == 0
                    ? primaryColor
                    : primaryGrey),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite,
                color: navigationIndexProvider.selectedIndex == 1
                    ? primaryColor
                    : primaryGrey),
            label: 'Любимое',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_rounded,
                color: navigationIndexProvider.selectedIndex == 2
                    ? primaryColor
                    : primaryGrey),
            label: 'Корзина',
          ),
          NavigationDestination(
            icon: Icon(Icons.person,
                color: navigationIndexProvider.selectedIndex == 3
                    ? primaryColor
                    : primaryGrey),
            label: 'Профиль',
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: primaryGrey,
        // iconSize: 28,
        // onTap: _onItemTapped,
      ),
    );
  }
}
