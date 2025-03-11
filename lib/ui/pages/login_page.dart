import 'package:energy_monitor_app/cubits/login/login_cubit.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/ui/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: BlocProvider(
            create: (context) => LoginCubit(context.read<AuthRepository>()),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
