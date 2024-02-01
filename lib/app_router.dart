import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/views/home_page.dart';
import 'package:papi_burgers/views/login_code_page.dart';

import 'package:papi_burgers/views/login_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: LoginCodeRoute.page),
        AutoRoute(page: HomeRoute.page),
      ];
}