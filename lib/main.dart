import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos_app/models/user.dart';
import 'package:todos_app/ui/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    join(await getDatabasesPath(), 'todos_app.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, completed INTEGER)',
      );
      await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT, avatar TEXT)',
      );

      final initUser = User(id: 1, name: 'Gabriele Sorci', email: 'gsorci@eagleprojects.it', password: 'password');
      await db.insert('users', initUser.toMap());
    },
    version: 1,
  );

  runApp(App(db: database));
}
