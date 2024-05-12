import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/models/order.dart';
import 'package:papi_burgers/providers/navigation_index_provider.dart';
import 'package:papi_burgers/providers/order_address_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

@RoutePage()
class UserAddressesPage extends StatefulWidget {
  final bool returnOrderDetails;
  final List<OrderModel> orders;

  const UserAddressesPage({
    super.key,
    this.returnOrderDetails = false,
    required this.orders,
  });

  @override
  State<UserAddressesPage> createState() => _UserAddressesPageState();
}

class _UserAddressesPageState extends State<UserAddressesPage> {
  List<Address> addressesList = [];

  Future<void> fetchAddresses() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    Database db = await databaseHelper.database;

    List<Map<String, dynamic>> addressMaps = await db.query(userAddresses);

    var addresses = addressMaps.map((map) {
      return Address(
        id: map['id'],
        address: map['address'],
        frontDoorNumber: map['frontDoorNumber'],
        numberFlat: map['numberFlat'],
        floor: map['floor'],
        comment: map['comment'],
      );
    }).toList();

    setState(() {
      addressesList = addresses;
    });
    log('${addresses.length}');
  }

  @override
  void initState() {
    fetchAddresses();
    super.initState();
  }

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    NavigationIndexProvider navigationIndexProvider =
        Provider.of<NavigationIndexProvider>(context, listen: true);
    OrderAddressProvider orderAddressProvider =
        Provider.of<OrderAddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyf1,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            navigationIndexProvider.selectedIndex = 3;
            context.router.push(HomeRoute());
          },
        ),
        title: const Text(
          'Мои адреса',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: addressesList.isEmpty
          ? Center(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Кажется адресов пока нет',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  h20,
                  ClassicLongButton(
                      onTap: () {
                        context.router
                            .push(AddressAddRoute(orders: widget.orders));
                      },
                      buttonText: 'Добавить адрес'),
                ],
              ),
            ))
          : ListView.builder(
              itemCount: addressesList.length,
              itemBuilder: (context, index) {
                var address = addressesList[index];
                return GestureDetector(
                  onTap: () {
                    if (widget.orders == []) {}
                    orderAddressProvider.changeOrderAddress(Address(
                      address: address.address,
                      frontDoorNumber: address.frontDoorNumber,
                      numberFlat: address.numberFlat,
                      floor: address.floor,
                      comment: address.comment,
                    ));
                    if (widget.returnOrderDetails) {
                      context.router
                          .replace(OrderDetailsRoute(order: widget.orders));
                      Navigator.pop(context);
                    }
                  },
                  child: ListTile(
                    title: Text(
                      address.address,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        databaseHelper.deleteAddress(id: address.id!);
                        fetchAddresses();
                      },
                      icon: const Icon(Icons.delete_forever),
                      color: Colors.red,
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.router.push(AddressAddRoute(orders: widget.orders));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
