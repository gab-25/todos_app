import 'package:energy_monitor_app/cubits/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => context.read<LoginCubit>().onEmailChanged(value),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            obscureText: true,
            onChanged: (value) => context.read<LoginCubit>().onPasswordChanged(value),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.read<LoginCubit>().onLogin(),
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
