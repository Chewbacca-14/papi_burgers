import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/models/extra_ingredients.dart';
import 'package:papi_burgers/models/order.dart';
import 'package:papi_burgers/views/order_pages/order_details_page.dart';
import 'package:papi_burgers/views/refactored_pages/about_project_page.dart';
import 'package:papi_burgers/views/address_add_page.dart';
import 'package:papi_burgers/views/address_search_page.dart';
import 'package:papi_burgers/views/refactored_pages/home_page.dart';
import 'package:papi_burgers/views/liked_dishes_page.dart';
import 'package:papi_burgers/views/login_code_page.dart';

import 'package:papi_burgers/views/refactored_pages/login_page.dart';
import 'package:papi_burgers/views/order_pages/dish_details.dart';
import 'package:papi_burgers/views/order_pages/menu_page.dart';
import 'package:papi_burgers/views/refactored_pages/order_confirmation_page.dart';
import 'package:papi_burgers/views/refactored_pages/project_selecting_page.dart';
import 'package:papi_burgers/views/refactored_pages/restaurants_map.dart';
import 'package:papi_burgers/views/user_addresses_page.dart';
import 'package:papi_burgers/views/order_pages/cart_page.dart';
import 'package:papi_burgers/views/refactored_pages/user_details_page.dart';
import 'package:papi_burgers/views/profile_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: LoginCodeRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ProjectSelectingRoute.page, initial: true),
        AutoRoute(page: UserProfileRoute.page),
        AutoRoute(page: UserDetailsRoute.page),
        AutoRoute(page: MenuMainRoute.page),
        AutoRoute(page: MenuItemDetailsRoute.page),
        AutoRoute(page: UserCartRoute.page),
        AutoRoute(page: LikedDishesRoute.page),
        AutoRoute(page: RestaurantMapRoute.page),
        AutoRoute(page: AddressAddRoute.page),
        AutoRoute(page: AddressSearchRoute.page),
        AutoRoute(page: UserAddressesRoute.page),
        AutoRoute(page: AboutProjectRoute.page),
        AutoRoute(page: OrderDetailsRoute.page),
        AutoRoute(page: OrderConfirmationRoute.page),
      ];
}
