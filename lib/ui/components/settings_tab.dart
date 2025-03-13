import 'package:energy_monitor_app/cubits/settings/settings_cubit.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(context.read<AuthRepository>(), context.read<DbRepository>()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) => state.power != null
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        const Text(
                          'Power',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Max value (kW)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                          ],
                          initialValue: (state.power!.maxValue).toString(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Limit value (kW)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                          ],
                          initialValue: (state.power!.limitValue).toString(),
                        ),
                      ]),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
