import 'package:sqflite/sqflite.dart';
import 'package:todos_app/blocs/app/app_bloc.dart';
import 'package:todos_app/repositories/user_repository.dart';
import 'package:todos_app/repositories/todo_repository.dart';
import 'package:todos_app/ui/pages/todo_page.dart';
import 'package:todos_app/ui/pages/login_page.dart';
import 'package:todos_app/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key, required this.db});

  final Database db;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserRepository(db)),
        RepositoryProvider(create: (context) => TodoRepository(db)),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(context.read<UserRepository>())..add(const AppUserAuthChanged()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark,
          primary: Colors.yellow[400],
        ),
        useMaterial3: true,
      ),
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.status == AppStatus.authenticated) {
            return const TodoPage();
          }
          if (state.status == AppStatus.unauthenticated) {
            return const LoginPage();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      routes: {
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
