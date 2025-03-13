part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({this.power});

  final PowerSettings? power;

  @override
  List<Object?> get props => [power];

  SettingsState copyWith({PowerSettings? power}) {
    return SettingsState(power: power ?? this.power);
  }
}
