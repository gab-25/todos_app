part of 'monitor_bloc.dart';

class MonitorState extends Equatable {
  const MonitorState({this.power = 0});

  final double power;

  @override
  List<Object?> get props => [power];

  MonitorState copyWith({double? power}) {
    return MonitorState(
      power: power ?? this.power,
    );
  }
}
