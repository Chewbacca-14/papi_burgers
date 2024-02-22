import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/app_router.dart';
import 'package:papi_burgers/common_ui/address_info_text_field.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/current_address_provider.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AddressAddPage extends StatefulWidget {
  const AddressAddPage({super.key});

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  bool canFindAddress = true;
  final LatLng initialLocation = LatLng(47.221809, 39.720261);
  TextEditingController frontDoorsController = TextEditingController();
  TextEditingController numberFlatController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  GoogleMapController? mapController;

  Position? currentPosition;

void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  String currentAddress = '';

  void getCurrentAddress() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      Placemark placemark = placemarks.first;
      String street = placemark.street ?? '';

      String address = street;
      
        // setState(() {
        //   locationFromMap = address;
       
        // });
    
      

  log(address);
    } catch (e) {
      debugPrint('Error fetching current position: $e');
    }
  }

@override
  void initState() {
    
    getCurrentAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentAddressProvider currentAddressProvider =
        Provider.of<CurrentAddressProvider>(context, listen: true);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 380,
            child: GoogleMap(
                onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                zoom: 12,
                target: initialLocation,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    h20,
                    GestureDetector(
                      onTap: () {
                        context.router.push(const AddressSearchRoute());
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1.3, color: grey4),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                const Icon(Icons.location_city_rounded,
                                    color: grey4),
                                w12,
                                Expanded(
                                    child: Text(
                                        currentAddressProvider.currentAddress,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: grey4,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    h20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AddressInfoTextField(
                              addressController: frontDoorsController,
                              hintText: 'Подъезд',
                              keyBoardType: TextInputType.number,
                              iconData: Icons.door_front_door),
                        ),
                        w12,
                        Expanded(
                          child: AddressInfoTextField(
                              addressController: numberFlatController,
                              keyBoardType: TextInputType.number,
                              hintText: 'Домофон',
                              iconData: Icons.phone),
                        ),
                      ],
                    ),
                    h20,
                    AddressInfoTextField(
                        addressController: floorController,
                        hintText: 'Этаж',
                        keyBoardType: TextInputType.number,
                        iconData: Icons.store_mall_directory_outlined),
                    h20,
                    AddressInfoTextField(
                        addressController: commentController,
                        hintText: 'Комментарий курьеру',
                        iconData: Icons.comment),
                    h20,
                    ClassicLongButton(
                        onTap: () {
                          if (currentAddressProvider.currentAddress ==
                              'Выбрать вручную') {
                            showCustomSnackBar(context, 'Введите адрес',
                                AnimatedSnackBarType.error);
                          } else if (frontDoorsController.text.isEmpty ||
                              floorController.text.isEmpty ||
                              numberFlatController.text.isEmpty) {
                            showCustomSnackBar(context, 'Заполните все поля',
                                AnimatedSnackBarType.error);
                          } else {
                            try {
                              DatabaseHelper.instance.addAddress(
                                  address: Address(
                                      address:
                                          currentAddressProvider.currentAddress,
                                      frontDoorNumber:
                                          int.parse(frontDoorsController.text),
                                      numberFlat:
                                          int.parse(numberFlatController.text),
                                      floor: int.parse(floorController.text)));
                              showCustomSnackBar(context, 'Сохранено',
                                  AnimatedSnackBarType.success);
                                  context.router.push(const UserAddressesRoute());
                            } catch (e) {
                              showCustomSnackBar(
                                  context,
                                  'Ошибка - ${e.toString()}',
                                  AnimatedSnackBarType.error);
                            }
                          }
                        },
                        buttonText: 'Сохранить'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
