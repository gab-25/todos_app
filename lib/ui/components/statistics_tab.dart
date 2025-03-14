import 'package:energy_monitor_app/cubits/statistics/statistics_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarChart(
                BarChartData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
