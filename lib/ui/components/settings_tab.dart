import 'package:todos_app/cubits/settings/settings_cubit.dart';
import 'package:todos_app/repositories/auth_repository.dart';
import 'package:todos_app/repositories/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(context.read<AuthRepository>(), context.read<DbRepository>()),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
          }
          if (state.status == SettingsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save settings')));
          }
        },
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
                              labelText: 'Limit value (kW)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            initialValue: (state.power!.limitValue).toString(),
                            onChanged: (value) => context.read<SettingsCubit>().onPowerLimitValueChanged(value),
                          ),
                          const SizedBox(height: 20),
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
                            onChanged: (value) => context.read<SettingsCubit>().onPowerMaxValueChanged(value),
                          ),
                        ]),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: state.status == SettingsStatus.modified ? () {
                                context.read<SettingsCubit>().onSave();
                              } : null,
                              child: const Text('Save'), // trying to move to the bottom
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
