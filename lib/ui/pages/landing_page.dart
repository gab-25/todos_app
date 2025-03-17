import 'package:todos_app/ui/components/monitor_tab.dart';
import 'package:todos_app/ui/components/settings_tab.dart';
import 'package:todos_app/ui/components/statistics_tab.dart';
import 'package:flutter/material.dart';

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
  const LandingPage({super.key, required AppTabs tabSelected}) : _tabSelected = tabSelected;

  final AppTabs _tabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(_tabSelected.toString()),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            iconSize: 32,
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (_tabSelected == AppTabs.monitor) {
          return const MonitorTab();
        }
        if (_tabSelected == AppTabs.statistics) {
          return const StatisticsTab();
        }
        if (_tabSelected == AppTabs.settings) {
          return const SettingsTab();
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
        onTap: (value) => Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => LandingPage(tabSelected: AppTabs.values[value]),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        )),
        currentIndex: AppTabs.values.indexOf(_tabSelected),
        selectedItemColor: Theme.of(context).colorScheme.surface,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
