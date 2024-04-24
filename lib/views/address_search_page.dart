import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/common_ui/address_info_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/providers/current_address_provider.dart';
import 'package:papi_burgers/models/location_model.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({super.key});

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  List placeList = [];

  double lat = -1;
  double long = -1;
  Future<void> getSuggestion(String input) async {
    String apiKey = "AIzaSyBd0aug203TbkCMHl5iATuyMc4HBLwP7Kk";
    String autocompleteURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String placeDetailsURL =
        'https://maps.googleapis.com/maps/api/place/details/json';

    // Define the location for biasing results
    String locationRostov = '47.2248606,39.7022858';

    // Making the Autocomplete API request
    var autocompleteRequest = Uri.parse(
        '$autocompleteURL?input=$input&language=ru&location=$locationRostov&radius=25000&key=$apiKey');

    var autocompleteResponse = await http.get(autocompleteRequest);

    if (autocompleteResponse.statusCode == 200) {
      var predictions = json.decode(autocompleteResponse.body)['predictions'];
      placeList = json.decode(autocompleteResponse.body)['predictions'];

      // Ensure there are predictions
      if (predictions.isNotEmpty) {
        // Extract place_id from the first prediction
        String placeId = predictions[0]['place_id'];

        // Making the Place Details API request
        var placeDetailsRequest = Uri.parse(
            '$placeDetailsURL?place_id=$placeId&fields=geometry&key=$apiKey');

        var placeDetailsResponse = await http.get(placeDetailsRequest);

        if (placeDetailsResponse.statusCode == 200) {
          var placeDetails = json.decode(placeDetailsResponse.body)['result'];
          var geometry = placeDetails['geometry'];
          var location = geometry['location'];

          var latitude = location['lat'];
          var longitude = location['lng'];

          setState(() {
            lat = latitude;
            long = longitude;
          });
        } else {
          throw Exception('Failed to load place details');
        }
      } else {
        print('No predictions found');
      }
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
    CurrentAddressProvider currentAddressProvider =
        Provider.of<CurrentAddressProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyf1,
        appBar: AppBar(
          backgroundColor: greyf1,
          centerTitle: true,
          title: const Text(
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
                            currentAddressProvider.isAddressFromMap = false;
                            currentAddressProvider.changeCurrentAddress(
                                LocationModel(
                                    address: placeList[index]['description'],
                                    latitude: lat,
                                    longtitude: long));
                            Navigator.pop(context);
                          },
                          child: Text(
                            placeList[index]['description'],
                            style: const TextStyle(
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
