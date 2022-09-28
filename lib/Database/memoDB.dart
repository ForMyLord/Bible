import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/memoList.dart';

const String tableName = 'memo';

class DBHelperMemo {

  var _db;

  Future<Database> get database async {
    if(_db!=null) return _db;

    _db = openDatabase(
      join(await getDatabasesPath(),'memo.db'),
      onCreate: (db,version){
        return db.execute(
          "CREATE TABLE memo(id TEXT, setTime TEXT, content TEXT, title TEXT)"
        );
      },
      version: 1
    );

    return _db;
  }

  Future<void> insertMemo(MemoList memoList) async {
    final db = await database;

    await db.insert(
        tableName,
        memoList.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<MemoList>> getMemoList() async {
    final db = await database;

    final List<Map<String,dynamic>> memos = await db.query('memo');

    return List.generate(memos.length, (i){
      return MemoList(
          title: memos[i]['title'],
          content: memos[i]['content'],
          setTime: memos[i]['setTime'],
          id: memos[i]['id']);
    });
  }

  Future<void> deleteMemoList(String id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateMemoList(MemoList memoList) async {
    final db = await database;

    await db.update(
      tableName,
      memoList.toMap(),
      where: 'id = ?',
      whereArgs: [memoList.id]
    );
  }

}