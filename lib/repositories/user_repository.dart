import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todos_app/models/user.dart';
import 'package:todos_app/services/entity_service.dart';

class UserRepository {
  UserRepository(this._db) {
    _entityService = EntityService(
      _db,
      'users',
      (map) => User.fromMap(map),
      (user) => user.toMap(),
    );
  }

  final Database _db;
  late final EntityService<User> _entityService;

  User? _userAuth;
  final StreamController<User?> _userAuthController = StreamController<User?>();

  User? get currentUserAuth => _userAuth;

  Stream<User?> get userAuth {
    return _userAuthController.stream;
  }

  Future<bool> authUserByEmailAndPassword(String email, String password) async {
    final users = await _entityService.getEntities();
    try {
      final userAuth = users.firstWhere((user) => user.email == email && user.password == password);
      _userAuth = userAuth;
      _userAuthController.add(_userAuth);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void setUserAuthToNull() {
    _userAuth = null;
    _userAuthController.add(null);
  }

  Future<User?> getUser(int id) {
    return _entityService.getEntity(id);
  }

  Future<void> updateUser(User user) async {
    await _entityService.saveEntity(user);
    if (_userAuth?.id == user.id) {
      _userAuth = user;
      _userAuthController.add(_userAuth);
    }
  }
}
