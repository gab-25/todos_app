part of 'settings_cubit.dart';

enum SettingsStatus { initial, modified, success, error }

class SettingsState extends Equatable {
  const SettingsState({this.status = SettingsStatus.initial, this.power});

  final SettingsStatus status;
  final PowerSettings? power;

  @override
  List<Object?> get props => [status, power];

  SettingsState copyWith({SettingsStatus? status, PowerSettings? power}) {
    return SettingsState(
      status: status ?? this.status,
      power: power ?? this.power,
    );
  }
}
