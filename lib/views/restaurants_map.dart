import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papi_burgers/common_ui/restaurant_info_dialog.dart';
import 'package:papi_burgers/constants/color_palette.dart';

@RoutePage()
class RestaurantMapPage extends StatefulWidget {
  const RestaurantMapPage({super.key});

  @override
  State<RestaurantMapPage> createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  GoogleMapController? mapController;

  final LatLng initialLocation = LatLng(47.221809, 39.720261);
  final LatLng markerLocation = LatLng(47.232257, 39.747759);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myLocation'),
        position: markerLocation,
        onTap: () {
          _showInfoDialog();
        },
      ),
    ].toSet();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestaurantInfoPage(
            address: 'г.Ростов-на-Дону, Кировский район, проспект',
            logoUrl:
                'https://firebasestorage.googleapis.com/v0/b/papi-burgers-project.appspot.com/o/restaurants_images%2F%D0%BB%D0%BE%D0%B3%D0%BE%D1%82%D0%B8%D0%BF%20%D0%9F%D0%B0%D0%BF%D0%B8%20%D0%B1%D1%83%D1%80%D0%B3%D0%B5%D1%80_%D0%9C%D0%BE%D0%BD%D1%82%D0%B0%D0%B6%D0%BD%D0%B0%D1%8F%20%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D1%8C%201%20%D0%BA%D0%BE%D0%BF%D0%B8%D1%8F.png?alt=media&token=ff6fac81-57f4-43bc-9564-fcb227dafcca',
            name: 'Papi burger’s',
            schedule: 'круглосуточно');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          children: [
            const Spacer(),
            Text(
              'Наши проекты',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
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
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: initialLocation,
                      zoom: 12.0,
                    ),
                    markers: _createMarker(),
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
