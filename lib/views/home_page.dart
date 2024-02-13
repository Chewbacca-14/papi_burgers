import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/views/menu_item_details_page.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/views/login_code_page.dart';
import 'package:papi_burgers/views/login_page.dart';
import 'package:papi_burgers/views/menu_main_page.dart';
import 'package:papi_burgers/views/project_selecting_page.dart';
import 'package:papi_burgers/views/user_cart_page.dart';
import 'package:papi_burgers/views/user_profile_page.dart';

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
    const MenuItemDetailsPage(
        calories: 21,
        carbohydrates: 22,
        description:
            'Котлета из говядины, бакинские томаты,малосольные огурцы и сыр. Бургер подаётся на булочке с гарниром на ваш выбор - картофелемфри или по-деревенски',
        fat: 232,
        imageUrl:
            'https://cdn.britannica.com/36/123536-050-95CB0C6E/Variety-fruits-vegetables.jpg',
        ingredients:
            'Говядина, булочка для бургера (яйцо куриное, мука пшеничная высший сорт, молоко 3.6%, масло сливочное 84%, сахар, соль, дрожжи), горчица, огурцы малосольные (огурцы, соль, чеснок, укроп, сахар, имбирь, перец острый, перец душистый горошком, перец горошком, лавровый лист), сыр для бургеров (сыр чабан 45%, сливки 33%), помидоры, салат айсберг, лук красный, чеснок.',
        name: 'Афоня на булочке',
        price: 245,
        proteins: 22,
        weight: 260),
    UserCartPage(),
    const UserProfilePage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (widget.selectedPage != 0) {
      _selectedIndex = widget.selectedPage;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded,
                color: _selectedIndex == 0 ? primaryColor : primaryGrey),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite,
                color: _selectedIndex == 1 ? primaryColor : primaryGrey),
            label: 'Любимое',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_rounded,
                color: _selectedIndex == 2 ? primaryColor : primaryGrey),
            label: 'Корзина',
          ),
          NavigationDestination(
            icon: Icon(Icons.person,
                color: _selectedIndex == 3 ? primaryColor : primaryGrey),
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
