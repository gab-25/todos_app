import 'package:sqflite/sqflite.dart';
import 'package:todos_app/blocs/app/app_bloc.dart';
import 'package:todos_app/repositories/auth_repository.dart';
import 'package:todos_app/repositories/todo_repository.dart';
import 'package:todos_app/services/db_service.dart';
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
    return MultiProvider(
      providers: [
        Provider(create: (_) => DbService(db)),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository(context.read<DbService>())),
          RepositoryProvider(create: (context) => TodoRepository(context.read<DbService>())),
        ],
        child: BlocProvider(
          create: (context) => AppBloc(context.read<AuthRepository>()),
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Monitor',
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
