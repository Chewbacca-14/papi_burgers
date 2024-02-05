// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginCodeRoute.name: (routeData) {
      final args = routeData.argsAs<LoginCodeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginCodePage(
          key: args.key,
          phoneNumber: args.phoneNumber,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    ProjectSelectingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectSelectingPage(),
      );
    },
  };
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginCodePage]
class LoginCodeRoute extends PageRouteInfo<LoginCodeRouteArgs> {
  LoginCodeRoute({
    Key? key,
    required String phoneNumber,
    List<PageRouteInfo>? children,
  }) : super(
          LoginCodeRoute.name,
          args: LoginCodeRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginCodeRoute';

  static const PageInfo<LoginCodeRouteArgs> page =
      PageInfo<LoginCodeRouteArgs>(name);
}

class LoginCodeRouteArgs {
  const LoginCodeRouteArgs({
    this.key,
    required this.phoneNumber,
  });

  final Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'LoginCodeRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectSelectingPage]
class ProjectSelectingRoute extends PageRouteInfo<void> {
  const ProjectSelectingRoute({List<PageRouteInfo>? children})
      : super(
          ProjectSelectingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectSelectingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
