import 'package:flutter/material.dart';

class Address {
  final int? id;
  final String address;
  final int frontDoorNumber;
  final int numberFlat;
  final int floor;
  final String? comment;

  Address(
      {
        this.id,
        required this.address,
      required this.frontDoorNumber,
      required this.numberFlat,
      required this.floor,
      this.comment});
}
