// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MenuItem {
  final String id;
  final String name;
  final int price;
  final String images;
  final String ingredients;
  final String allergens;
  final int calories;
  final int carbohydrate;
  final int fat;
  final int proteins;
  final int weigth;
  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.ingredients,
    required this.allergens,
    required this.calories,
    required this.carbohydrate,
    required this.fat,
    required this.proteins,
    required this.weigth,
  });

  MenuItem copyWith({
    String? id,
    String? name,
    int? price,
    String? images,
    String? ingredients,
    String? allergens,
    int? calories,
    int? carbohydrate,
    int? fat,
    int? proteins,
    int? weigth,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      images: images ?? this.images,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      calories: calories ?? this.calories,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      fat: fat ?? this.fat,
      proteins: proteins ?? this.proteins,
      weigth: weigth ?? this.weigth,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'images': images,
      'ingredients': ingredients,
      'allergens': allergens,
      'calories': calories,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'proteins': proteins,
      'weigth': weigth,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, price: $price, images: $images, ingredients: $ingredients, allergens: $allergens, calories: $calories, carbohydrate: $carbohydrate, fat: $fat, proteins: $proteins, weigth: $weigth)';
  }

  @override
  bool operator ==(covariant MenuItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.price == price &&
        other.images == images &&
        other.ingredients == ingredients &&
        other.allergens == allergens &&
        other.calories == calories &&
        other.carbohydrate == carbohydrate &&
        other.fat == fat &&
        other.proteins == proteins &&
        other.weigth == weigth;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        images.hashCode ^
        ingredients.hashCode ^
        allergens.hashCode ^
        calories.hashCode ^
        carbohydrate.hashCode ^
        fat.hashCode ^
        proteins.hashCode ^
        weigth.hashCode;
  }
}
