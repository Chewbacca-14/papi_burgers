import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:papi_burgers/providers/date_picker_provider.dart';
import 'package:papi_burgers/providers/internet_status_provider.dart';
import 'package:papi_burgers/providers/order_address_provider.dart';
import 'package:papi_burgers/providers/order_provider.dart';
import 'package:papi_burgers/providers/order_type_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/controllers/login_controller.dart';
import 'package:papi_burgers/controllers/timer_controller.dart';
import 'package:papi_burgers/providers/current_address_provider.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/providers/delivery_price_provider.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:papi_burgers/providers/navigation_index_provider.dart';
import 'package:papi_burgers/providers/restaurant_provider.dart';
import 'package:papi_burgers/views/refactored_pages/not_connected_page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance.initDatabase();
  DatabaseHelper.instance.createTables();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<InternetStatusProvider>(
        builder: (context, value, child) {
          switch (value.status) {
            case InternetStatus.connected:
              return MaterialApp.router(
                routerDelegate: _appRouter.delegate(),
                routeInformationParser: _appRouter.defaultRouteParser(),
              );
            case InternetStatus.disconnected:
              return const MaterialApp(home: NotConnectedPage());
          }
        },
      ),
    );
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<LoginController>(
    create: (_) => LoginController(),
  ),
  ChangeNotifierProvider<TimerController>(
    create: (_) => TimerController(),
  ),
  ChangeNotifierProvider<RestaurantProvider>(
    create: (_) => RestaurantProvider(),
  ),
  ChangeNotifierProvider<DeliveryPriceProvider>(
    create: (_) => DeliveryPriceProvider(),
  ),
  ChangeNotifierProvider<NavigationIndexProvider>(
    create: (_) => NavigationIndexProvider(),
  ),
  ChangeNotifierProvider<CurrentAddressProvider>(
    create: (_) => CurrentAddressProvider(),
  ),
  ChangeNotifierProvider<FirestoreDBProvider>(
    create: (_) => FirestoreDBProvider(),
  ),
  ChangeNotifierProvider<DateTimeProvider>(
    create: (_) => DateTimeProvider(),
  ),
  ChangeNotifierProvider<OrderTypeProvider>(
    create: (_) => OrderTypeProvider(),
  ),
  ChangeNotifierProvider<OrderAddressProvider>(
    create: (_) => OrderAddressProvider(),
  ),
  ChangeNotifierProvider<OrderProvider>(
    create: (_) => OrderProvider(),
  ),
  ChangeNotifierProvider<InternetStatusProvider>(
    create: (_) => InternetStatusProvider(),
  ),
];
