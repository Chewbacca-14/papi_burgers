import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/app_router.dart';

import 'package:papi_burgers/controllers/login_controller.dart';
import 'package:papi_burgers/controllers/timer_controller.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/delivery_price_provider.dart';
import 'package:papi_burgers/restaurant_provider.dart';
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
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
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
];
