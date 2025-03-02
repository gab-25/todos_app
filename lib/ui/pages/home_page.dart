import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AppBloc>().add(const AppLogoutPressed()),
          ),
        ],
      ),
      body: Center(
        child: Text(user?.email ?? 'No user'),
      ),
    );
  }
}
