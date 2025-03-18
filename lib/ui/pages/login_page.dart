import 'package:todos_app/cubits/auth/auth_cubit.dart';
import 'package:todos_app/repositories/user_repository.dart';
import 'package:todos_app/ui/components/login_form.dart';
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
            create: (context) => AuthCubit(context.read<UserRepository>()),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
