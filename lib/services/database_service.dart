import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/food_model.dart';
import '../models/waste_model.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService instance =
      DatabaseService._internal();

  factory DatabaseService() {
    return instance;
  }

  Database? _database;

  // -------------------------------------------------------
  // GET DATABASE
  // -------------------------------------------------------

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  // -------------------------------------------------------
  // INITIALIZE DATABASE
  // -------------------------------------------------------

  Future<Database> _initDatabase() async {
    final String databasePath =
        await getDatabasesPath();

    final String path = join(
      databasePath,
      'food_waste_tracker.db',
    );

    return await openDatabase(
      path,

      // Database version increased from 2 to 3
      version: 3,

      // ---------------------------------------------------
      // CREATE DATABASE FOR A NEW INSTALLATION
      // ---------------------------------------------------

      onCreate: (db, version) async {
        // FOOD ITEMS TABLE
        await db.execute('''
          CREATE TABLE food_items (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,
            purchaseDate TEXT NOT NULL,
            expiryDate TEXT NOT NULL,
            price REAL NOT NULL,
            storageLocation TEXT NOT NULL
          )
        ''');

        // WASTE RECORDS TABLE
        await db.execute('''
          CREATE TABLE waste_records (
            id TEXT PRIMARY KEY,
            foodName TEXT NOT NULL,
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,
            reason TEXT NOT NULL,
            wasteDate TEXT NOT NULL,
            moneyWasted REAL NOT NULL,
            notes TEXT NOT NULL
          )
        ''');

        // USERS TABLE
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },

      // ---------------------------------------------------
      // UPGRADE EXISTING DATABASE
      // ---------------------------------------------------

      onUpgrade: (db, oldVersion, newVersion) async {
        // Upgrade from version 1 to version 2
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE waste_records (
              id TEXT PRIMARY KEY,
              foodName TEXT NOT NULL,
              quantity REAL NOT NULL,
              unit TEXT NOT NULL,
              reason TEXT NOT NULL,
              wasteDate TEXT NOT NULL,
              moneyWasted REAL NOT NULL,
              notes TEXT NOT NULL
            )
          ''');
        }

        // Upgrade from version 2 to version 3
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              password TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // =======================================================
  // USER / AUTHENTICATION
  // =======================================================

  // -------------------------------------------------------
  // REGISTER USER
  // -------------------------------------------------------

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final Database db = await database;

    // Check whether email already exists
    final List<Map<String, dynamic>> existingUser =
        await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (existingUser.isNotEmpty) {
      return false;
    }

    // Insert new user
    await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return true;
  }

  // -------------------------------------------------------
  // LOGIN USER
  // -------------------------------------------------------

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // =======================================================
  // FOOD ITEMS
  // =======================================================

  // -------------------------------------------------------
  // FOOD: INSERT
  // -------------------------------------------------------

  Future<void> insertFood(FoodItem food) async {
    final Database db = await database;

    await db.insert(
      'food_items',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------
  // FOOD: GET ALL
  // -------------------------------------------------------

  Future<List<FoodItem>> getFoodItems() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(
      'food_items',
      orderBy: 'expiryDate ASC',
    );

    return maps
        .map(
          (map) => FoodItem.fromMap(map),
        )
        .toList();
  }

  // -------------------------------------------------------
  // FOOD: UPDATE
  // -------------------------------------------------------

  Future<void> updateFood(FoodItem food) async {
    final Database db = await database;

    await db.update(
      'food_items',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  // -------------------------------------------------------
  // FOOD: DELETE
  // -------------------------------------------------------

  Future<void> deleteFood(String id) async {
    final Database db = await database;

    await db.delete(
      'food_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -------------------------------------------------------
  // FOOD: DELETE ALL
  // -------------------------------------------------------

  Future<void> deleteAllFood() async {
    final Database db = await database;

    await db.delete('food_items');
  }

  // =======================================================
  // WASTE RECORDS
  // =======================================================

  // -------------------------------------------------------
  // INSERT WASTE
  // -------------------------------------------------------

  Future<void> insertWaste(WasteRecord waste) async {
    final Database db = await database;

    await db.insert(
      'waste_records',
      waste.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------
  // GET ALL WASTE
  // -------------------------------------------------------

  Future<List<WasteRecord>> getWasteRecords() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(
      'waste_records',
      orderBy: 'wasteDate DESC',
    );

    return maps
        .map(
          (map) => WasteRecord.fromMap(map),
        )
        .toList();
  }

  // -------------------------------------------------------
  // UPDATE WASTE
  // -------------------------------------------------------

  Future<void> updateWaste(WasteRecord waste) async {
    final Database db = await database;

    await db.update(
      'waste_records',
      waste.toMap(),
      where: 'id = ?',
      whereArgs: [waste.id],
    );
  }

  // -------------------------------------------------------
  // DELETE WASTE
  // -------------------------------------------------------

  Future<void> deleteWaste(String id) async {
    final Database db = await database;

    await db.delete(
      'waste_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -------------------------------------------------------
  // DELETE ALL WASTE
  // -------------------------------------------------------

  Future<void> deleteAllWaste() async {
    final Database db = await database;

    await db.delete('waste_records');
  }

  // =======================================================
  // STATISTICS METHODS
  // =======================================================

  // -------------------------------------------------------
  // TOTAL FOOD ITEMS
  // -------------------------------------------------------

  Future<int> getTotalFoodItems() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM food_items',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // -------------------------------------------------------
  // TOTAL FOOD QUANTITY
  // -------------------------------------------------------

  Future<double> getTotalFoodQuantity() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(quantity) as total FROM food_items',
    );

    final value = result.first['total'];

    if (value == null) {
      return 0;
    }

    return (value as num).toDouble();
  }

  // -------------------------------------------------------
  // TOTAL FOOD WASTED
  // -------------------------------------------------------

  Future<double> getTotalFoodWasted() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(quantity) as total FROM waste_records',
    );

    final value = result.first['total'];

    if (value == null) {
      return 0;
    }

    return (value as num).toDouble();
  }

  // -------------------------------------------------------
  // TOTAL MONEY WASTED
  // -------------------------------------------------------

  Future<double> getTotalMoneyWasted() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(moneyWasted) as total FROM waste_records',
    );

    final value = result.first['total'];

    if (value == null) {
      return 0;
    }

    return (value as num).toDouble();
  }

  // =======================================================
  // CHART DATA METHODS
  // =======================================================

  // -------------------------------------------------------
  // WASTE BY REASON
  // -------------------------------------------------------

  Future<List<Map<String, dynamic>>> getWasteByReason() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT reason, SUM(quantity) AS total
      FROM waste_records
      GROUP BY reason
      ORDER BY total DESC
    ''');

    return result;
  }

  // -------------------------------------------------------
  // WASTE BY CATEGORY
  // -------------------------------------------------------

  Future<List<Map<String, dynamic>>> getWasteByCategory() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT food_items.category,
             SUM(waste_records.quantity) AS total
      FROM waste_records
      INNER JOIN food_items
      ON waste_records.foodName = food_items.name
      GROUP BY food_items.category
      ORDER BY total DESC
    ''');

    return result;
  }

  // =======================================================
  // HOME DASHBOARD METHODS
  // =======================================================

  // -------------------------------------------------------
  // EXPIRING SOON COUNT
  // -------------------------------------------------------

  Future<int> getExpiringSoonCount() async {
    final db = await database;

    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final DateTime threeDaysLater =
        today.add(const Duration(days: 3));

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM food_items
      WHERE date(expiryDate) >= date(?)
      AND date(expiryDate) <= date(?)
      ''',
      [
        today.toIso8601String(),
        threeDaysLater.toIso8601String(),
      ],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // -------------------------------------------------------
  // CURRENT FOOD QUANTITY
  // -------------------------------------------------------

  Future<double> getCurrentFoodQuantity() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(quantity) AS total FROM food_items',
    );

    final value = result.first['total'];

    if (value == null) {
      return 0;
    }

    return (value as num).toDouble();
  }

  // -------------------------------------------------------
  // EXPIRING SOON FOODS
  // -------------------------------------------------------

  Future<List<FoodItem>> getExpiringSoonFoods() async {
    final db = await database;

    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final DateTime threeDaysLater =
        today.add(const Duration(days: 3));

    final result = await db.query(
      'food_items',
      where:
          'date(expiryDate) >= date(?) AND date(expiryDate) <= date(?)',
      whereArgs: [
        today.toIso8601String(),
        threeDaysLater.toIso8601String(),
      ],
      orderBy: 'expiryDate ASC',
    );

    return result
        .map(
          (map) => FoodItem.fromMap(map),
        )
        .toList();
  }
}