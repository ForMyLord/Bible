import 'package:bible/Model/userSettingData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableName = 'userSettingData';

class DBHelperSetting {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = openDatabase(join(await getDatabasesPath(), 'userSettingData.db'),
        onCreate: (db, version) {
          return db.execute(
              "CREATE TABLE userSettingData(fontSize TEXT, fontStyle TEXT)");
        }, version: 1);

    return _db;
  }

  Future<void> initSettingValue() async{

    // 앱 시작시 기본 폰트로 지정하기
    final db = await database;
    db.insert(tableName, userSettingDatas(fontSize: 20, fontStyle: '').toMap());
  }

  Future<void> changeUserSettingValue(userSettingDatas userSettingData) async {
    final db = await database;

    await db.update(tableName, userSettingData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace // 동일한 데이터 여러번 추가시, 이전 데이터 덮어쓰기
    );
  }

  Future<List<userSettingDatas>> getuserSettingData() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query('userSettingData');

    return List.generate(result.length, (i) {
      return userSettingDatas(
        fontSize: result[i]['fontSize'],
        fontStyle: result[i]['fontStyle'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await database;

    List<Map<String, dynamic>> results = await db.query('userSettingData');

    return results;
  }
}


