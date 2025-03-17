import 'package:sqflite/sqflite.dart';

class DbService {
  DbService(this._db);

  final Database _db;

  String _getTableName<T>() {
    return (T as dynamic).table;
  }

  Future<List<T>> getEntities<T>() async {
    final response = await _db.query(_getTableName());
    if (response.isEmpty) {
      return [];
    }
    return response.map((e) => (T as dynamic).fromMap(e) as T).toList();
  }

  getEntity<T>(int id) async {
    return (await _db.query((T as dynamic).table, where: 'id = ?', whereArgs: [id]));
  }

  saveEntity<T>(T entity) {
    if ((entity as dynamic).id != null) {
      return _db.update(_getTableName(), (entity as dynamic).toMap(), where: 'id = ?', whereArgs: [entity.id]);
    } else {
      return _db.insert(_getTableName(), (entity as dynamic).toMap());
    }
  }

  deleteEntity(int id) {
    return _db.delete(_getTableName(), where: 'id = ?', whereArgs: [id]);
  }
}
