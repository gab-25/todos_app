import 'dart:async';
import 'package:todos_app/models/user.dart';
import 'package:todos_app/services/db_service.dart';

class AuthRepository {
  AuthRepository(this._dbService);

  final DbService _dbService;

  User? _user;

  User? get currentUser {
    return _user;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final users = await _dbService.getEntities<User>();
    final user = users.firstWhere((user) => user.email == email && user.password == password);
    if (user.id != null) {
      _user = user;
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    _user = null;
  }

  Future<void> updateUser(User user) async {
    return _dbService.saveEntity<User>(user);
  }
}
