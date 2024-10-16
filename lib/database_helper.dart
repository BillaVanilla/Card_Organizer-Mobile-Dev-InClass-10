import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = 'your_database.db';
  static const databaseVersion = 1;

  static Future<Database> initializeDatabase() async {
    return await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.rawQuery('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    
    await db.rawQuery('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_id INTEGER NOT NULL,
        card_name TEXT NOT NULL,
        card_content TEXT,
        FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE
      )
    ''');
  }
}
