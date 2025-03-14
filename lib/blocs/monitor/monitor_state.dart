part of 'monitor_bloc.dart';

enum MonitorStatus { connected, disconnected, error }

class MonitorConsumption {
  const MonitorConsumption({required this.today, required this.thisMonth});

  final String today;
  final String thisMonth;
}

class MonitorState extends Equatable {
  const MonitorState({this.value = 0, this.status, this.settings, this.consumption});

  final double value;
  final MonitorStatus? status;
  final PowerSettings? settings;
  final MonitorConsumption? consumption;

  @override
  List<Object?> get props => [value, status, settings, consumption];

  MonitorState copyWith({
    double? value,
    MonitorStatus? status,
    PowerSettings? settings,
    MonitorConsumption? consumption,
  }) {
    return MonitorState(
      value: value ?? this.value,
      status: status ?? this.status,
      settings: settings ?? this.settings,
      consumption: consumption ?? this.consumption,
    );
  }
}
