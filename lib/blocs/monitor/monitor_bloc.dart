import 'package:todos_app/models/user_settings.dart';
import 'package:todos_app/repositories/auth_repository.dart';
import 'package:todos_app/repositories/db_repository.dart';
import 'package:todos_app/services/shelly_cloud_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'monitor_event.dart';
part 'monitor_state.dart';

class MonitorBloc extends Bloc<MonitorEvent, MonitorState> {
  MonitorBloc(this._authRepository, this._dbRepository, this._shellyCloudService) : super(const MonitorState()) {
    on<MonitorSettingsLoaded>(_onMonitorSettingsLoaded);
    on<MonitorStatusChanged>(_onMonitorStatusChanged);
    on<MonitorConsumptionUpdated>(_onMonitorConsumptionUpdated);
  }

  final AuthRepository _authRepository;
  final DbRepository _dbRepository;
  final ShellyCloudService _shellyCloudService;

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

  Future<void> _onMonitorConsumptionUpdated(MonitorConsumptionUpdated event, Emitter<MonitorState> emit) async {
    //TODO: transform to stream and update every 10 minutes
    final userSettings = await _dbRepository.getSettings(_authRepository.currentUser!.uid);
    final url = userSettings!.shellyCloud!.url!;
    final accessToken = userSettings!.shellyCloud!.accessToken!;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final month = [
      DateTime(today.year, today.month, 1),
      DateTime(today.year, today.month + 1, 1).subtract(const Duration(days: 1))
    ];
    final statisticsData = {
      "day": await _shellyCloudService.getStatisticsData(url, accessToken, today, null),
      "month": await _shellyCloudService.getStatisticsData(url, accessToken, month[0], month[1]),
    };
    final todayValues = (statisticsData['day']!['history'] as List<dynamic>)
        .where((e) => e['consumption'] != null)
        .map((e) => e['consumption'] as double)
        .toList();
    final monthValues = (statisticsData['month']!['history'] as List<dynamic>)
        .where((e) => e['consumption'] != null)
        .map((e) => e['consumption'] as double)
        .toList();
    final consumption = MonitorConsumption(
      today: (todayValues.reduce((value, element) => value + element) / 1000).toStringAsFixed(2),
      thisMonth: (monthValues.reduce((value, element) => value + element) / 1000).toStringAsFixed(2),
    );
    emit(state.copyWith(consumption: consumption));
  }
}
