import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = 'database.db';
  static const databaseVersion = 1;

  static const table_1 = 'folders';
  static const columnid_1 = 'id';
  static const columnName_1 = 'folder_name';
  static const columnTime_1 = 'created_at';

  static const table_2 = 'cards';
  static const columnid_2 = 'id';
  static const columnName_2 = 'Name';
  static const columnSuit_2 = 'suit';
  static const columnUrl_2 = 'image_url';
  static const foreignColumn = 'folder_id';

  static Future<Database> initializeDatabase() async {
    return await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.rawQuery('''
      CREATE TABLE $table_1 (
        $columnid_1 INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName_1 TEXT NOT NULL,
        $columnTime_1 TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    
    await db.rawQuery('''
      CREATE TABLE $table_2 (
        $columnid_2 INTEGER PRIMARY KEY AUTOINCREMENT,
        $foreignColumn INTEGER,
        $columnName_2 TEXT,
        $columnSuit_2 TEXT,
        $columnUrl_2 TEXT,
        FOREIGN KEY ($foreignColumn) REFERENCES folders($columnid_1) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertFolder(String folderName) async {
    final db = await DatabaseHelper.initializeDatabase();
    return await db.insert(
      DatabaseHelper.table_1,
      {
        DatabaseHelper.columnName_1: folderName,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllFolders() async {
    final db = await DatabaseHelper.initializeDatabase();
    return await db.query(DatabaseHelper.table_1);
  }
  
  Future<int> insertCard(String cardname,String suit, String imageurl) async {
    final db = await DatabaseHelper.initializeDatabase();
    return await db.insert(
      DatabaseHelper.table_2,
      {
      DatabaseHelper.columnName_2: cardname,
      DatabaseHelper.columnSuit_2: suit,
      DatabaseHelper.columnUrl_2 : imageurl,
    });
  }

   Future<List<Map<String, dynamic>>> getCards() async {
    final db = await initializeDatabase();
    return await db.query(DatabaseHelper.table_2);
  }

  Future<int> updateFolderID(int cardid, int? folderid) async{
    final db = await DatabaseHelper.initializeDatabase();

    Map<String, dynamic> values = {
    DatabaseHelper.foreignColumn: folderid,
    };

    return await db.update(
    DatabaseHelper.table_2,
    values,
    where: '${DatabaseHelper.columnid_2} = ?',
    whereArgs: [cardid],
    );


  }
}
