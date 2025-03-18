import 'package:sqflite/sqflite.dart';

class EntityService<T> {
  EntityService(this._db, this._table, this._fromMap, this._toMap);

  final Database _db;
  final String _table;
  final T Function(Map<String, dynamic> map) _fromMap;
  final Map<String, dynamic> Function(T) _toMap;

  Future<List<T>> getEntities() async {
    return (await _db.query(_table)).map((e) => _fromMap(e)).toList();
  }

  Future<T?> getEntity(int id) async {
    try {
      return _fromMap((await _db.query(_table, where: 'id = ?', whereArgs: [id])).first);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> saveEntity(T entity) {
    final entityMap = _toMap(entity);
    if (entityMap['id'] != null) {
      return _db.update(_table, entityMap, where: 'id = ?', whereArgs: [entityMap['id']]);
    } else {
      return _db.insert(_table, entityMap);
    }
  }

  Future<int> deleteEntity(int id) {
    return _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
