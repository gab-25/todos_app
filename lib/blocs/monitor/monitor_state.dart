part of 'monitor_bloc.dart';

enum MonitorStatus { connected, disconnected, error }

class MonitorState extends Equatable {
  const MonitorState({this.value = 0, this.status, this.settings});

  final double value;
  final MonitorStatus? status;
  final PowerSettings? settings;

  @override
  List<Object?> get props => [value, status, settings];

  MonitorState copyWith({
    double? value,
    MonitorStatus? status,
    PowerSettings? settings,
  }) {
    return MonitorState(
      value: value ?? this.value,
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }
}
