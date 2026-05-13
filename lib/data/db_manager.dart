
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {

  String _dbName = "book.db";

  static final DbManager instance = DbManager._init();

  DbManager._init();

  Future<Database> get database async{
    // DB Path
    final dbPath = await getDatabasesPath();
    // Path
    String path = join(dbPath, _dbName);
    // Create DB
    return openDatabase(path, onCreate: _onTableCreate, version: 1);
  }

  Future<void> _onTableCreate(Database db, int version) async{
    String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    String textType = "TEXT";
    String doubleType = "REAL";
    String intType = "INTEGER";

    String _bookTable = '''
      CREATE TABLE IF NOT EXISTS books (
        id $idType,
        title $textType,
        description $textType,
        price $doubleType,
        author $textType,
        rate $intType,
        stock $intType,
        status $intType
      );
    ''';
    await db.execute(_bookTable);

    String _orderTable = '''
      CREATE TABLE IF NOT EXISTS orders (
        id $idType,
        book_id $intType,
        qty $intType,
        amount $doubleType,
        phone_number $textType,
        discount $intType,
        total_amount $intType
      );
    ''';
    await db.execute(_orderTable);

    String _categoryTable = '''
      CREATE TABLE IF NOT EXISTS categories (
        id $idType,
        name $textType,
        status $intType
      );
    ''';
    await db.execute(_categoryTable);
  }

}