import 'package:todos_app/models/user.dart';
import 'package:todos_app/services/db_service.dart';

class UserRepository {
  UserRepository(this._dbService);

  final table = 'users';

  final DbService _dbService;

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final users = (await _dbService.getEntities(table)).map((user) => User.fromMap(user)).toList();
    try {
      return users.firstWhere((user) => user.email == email && user.password == password);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> getUser(int id) async {
    return User.fromMap(await _dbService.getEntity(table, id));
  }

  Future<void> updateUser(User user) async {
    return _dbService.saveEntity(table, user.toMap());
  }
}
