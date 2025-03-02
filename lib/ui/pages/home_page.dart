import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Monitor'),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  context.read<AppBloc>().add(const AppLogoutPressed()),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Monitor')),
            Center(child: Text('Statistics')),
            Center(child: Text('Settings')),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.monitor)),
            Tab(icon: Icon(Icons.bar_chart_outlined)),
            Tab(icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}
