import 'dart:convert';
import 'dart:developer';

import 'package:papi_burgers/constants/db_tables_names.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:papi_burgers/models/menu_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_cart.db');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $userCartDb (
    id INTEGER PRIMARY KEY,
    name TEXT,
    price INTEGER,
    imageurl TEXT,
    ingredients TEXT,
    allergens TEXT,
    calories INTEGER,
    carbohydrate INTEGER,
    fat INTEGER,
    proteins INTEGER,
    weight INTEGER,
    quantity INTEGER,
    extraIngredients TEXT

    
    )
  ''');

    await db.execute('''
    CREATE TABLE $userAddresses (
    id INTEGER PRIMARY KEY,
    address TEXT,
    frontDoorNumber INTEGER,
    numberFlat INTEGER,
    floor INTEGER,
    comment TEXT
    )
  ''');
  }

  Future<void> createTables() async {
    await createNewTable(
        tableName: userCartDb,
        arguments: '''
    id INTEGER PRIMARY KEY,
    name TEXT,
    price INTEGER,  
    imageurl TEXT,
    ingredients TEXT,
    allergens TEXT,
    calories INTEGER,
    carbohydrate INTEGER,
    fat INTEGER,
    proteins INTEGER,
    weight INTEGER,
    quantity INTEGER,
        extraIngredients TEXT
   
    ''',
        instance: instance);

    await createNewTable(
        tableName: userAddresses,
        arguments: '''
    id INTEGER PRIMARY KEY,
    address TEXT,
    frontDoorNumber INTEGER,
    numberFlat INTEGER,
    floor INTEGER,
    comment TEXT
    ''',
        instance: instance);
  }

  Future<int> changeDishQuantity(int id, int newQuantity) async {
    Database db = await instance.database;
    return await db.update(userCartDb, {'quantity': newQuantity},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> createNewTable(
      {required String tableName,
      required String arguments,
      required DatabaseHelper instance}) async {
    Database db = await instance.database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );

    if (result.isEmpty) {
      await db.execute('''
      CREATE TABLE $tableName (    
      $arguments
      )
    ''');
    }
  }

  Future<int> addDishToCart(
      {required MenuItem dish, required int quantity}) async {
    Database db = await instance.database;
    return await db.insert(userCartDb, {
      'name': dish.name,
      'price': dish.price,
      'imageurl': dish.images,
      'ingredients': dish.ingredients,
      'allergens': dish.allergens,
      'calories': dish.calories,
      'carbohydrate': dish.carbohydrate,
      'fat': dish.fat,
      'proteins': dish.proteins,
      'weight': dish.weigth,
      'quantity': quantity,
      'extraIngredients': jsonEncode(dish.extraIngredientsList)
    });
  }

  Future<int> addAddress({required Address address}) async {
    Database db = await instance.database;
    return await db.insert(userAddresses, {
      'address': address.address,
      'frontDoorNumber': address.frontDoorNumber,
      'numberFlat': address.numberFlat,
      'floor': address.floor,
      'comment': address.comment,
    });
  }

  Future<int> deleteAddress({
    required int id,
  }) async {
    Database db = await instance.database;
    return await db.delete(userAddresses, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDishFromCart({
    required int id,
  }) async {
    log('DELETED');
    Database db = await instance.database;
    return await db.delete(userCartDb, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> calculatePrice() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(userCartDb);
    int summ = 0;
    for (Map<String, dynamic> map in maps) {
      int price = map['price'];
      int quantity = map['quantity'];
      int totalDishPrice = price * quantity;
      summ += totalDishPrice;
    }

    return summ;
  }
}
