import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final String address;
  final String logoUrl;
  final double latitude;
  final double longtitude;
  final String schedule;

  Restaurant({
    required this.name,
    required this.address,
    required this.logoUrl,
    required this.latitude,
    required this.longtitude,
    required this.schedule,
  });

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      name: data['name'],
      address: data['address'],
      logoUrl: data['logoUrl'],
      latitude: double.parse(data['latitude']),
      longtitude: double.parse(data['longtitude']),
      schedule: data['schedule'],
    );
  }
}
