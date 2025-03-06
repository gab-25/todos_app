import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/ui/pages/landing_page.dart';
import 'package:energy_monitor_app/ui/pages/login_page.dart';
import 'package:energy_monitor_app/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key, required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider(
        create: (_) => AppBloc(_authRepository)..add(const AppStatusChanged()),
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
            return const LandingPage(tabSelected: AppTabs.monitor);
          }
          return const LoginPage();
        },
      ),
      routes: {
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
