import 'package:sqflite/sqflite.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/services/entity_service.dart';

class TodoRepository {
  TodoRepository(this._db) {
    _entityService = EntityService(
      _db,
      'todos',
      (map) => Todo.fromMap(map),
      (todo) => todo.toMap(),
    );
  }

  final Database _db;
  late final EntityService<Todo> _entityService;


  Future<List<Todo>> getTodos() {
    return _entityService.getEntities();
  }

  Future<Todo?> getTodo(int id) {
    return _entityService.getEntity(id);
  }

  Future<void> saveTodo(Todo todo) {
    return _entityService.saveEntity(todo);
  }

  Future<void> deleteTodo(int id) {
    return _entityService.deleteEntity(id);
  }
}
