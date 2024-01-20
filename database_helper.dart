import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String name;
  final String nationalId;
  final String phone;
  final String password;

  User({
    this.id,
    required this.name,
    required this.nationalId,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nationalId': nationalId,
      'phone': phone,
      'password': password,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            nationalId TEXT,
            phone TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<bool> insertUser(User user) async {
    final db = await database;
    try {
      await db.insert('users', user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true; // Return true if insertion is successful
    } catch (e) {
      print('Error inserting user: $e');
      return false; // Return false if there's an error
    }
  }

  Future<bool> checkUserExists(String nationalId, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'nationalId = ? AND password = ?',
      whereArgs: [nationalId, password],
    );
    return result.isNotEmpty;
  }
}
