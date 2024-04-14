// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:papi_burgers/models/extra_ingredients.dart';

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
  final int quantity;
  final List<Map<String, dynamic>> extraIngredientsList;
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
    required this.quantity,
    required this.extraIngredientsList,
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
    int? quantity,
    List<Map<String, dynamic>>? extraIngredientsList,
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
        quantity: quantity ?? this.quantity,
        extraIngredientsList:
            extraIngredientsList ?? this.extraIngredientsList);
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
      'quantity': quantity,
      'extraIngredientsList': extraIngredientsList,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as int,
      images: map['images'] as String,
      ingredients: map['ingredients'] as String,
      allergens: map['allergens'] as String,
      calories: map['calories'] as int,
      carbohydrate: map['carbohydrate'] as int,
      fat: map['fat'] as int,
      proteins: map['proteins'] as int,
      weigth: map['weigth'] as int,
      quantity: map['quantity'] as int,
      extraIngredientsList: map['extraIngredientsList'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItem.fromJson(String source) =>
      MenuItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, price: $price, images: $images, ingredients: $ingredients, allergens: $allergens, calories: $calories, carbohydrate: $carbohydrate, fat: $fat, proteins: $proteins, weigth: $weigth, quantity: $quantity, extraIngredientsList: $extraIngredientsList)';
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
        other.weigth == weigth &&
        other.quantity == quantity &&
        listEquals(other.extraIngredientsList, extraIngredientsList);
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
        weigth.hashCode ^
        quantity.hashCode ^
        extraIngredientsList.hashCode;
  }
}
