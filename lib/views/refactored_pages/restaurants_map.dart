import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/common_ui/restaurant_info_dialog.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/models/restaurant_model.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RestaurantMapPage extends StatefulWidget {
  const RestaurantMapPage({super.key});

  @override
  State<RestaurantMapPage> createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  final LatLng initialLocation = const LatLng(47.221809, 39.720261);
  late GoogleMapController mapController;
  List<Restaurant> restaurants = [];

  Set<Marker> _createMarkers() {
    return restaurants.map(
      (restaurant) {
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
      },
    ).toSet();
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
      },
    );
  }

  Future<void> fetchRestaurants() async {
    FirestoreDBProvider firestoreDBProvider =
        Provider.of<FirestoreDBProvider>(context, listen: false);
    var restaurantList = await firestoreDBProvider.fetchRestaurantsForMap();
    setState(() {
      restaurants = restaurantList;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
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
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
                const Text(
                  'Наши проекты',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 110,
                  decoration: const BoxDecoration(
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
