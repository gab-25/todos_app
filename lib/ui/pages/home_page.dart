import 'package:energy_monitor_app/blocs/app/app_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:energy_monitor_app/blocs/app/app_state.dart';
import 'package:energy_monitor_app/ui/pages/monitor_page.dart';
import 'package:energy_monitor_app/ui/pages/settings_page..dart';
import 'package:energy_monitor_app/ui/pages/statistics_page..dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTabs tabSelected =
        context.select((AppBloc bloc) => bloc.state.tabSelected);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(tabSelected.toString()),
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
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.tabSelected == AppTabs.monitor) {
            return MonitorPage();
          }
          if (state.tabSelected == AppTabs.statistics) {
            return StatisticsPage();
          }
          if (state.tabSelected == AppTabs.settings) {
            return SettingsPage();
          }
          return const Text('No page found!');
        },
      ),
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
        onTap: (value) =>
            context.read<AppBloc>().add(AppTabPressed(AppTabs.values[value])),
        currentIndex: AppTabs.values.indexOf(tabSelected),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
