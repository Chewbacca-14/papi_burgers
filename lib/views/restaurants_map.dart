import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class RestaurantMapPage extends StatefulWidget {
  const RestaurantMapPage({super.key});

  @override
  State<RestaurantMapPage> createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 14,
          target: LatLng(50.090356, 14.302991),
        ),
      ),
    );
  }
}
