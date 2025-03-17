import 'package:todos_app/models/todo.dart';
import 'package:todos_app/services/db_service.dart';

class TodoRepository {
  TodoRepository(this._dbService);

  final table = 'todos';

  final DbService _dbService;

  Future<List<Todo>> getTodos() async {
    return (await _dbService.getEntities(table)).map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<Todo> getTodo(int id) async {
    return Todo.fromMap(await _dbService.getEntity(table, id));
  }

  Future<void> saveTodo(Todo todo) async {
    return _dbService.saveEntity(table, todo.toMap());
  }

  Future<void> deleteTodo(int id) async {
    return _dbService.deleteEntity(table, id);
  }
}
