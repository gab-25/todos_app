import 'package:energy_monitor_app/ui/pages/home_page.dart';
import 'package:energy_monitor_app/cubits/login/login_cubit.dart';
import 'package:energy_monitor_app/cubits/login/login_state.dart';
import 'package:energy_monitor_app/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: context.read<LoginCubit>().state.status == LoginStatus.success
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
