import 'package:papi_burgers/models/menu_item.dart';
import 'package:papi_burgers/models/order.dart';

class User {
  final String userId;
  final String name;
  final String phoneNumber;
  final List<String> addresses;
  final List<MenuItem> savedMenuItem;
  final List<OrderModel> orders;

  User(
      {required this.userId,
      required this.name,
      required this.phoneNumber,
      required this.addresses,
      required this.savedMenuItem,
      required this.orders});
}
