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
    AboutProjectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutProjectPage(),
      );
    },
    AddressAddRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddressAddPage(),
      );
    },
    AddressSearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddressSearchPage(),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePage(
          key: args.key,
          selectedPage: args.selectedPage,
        ),
      );
    },
    LikedDishesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LikedDishesPage(),
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
    MenuItemDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<MenuItemDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MenuItemDetailsPage(
          key: args.key,
          calories: args.calories,
          carbohydrates: args.carbohydrates,
          description: args.description,
          fat: args.fat,
          imageUrl: args.imageUrl,
          ingredients: args.ingredients,
          name: args.name,
          price: args.price,
          proteins: args.proteins,
          weight: args.weight,
          allergens: args.allergens,
        ),
      );
    },
    MenuMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MenuMainPage(),
      );
    },
    OrderDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrderDetailsPage(
          key: args.key,
          order: args.order,
        ),
      );
    },
    ProjectSelectingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectSelectingPage(),
      );
    },
    RestaurantMapRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RestaurantMapPage(),
      );
    },
    UserAddressesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserAddressesPage(),
      );
    },
    UserCartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserCartPage(),
      );
    },
    UserDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserDetailsPage(
          key: args.key,
          phoneNumber: args.phoneNumber,
        ),
      );
    },
    UserProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserProfilePage(),
      );
    },
  };
}

/// generated route for
/// [AboutProjectPage]
class AboutProjectRoute extends PageRouteInfo<void> {
  const AboutProjectRoute({List<PageRouteInfo>? children})
      : super(
          AboutProjectRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutProjectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AddressAddPage]
class AddressAddRoute extends PageRouteInfo<void> {
  const AddressAddRoute({List<PageRouteInfo>? children})
      : super(
          AddressAddRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddressAddRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AddressSearchPage]
class AddressSearchRoute extends PageRouteInfo<void> {
  const AddressSearchRoute({List<PageRouteInfo>? children})
      : super(
          AddressSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddressSearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    int selectedPage = 0,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(
            key: key,
            selectedPage: selectedPage,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({
    this.key,
    this.selectedPage = 0,
  });

  final Key? key;

  final int selectedPage;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, selectedPage: $selectedPage}';
  }
}

/// generated route for
/// [LikedDishesPage]
class LikedDishesRoute extends PageRouteInfo<void> {
  const LikedDishesRoute({List<PageRouteInfo>? children})
      : super(
          LikedDishesRoute.name,
          initialChildren: children,
        );

  static const String name = 'LikedDishesRoute';

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
/// [MenuItemDetailsPage]
class MenuItemDetailsRoute extends PageRouteInfo<MenuItemDetailsRouteArgs> {
  MenuItemDetailsRoute({
    Key? key,
    required int calories,
    required int carbohydrates,
    required String description,
    required int fat,
    required String imageUrl,
    required String ingredients,
    required String name,
    required int price,
    required int proteins,
    required int weight,
    required String allergens,
    List<PageRouteInfo>? children,
  }) : super(
          MenuItemDetailsRoute.name,
          args: MenuItemDetailsRouteArgs(
            key: key,
            calories: calories,
            carbohydrates: carbohydrates,
            description: description,
            fat: fat,
            imageUrl: imageUrl,
            ingredients: ingredients,
            name: name,
            price: price,
            proteins: proteins,
            weight: weight,
            allergens: allergens,
          ),
          initialChildren: children,
        );

  static const String name = 'MenuItemDetailsRoute';

  static const PageInfo<MenuItemDetailsRouteArgs> page =
      PageInfo<MenuItemDetailsRouteArgs>(name);
}

class MenuItemDetailsRouteArgs {
  const MenuItemDetailsRouteArgs({
    this.key,
    required this.calories,
    required this.carbohydrates,
    required this.description,
    required this.fat,
    required this.imageUrl,
    required this.ingredients,
    required this.name,
    required this.price,
    required this.proteins,
    required this.weight,
    required this.allergens,
  });

  final Key? key;

  final int calories;

  final int carbohydrates;

  final String description;

  final int fat;

  final String imageUrl;

  final String ingredients;

  final String name;

  final int price;

  final int proteins;

  final int weight;

  final String allergens;

  @override
  String toString() {
    return 'MenuItemDetailsRouteArgs{key: $key, calories: $calories, carbohydrates: $carbohydrates, description: $description, fat: $fat, imageUrl: $imageUrl, ingredients: $ingredients, name: $name, price: $price, proteins: $proteins, weight: $weight, allergens: $allergens}';
  }
}

/// generated route for
/// [MenuMainPage]
class MenuMainRoute extends PageRouteInfo<void> {
  const MenuMainRoute({List<PageRouteInfo>? children})
      : super(
          MenuMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderDetailsPage]
class OrderDetailsRoute extends PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    Key? key,
    required List<OrderModel> order,
    List<PageRouteInfo>? children,
  }) : super(
          OrderDetailsRoute.name,
          args: OrderDetailsRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailsRoute';

  static const PageInfo<OrderDetailsRouteArgs> page =
      PageInfo<OrderDetailsRouteArgs>(name);
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final List<OrderModel> order;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, order: $order}';
  }
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

/// generated route for
/// [RestaurantMapPage]
class RestaurantMapRoute extends PageRouteInfo<void> {
  const RestaurantMapRoute({List<PageRouteInfo>? children})
      : super(
          RestaurantMapRoute.name,
          initialChildren: children,
        );

  static const String name = 'RestaurantMapRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserAddressesPage]
class UserAddressesRoute extends PageRouteInfo<void> {
  const UserAddressesRoute({List<PageRouteInfo>? children})
      : super(
          UserAddressesRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserAddressesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserCartPage]
class UserCartRoute extends PageRouteInfo<void> {
  const UserCartRoute({List<PageRouteInfo>? children})
      : super(
          UserCartRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserCartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserDetailsPage]
class UserDetailsRoute extends PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({
    Key? key,
    required String phoneNumber,
    List<PageRouteInfo>? children,
  }) : super(
          UserDetailsRoute.name,
          args: UserDetailsRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'UserDetailsRoute';

  static const PageInfo<UserDetailsRouteArgs> page =
      PageInfo<UserDetailsRouteArgs>(name);
}

class UserDetailsRouteArgs {
  const UserDetailsRouteArgs({
    this.key,
    required this.phoneNumber,
  });

  final Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [UserProfilePage]
class UserProfileRoute extends PageRouteInfo<void> {
  const UserProfileRoute({List<PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
