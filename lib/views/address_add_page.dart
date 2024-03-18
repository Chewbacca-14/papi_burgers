import 'package:flutter/services.dart' show rootBundle;
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/common_ui/rounded_icon.dart';
import 'package:papi_burgers/models/order.dart';
import 'package:papi_burgers/providers/order_address_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/address_info_text_field.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/providers/current_address_provider.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:papi_burgers/models/location_model.dart';
import 'package:provider/provider.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;

@RoutePage()
class AddressAddPage extends StatefulWidget {
  final List<OrderModel> orders;
  const AddressAddPage({
    super.key,
    required this.orders,
  });

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  bool canFindAddress = true;
  final LatLng initialLocation = LatLng(47.228376, 39.702242);
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
    mapController!.setMapStyle(_mapStyle);
  }

  CameraPosition? cameraPositionString;
  String? _mapStyle;
  bool isInSelectedArea = true;

  void calculateDistance(LatLng markerPoint) {
    const double earthRadius = 6371000; // Radius of the Earth in meters

    double lat1 = initialLocation.latitude;
    double lon1 = initialLocation.longitude;
    double lat2 = markerPoint.latitude;
    double lon2 = markerPoint.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    if (earthRadius * c > 10000) {
      setState(() {
        isInSelectedArea = false;
      });
    } else {
      setState(() {
        isInSelectedArea = true;
      });
    }
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  // void checkUpdatedLocation(LatLng pointLatLng) {
  //   List<map_tool.LatLng> convatedPoligonPoint = polygonPoints
  //       .map((point) => map_tool.LatLng(point.latitude, point.longitude))
  //       .toList();

  //   setState(() {
  //     isInSelectedArea = map_tool.PolygonUtil.containsLocation(
  //         map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
  //         convatedPoligonPoint,
  //         false);
  //   });
  // }

  @override
  void initState() {
    rootBundle.loadString('assets/google_map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  List<LatLng> polygonPoints = const [
    LatLng(47.211722, 39.703389),
    LatLng(47.221650, 39.694011),
    LatLng(47.226781, 39.670533),
    LatLng(47.247185, 39.671400),
    LatLng(47.262602, 39.694326),
    LatLng(47.265783, 39.721417),
    LatLng(47.251912, 39.719013),
    LatLng(47.249713, 39.756885),
    LatLng(47.276637, 39.783043),
    LatLng(47.222614, 39.782485),
  ];

  @override
  Widget build(BuildContext context) {
    OrderAddressProvider orderAddressProvider =
        Provider.of<OrderAddressProvider>(context);
    CurrentAddressProvider currentAddressProvider =
        Provider.of<CurrentAddressProvider>(context, listen: true);
    if (!currentAddressProvider.isAddressFromMap) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentAddressProvider.latitude,
              currentAddressProvider.longtitude),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 390,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      onCameraMove: (CameraPosition cameraPosition) async {
                        cameraPositionString = cameraPosition;
                      },
                      onCameraIdle: () async {
                        if (cameraPositionString != null) {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            cameraPositionString!.target.latitude,
                            cameraPositionString!.target.longitude,
                            localeIdentifier: 'ru_RU',
                          );

                          calculateDistance(LatLng(
                            cameraPositionString!.target.latitude,
                            cameraPositionString!.target.longitude,
                          ));

                          if (placemarks.isNotEmpty) {
                            Placemark placemark = placemarks.first;
                            String street = placemark.street ?? '';
                            String number = placemark.name ?? '';
                            String locationMap =
                                '$street $number'; // Concatenate street and number
                            debugPrint(
                                locationMap); // Print the complete address
                            currentAddressProvider.isAddressFromMap = true;
                            currentAddressProvider.changeCurrentAddress(
                                LocationModel(
                                    address: locationMap,
                                    latitude: -1,
                                    longtitude: -1));
                          }
                        }
                      },
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        zoom: 10,
                        target: initialLocation,
                      ),
                      circles: {
                        Circle(
                            circleId: CircleId('1'),
                            center: initialLocation,
                            radius: 10000,
                            fillColor: Color(0xFF006491).withOpacity(0.2),
                            strokeWidth: 2,
                            strokeColor: Colors.red),
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: RoundedIcon(
                        icon: Icons.arrow_back,
                        onTap: () {
                          context.router
                              .replace(UserAddressesRoute(orders: []));
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset('assets/map_pointer.svg')),
                  ],
                ),
              ),
              Container(
                height: 340,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: isInSelectedArea
                        ? Column(
                            children: [
                              h20,
                              GestureDetector(
                                onTap: () {
                                  context.router
                                      .push(const AddressSearchRoute());
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(width: 1.3, color: grey4),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 37),
                                            child: const Text(
                                                'Нажмите, чтобы выбрать вручную',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 169, 169, 169),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_city_rounded,
                                                  color: grey4),
                                              w12,
                                              Expanded(
                                                  child: Text(
                                                      currentAddressProvider
                                                          .currentAddress,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: grey4,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ],
                                          ),
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
                                        hintText: isInSelectedArea
                                            ? 'Подъезд'
                                            : 'NE TO',
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
                                  iconData:
                                      Icons.store_mall_directory_outlined),
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
                                      showCustomSnackBar(
                                          context,
                                          'Введите адрес',
                                          AnimatedSnackBarType.error);
                                    } else if (frontDoorsController
                                            .text.isEmpty ||
                                        floorController.text.isEmpty ||
                                        numberFlatController.text.isEmpty) {
                                      showCustomSnackBar(
                                          context,
                                          'Заполните все поля',
                                          AnimatedSnackBarType.error);
                                    } else {
                                      try {
                                        DatabaseHelper.instance.addAddress(
                                          address: Address(
                                            address: currentAddressProvider
                                                .currentAddress,
                                            frontDoorNumber: int.parse(
                                                frontDoorsController.text),
                                            numberFlat: int.parse(
                                                numberFlatController.text),
                                            floor: int.parse(
                                              floorController.text,
                                            ),
                                            comment: commentController.text,
                                          ),
                                        );
                                        showCustomSnackBar(context, 'Сохранено',
                                            AnimatedSnackBarType.success);
                                        context.router.push(
                                            UserAddressesRoute(orders: widget.orders, returnOrderDetails: true));
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
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 50,
                              ),
                              h20,
                              Text(
                                'Адрес не в зоне доставки',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              h20,
                              ClassicLongButton(
                                  onTap: () {
                                    mapController!
                                        .animateCamera(CameraUpdate.newLatLng(
                                      LatLng(47.228376, 39.702242),
                                    ));
                                  },
                                  buttonText: 'Вернуться в зону')
                            ],
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
