import 'package:energy_monitor_app/models/user_settings.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'monitor_event.dart';
part 'monitor_state.dart';

class MonitorBloc extends Bloc<MonitorEvent, MonitorState> {
  MonitorBloc(this._authRepository, this._dbRepository) : super(const MonitorState()) {
    on<MonitorSettingsLoaded>(_onMonitorSettingsLoaded);
    on<MonitorStatusChanged>(_onMonitorStatusChanged);
  }

  final AuthRepository _authRepository;
  final DbRepository _dbRepository;

  Future<void> _onMonitorSettingsLoaded(MonitorSettingsLoaded event, Emitter<MonitorState> emit) async {
    final userSettings = await _dbRepository.getSettings(_authRepository.currentUser!.uid);
    if (userSettings != null) {
      final settings = PowerSettings(
        maxValue: (userSettings.power?.maxValue != null ? (userSettings.power!.maxValue! / 1000) : 0.0),
        limitValue: (userSettings.power?.limitValue != null ? (userSettings.power!.limitValue! / 1000) : 0.0),
      );
      emit(state.copyWith(settings: settings));
    }
  }

  Future<void> _onMonitorStatusChanged(MonitorStatusChanged event, Emitter<MonitorState> emit) {
    return emit.onEach(
      _dbRepository.getStates(_authRepository.currentUser!.uid),
      onData: (states) {
        final status = states.shellyCloudConnected ? MonitorStatus.connected : MonitorStatus.disconnected;
        final value = double.parse((states.power / 1000).toStringAsFixed(2));
        emit(state.copyWith(status: status, value: value));
      },
      onError: addError,
    );
  }
}
