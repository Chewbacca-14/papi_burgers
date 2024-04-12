// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExtraIngredients {
  final String name;
  final int price;
  ExtraIngredients({
    required this.name,
    required this.price,
  });

  ExtraIngredients copyWith({
    String? name,
    int? price,
  }) {
    return ExtraIngredients(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
    };
  }

  factory ExtraIngredients.fromMap(Map<String, dynamic> map) {
    return ExtraIngredients(
      name: map['name'] as String,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtraIngredients.fromJson(String source) =>
      ExtraIngredients.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ExtraIngredients(name: $name, price: $price)';

  @override
  bool operator ==(covariant Object other) {
    if (identical(this, other)) return true;

    return other is ExtraIngredients &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
