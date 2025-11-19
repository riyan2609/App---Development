import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static const String DB_NAME = 'calc_history.db';
  static const String TABLE = 'history';
  static const String ID = 'id';
  static const String EXPRESSION = 'expression';
  static const String RESULT = 'result';

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE (
        $ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $EXPRESSION TEXT,
        $RESULT TEXT
      )
    ''');
  }

  Future<int> insertHistory(String expression, String result) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, {
      EXPRESSION: expression,
      RESULT: result,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    var dbClient = await db;
    return await dbClient.query(TABLE, orderBy: '$ID DESC');
  }

  Future<void> clearHistory() async {
    var dbClient = await db;
    await dbClient.delete(TABLE);
  }
}
