class MenuItem {
  final String id;
  final String name;
  final int price;
  final List<String> images;
  final String ingredients;
  final String allergens;
  final double calories;
  final double carbohydrate;
  final double fat;
  final double proteins;
  final double weigth;

  MenuItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.images,
      required this.ingredients,
      required this.allergens,
      required this.calories,
      required this.carbohydrate,
      required this.fat,
      required this.proteins,
      required this.weigth});
}
