import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'users';

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('Initializing database...');

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');

    return openDatabase(path, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT, age INTEGER, job TEXT)');
    }, version: 1);
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(tableName, user,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(tableName);
  }
}
