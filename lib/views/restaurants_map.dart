import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/common_ui/restaurant_info_dialog.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/models/restaurant_model.dart';

@RoutePage()
class RestaurantMapPage extends StatefulWidget {
  const RestaurantMapPage({super.key});

  @override
  State<RestaurantMapPage> createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  final LatLng initialLocation = LatLng(47.221809, 39.720261);
  late GoogleMapController mapController;
  List<Restaurant> restaurants = [];

  Future<void> fetchRestaurants() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('restaurantmap').get();
    setState(() {
      restaurants = querySnapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Set<Marker> _createMarkers() {
    return restaurants.map((restaurant) {
      return Marker(
        markerId: MarkerId(restaurant.name),
        position: LatLng(restaurant.latitude, restaurant.longtitude),
        infoWindow: InfoWindow(
          title: restaurant.name,
          snippet: restaurant.logoUrl,
        ),
        onTap: () {
          _onMarkerTapped(restaurant);
        },
      );
    }).toSet();
  }

  void _onMarkerTapped(Restaurant restaurant) {
    showDialog(
        context: context,
        builder: (context) {
          return RestaurantInfoPage(
            address: restaurant.address,
            logoUrl: restaurant.logoUrl,
            name: restaurant.name,
            schedule: restaurant.schedule,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                w12,
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
                Text(
                  'Наши проекты',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: GoogleMap(
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: initialLocation,
                      zoom: 12.0,
                    ),
                    markers: _createMarkers(),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
