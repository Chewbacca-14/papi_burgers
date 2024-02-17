import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/views/home_page.dart';
import 'package:papi_burgers/views/liked_dishes_page.dart';
import 'package:papi_burgers/views/login_code_page.dart';

import 'package:papi_burgers/views/login_page.dart';
import 'package:papi_burgers/views/menu_item_details_page.dart';
import 'package:papi_burgers/views/menu_main_page.dart';
import 'package:papi_burgers/views/project_selecting_page.dart';
import 'package:papi_burgers/views/restaurants_map.dart';
import 'package:papi_burgers/views/user_cart_page.dart';
import 'package:papi_burgers/views/user_details_page.dart';
import 'package:papi_burgers/views/user_profile_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: LoginCodeRoute.page),
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ProjectSelectingRoute.page),
        AutoRoute(page: UserProfileRoute.page),
        AutoRoute(page: UserDetailsRoute.page),
        AutoRoute(page: MenuMainRoute.page),
        AutoRoute(page: MenuItemDetailsRoute.page),
        AutoRoute(page: UserCartRoute.page),
        AutoRoute(page: LikedDishesRoute.page),
        AutoRoute(page: RestaurantMapRoute.page),
      ];
}
