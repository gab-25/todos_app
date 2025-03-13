part of 'monitor_bloc.dart';

class MonitorState extends Equatable {
  const MonitorState({this.value = 0, this.settings});

  final double value;
  final PowerSettings? settings;

  @override
  List<Object?> get props => [value, settings];

  MonitorState copyWith({
    double? power,
    PowerSettings? settings,
  }) {
    return MonitorState(
      value: power ?? value,
      settings: settings ?? this.settings,
    );
  }
}
