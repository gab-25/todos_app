import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:energy_monitor_app/services/shelly_cloud_service.dart';
import 'package:energy_monitor_app/ui/pages/landing_page.dart';
import 'package:energy_monitor_app/ui/pages/login_page.dart';
import 'package:energy_monitor_app/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => const ShellyCloudService()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => AuthRepository()),
          RepositoryProvider(create: (_) => DbRepository()),
        ],
        child: BlocProvider(
          create: (context) => AppBloc(context.read<AuthRepository>())..add(const AppStatusChanged()),
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
            return const LandingPage(tabSelected: AppTabs.monitor);
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
