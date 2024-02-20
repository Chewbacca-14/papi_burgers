import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/common_ui/address_info_text_field.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

@RoutePage()
class AddressAddPage extends StatefulWidget {
  const AddressAddPage({super.key});

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  bool canFindAddress = true;
  final LatLng initialLocation = LatLng(47.221809, 39.720261);
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 380,
            child: GoogleMap(
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
                    AddressInfoTextField(
                        addressController: _addressController,
                        hintText: 'Адрес',
                        iconData: Icons.location_on_outlined),
                    h20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AddressInfoTextField(
                              addressController: _addressController,
                              hintText: 'Подъезд',
                              iconData: Icons.door_front_door),
                        ),
                        w12,
                        Expanded(
                          child: AddressInfoTextField(
                              addressController: _addressController,
                              hintText: 'Домофон',
                              iconData: Icons.phone),
                        ),
                      ],
                    ),
                    h20,
                    AddressInfoTextField(
                        addressController: _addressController,
                        hintText: 'Этаж',
                        iconData: Icons.location_on_outlined),
                   h20,
                    AddressInfoTextField(
                        addressController: _addressController,
                        hintText: 'Комментарий курьеру',
                        iconData: Icons.location_on_outlined),
                    h20,
                    ClassicLongButton(onTap: () {}, buttonText: 'Сохранить'),
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
