import 'package:energy_monitor_app/models/user_settings.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._authRepository, this._dbRepository) : super(const SettingsState()) {
    _init();
  }

  final AuthRepository _authRepository;
  final DbRepository _dbRepository;

  Future<void> _init() async {
    final userSettings = await _dbRepository.getSettings(_authRepository.currentUser!.uid);
    if (userSettings != null) {
      final power = PowerSettings(
        maxValue: (userSettings.power?.maxValue != null ? (userSettings.power!.maxValue! / 1000) : 0.0),
        limitValue: (userSettings.power?.limitValue != null ? (userSettings.power!.limitValue! / 1000) : 0.0),
      );
      emit(state.copyWith(power: power));
    }
  }
}
