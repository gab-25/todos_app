import 'package:energy_monitor_app/login/cubit/login_cubit.dart';
import 'package:energy_monitor_app/login/view/login_form.dart';
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
            create: (context) => LoginCubit(),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
