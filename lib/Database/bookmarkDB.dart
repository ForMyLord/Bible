import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/bookmark.dart';

const String tableName = 'bookmark';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if(_db != null) return _db;

    _db = openDatabase(
      join(await getDatabasesPath(),'bookmark.db'),

      onCreate: (db,version){
        return db.execute(
          "CREATE TABLE bookmark(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, bible TEXT, chapter INTEGER, verse INTEGER, setTime TEXT, content TEXT)"
        );
      },
      version: 1
    );

    return _db;
  }

  Future<void> insertBookMark(BookMark bookMark) async {
    final db = await database;

    await db.insert(
      tableName,
      bookMark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace // 동일한 데이터 여러번 추가시, 이전 데이터 덮어쓰기
    );

  }

  Future<List<BookMark>> getBookMark() async {
    final db = await database;

    final List<Map<String,dynamic>> bookmarks = await db.query('bookmark');

    return List.generate(bookmarks.length, (i){
      return BookMark(
          bible: bookmarks[i]['bible'],
          chapter: bookmarks[i]['chapter'],
          verse: bookmarks[i]['verse'],
          setTime: bookmarks[i]['setTime'],
          content: bookmarks[i]['content']
      );
    });
  }

  Future<void> deleteBookMark(int id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );

  }

  Future<List<Map<String,dynamic>>> queryAll() async {
    Database db = await database;

    List<Map<String,dynamic>> results = await db.query('bookmark');

    return results;
  }
}