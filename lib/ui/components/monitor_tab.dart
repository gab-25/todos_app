import 'package:energy_monitor_app/blocs/monitor/monitor_bloc.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MonitorTab extends StatelessWidget {
  const MonitorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorBloc(context.read<AuthRepository>(), context.read<DbRepository>())
        ..add(const MonitorSettingsLoaded())
        ..add(const MonitorPowerChanged()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<MonitorBloc, MonitorState>(
          builder: (context, state) => state.settings != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Power', style: TextStyle(fontSize: 18)),
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: state.settings!.maxValue!,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: state.settings!.limitValue!,
                              color: Colors.green,
                            ),
                            GaugeRange(
                              startValue: state.settings!.limitValue!,
                              endValue: state.settings!.maxValue!,
                              color: Colors.red,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: state.value),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text('${state.value} kW',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )),
                              angle: 90,
                              positionFactor: 0.5,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
