import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:papi_burgers/common_ui/address_info_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/current_address_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({super.key});

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  List placeList = [];
  Future<void> getSuggestion(String input) async {
    String apiKey = "AIzaSyBd0aug203TbkCMHl5iATuyMc4HBLwP7Kk";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String locationRostov = '47.2248606, 39.7022858';

    var request = Uri.parse(
        '$baseURL?input=$input&language=ru&location=$locationRostov&radius=25000&key=$apiKey');

    var response = await http.get(request);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          placeList = json.decode(response.body)['predictions'];
        });
      }
      print(placeList);
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     CurrentAddressProvider currentAddressProvider = Provider.of<CurrentAddressProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyf1,
        appBar: AppBar(
             backgroundColor: greyf1,
          centerTitle: true,
          title: Text(
            'Поиск адреса',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddressInfoTextField(
                  onChanged: (value) {
                    getSuggestion(value);
                  },
                  addressController: addressController,
                  hintText: 'Введите адрес',
                  iconData: Icons.location_on),
              h20,
              SizedBox(
                height: MediaQuery.of(context).size.height - 70,
                width: MediaQuery.of(context).size.width - 40,
                child: ListView.builder(
                    itemCount: placeList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            
                            currentAddressProvider.changeCurrentAddress(placeList[index]['description']);
                            Navigator.pop(context);
                          },
                          child: Text(
                            placeList[index]['description'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
