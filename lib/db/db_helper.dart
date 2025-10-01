import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'users';
  static bool _isInitialized = false;

  static void _initializeSqlite() {
    if (!_isInitialized &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      sqfliteFfiInit();
      // Para Linux, especificar o caminho exato da biblioteca
      if (Platform.isLinux) {
        // Usar a biblioteca do sistema
        databaseFactory = databaseFactoryFfiNoIsolate;
      } else {
        databaseFactory = databaseFactoryFfi;
      }
      _isInitialized = true;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    _initializeSqlite();

    String path;
    try {
      path = join(await getDatabasesPath(), 'your_database.db');
    } catch (e) {
      // Fallback para desktop se getDatabasesPath() falhar
      path = 'your_database.db';
    }

    print('Database path: $path');

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        print('Creating table $tableName');
        await db.execute('CREATE TABLE $tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'username TEXT UNIQUE NOT NULL, '
            'email TEXT NOT NULL, '
            'password TEXT NOT NULL, '
            'age INTEGER NOT NULL, '
            'job TEXT NOT NULL'
            ')');
        print('Table $tableName created successfully');
      },
      version: 1,
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      print('Inserting user: ${user['username']}');
      int result = await db.insert(
        tableName,
        user,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      print('User inserted successfully with ID: $result');
      return result;
    } catch (e) {
      print('Error inserting user: $e');
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Username already exists');
      }
      throw Exception('Database error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final db = await database;
      print('Fetching all users');
      List<Map<String, dynamic>> result = await db.query(tableName);
      print('Found ${result.length} users');
      return result;
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Database error: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    try {
      final db = await database;
      print('Authenticating user: $username');
      List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      if (result.isNotEmpty) {
        print('User authenticated successfully');
        return result.first;
      } else {
        print('Invalid credentials');
        return null;
      }
    } catch (e) {
      print('Error authenticating user: $e');
      throw Exception('Database error: $e');
    }
  }

  Future<bool> userExists(String username) async {
    try {
      final db = await database;
      print('Checking if user exists: $username');
      List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: 'username = ?',
        whereArgs: [username],
      );
      bool exists = result.isNotEmpty;
      print('User exists: $exists');
      return exists;
    } catch (e) {
      print('Error checking user existence: $e');
      throw Exception('Database error: $e');
    }
  }

  // Método para testar a conexão com o banco
  Future<bool> testConnection() async {
    try {
      final db = await database;
      await db.rawQuery('SELECT 1');
      print('Database connection test successful');
      return true;
    } catch (e) {
      print('Database connection test failed: $e');
      return false;
    }
  }

  // Método para limpar o banco (útil para testes)
  Future<void> clearDatabase() async {
    try {
      final db = await database;
      await db.delete(tableName);
      print('Database cleared');
    } catch (e) {
      print('Error clearing database: $e');
      throw Exception('Database error: $e');
    }
  }
}
