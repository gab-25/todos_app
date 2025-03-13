import 'package:energy_monitor_app/models/user_settings.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'monitor_event.dart';
part 'monitor_state.dart';

class MonitorBloc extends Bloc<MonitorEvent, MonitorState> {
  MonitorBloc(this._authRepository, this._dbRepository)
      : super(MonitorState(settings: PowerSettings(maxValue: 3.3, limitValue: 3.0))) {
    on<MonitorPowerChanged>(_onMonitorPowerChanged);
    on<MonitorSettingsLoaded>(_onMonitorSettingsLoaded);
  }

  final AuthRepository _authRepository;
  final DbRepository _dbRepository;

  Future<void> _onMonitorSettingsLoaded(MonitorSettingsLoaded event, Emitter<MonitorState> emit) async {
    final userSettings = await _dbRepository.getSettings(_authRepository.currentUser!.uid);
    if (userSettings != null) {
      emit(state.copyWith(settings: userSettings.power));
    }
  }

  Future<void> _onMonitorPowerChanged(MonitorPowerChanged event, Emitter<MonitorState> emit) {
    return emit.onEach(
      _dbRepository.getStates(_authRepository.currentUser!.uid),
      onData: (states) {
        final power = double.parse((states.power / 1000).toStringAsFixed(2));
        emit(state.copyWith(power: power));
      },
      onError: addError,
    );
  }
}
