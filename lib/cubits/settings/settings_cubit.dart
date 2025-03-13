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
        limitValue: (userSettings.power?.limitValue != null ? (userSettings.power!.limitValue! / 1000) : 0.0),
        maxValue: (userSettings.power?.maxValue != null ? (userSettings.power!.maxValue! / 1000) : 0.0),
      );
      emit(state.copyWith(power: power));
    }
  }

  void onPowerLimitValueChanged(String value) {
    final power = PowerSettings(
      maxValue: state.power!.maxValue,
      limitValue: double.tryParse(value),
    );
    emit(state.copyWith(status: SettingsStatus.modified, power: power));
  }

  void onPowerMaxValueChanged(String value) {
    final power = PowerSettings(
      maxValue: double.tryParse(value),
      limitValue: state.power!.limitValue,
    );
    emit(state.copyWith(status: SettingsStatus.modified, power: power));
  }

  Future<void> onSave() async {
    final userId = _authRepository.currentUser!.uid;
    UserSettings settings = (await _dbRepository.getSettings(userId)) ?? UserSettings();
    settings.power = PowerSettings(
      limitValue: state.power!.limitValue! * 1000,
      maxValue: state.power!.maxValue! * 1000,
    );
    try {
      await _dbRepository.saveSettings(settings, userId);
      emit(state.copyWith(status: SettingsStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }
}
