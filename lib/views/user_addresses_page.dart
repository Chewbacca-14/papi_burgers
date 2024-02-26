import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:papi_burgers/views/address_add_page.dart';
import 'package:sqflite/sqflite.dart';

@RoutePage()
class UserAddressesPage extends StatefulWidget {
  const UserAddressesPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyf1,
        centerTitle: true,
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
                        context.router.push(const AddressAddRoute());
                      },
                      buttonText: 'Добавить адрес'),
                ],
              ),
            ))
          : ListView.builder(
              itemCount: addressesList.length,
              itemBuilder: (context, index) {
                var address = addressesList[index];
                return ListTile(
                  title: Text(
                    '${address.address}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      databaseHelper.deleteAddress(id: address.id!);
                      fetchAddresses();
                    },
                    icon: const Icon(Icons.delete_forever),
                    color: Colors.red,
                  ),
                );
              }),
    );
  }
}
