import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:energy_monitor_app/ui/pages/monitor_page.dart';
import 'package:energy_monitor_app/ui/pages/settings_page..dart';
import 'package:energy_monitor_app/ui/pages/statistics_page..dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTabs {
  monitor,
  statistics,
  settings;

  @override
  String toString() {
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required AppTabs tabSelected})
      : _tabSelected = tabSelected;

  final AppTabs _tabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_tabSelected.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () =>
                context.read<AppBloc>().add(const AppLogoutPressed()),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (_tabSelected == AppTabs.monitor) {
          return MonitorPage();
        }
        if (_tabSelected == AppTabs.statistics) {
          return StatisticsPage();
        }
        if (_tabSelected == AppTabs.settings) {
          return SettingsPage();
        }
        return const Center(child: Text('Not widget found'));
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.monitor_outlined),
            label: AppTabs.monitor.toString(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            label: AppTabs.statistics.toString(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: AppTabs.settings.toString(),
          ),
        ],
        onTap: (value) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                LandingPage(tabSelected: AppTabs.values[value]))),
        currentIndex: AppTabs.values.indexOf(_tabSelected),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
