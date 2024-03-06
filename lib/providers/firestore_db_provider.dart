import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/models/restaurant_model.dart';

class FirestoreDBProvider extends ChangeNotifier {
  Future<DocumentSnapshot<Map<String, dynamic>>> getAllRestaurantData() async {
    DocumentReference<Map<String, dynamic>> firestoreCollection =
        FirebaseFirestore.instance.collection('restaurants').doc('PB1');

    DocumentSnapshot<Map<String, dynamic>> restaurantData =
        await firestoreCollection.get();
    return restaurantData;
  }

  Future<List<Restaurant>> fetchRestaurantsForMap() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('restaurantmap').get();
    var restaurants =
        querySnapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
    return restaurants;
  }

  Future<List<Map<String, dynamic>>> getRestaurantsList() async {
    List<Map<String, dynamic>> restaurantList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('restaurants').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        restaurantList.add(data);
      }

      return restaurantList;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }
}
