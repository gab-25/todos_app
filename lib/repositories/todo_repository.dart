import 'package:todos_app/models/todo.dart';
import 'package:todos_app/services/db_service.dart';

class TodoRepository {
  TodoRepository(this._dbService);

  final DbService _dbService;

  Future<List<Todo>> getTodos() async {
    return _dbService.getEntities<Todo>();
  }

  Future<List<Todo>> getTodo(int id) async {
    return _dbService.getEntity<Todo>(id);
  }

  Future<void> saveTodo(Todo todo) async {
    return _dbService.saveEntity<Todo>(todo);
  }

  Future<void> deleteTodo(int id) async {
    return _dbService.deleteEntity(id);
  }
}
