import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;
  
  // Table name and columns for the closet items
  static const String tableName = 'closetItems';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnBrand = 'brand';
  static const String columnImage = 'image';
  static const String columnType = 'type';
  static const String columnColor = 'color';
  static const String columnAttire = 'attire';
  static const String columnSize = 'size';

  // Initialize the database for sqflite_common_ffi
  static void initialize() {
    databaseFactory = databaseFactoryFfi; // Use FFI for desktop
  }

  // Create the database and table
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'closet.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create the table if it doesn't exist
  void _createDatabase(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnBrand TEXT,
        $columnImage TEXT,
        $columnType TEXT,
        $columnColor TEXT,
        $columnAttire TEXT,
        $columnSize TEXT
      )
    ''');
  }

  // Insert a new closet item
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(tableName, item);
  }

  // Fetch all closet items
  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    final db = await database;
    return await db.query(tableName);
  }

  // Fetch a single closet item by ID
  Future<Map<String, dynamic>?> fetchItemById(int id) async {
    final db = await database;
    final result = await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Update a closet item
  Future<int> updateItem(int id, Map<String, dynamic> updatedItem) async {
    final db = await database;
    return await db.update(tableName, updatedItem, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete a closet item by ID
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
