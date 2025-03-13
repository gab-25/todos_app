part of 'monitor_bloc.dart';

sealed class MonitorEvent {
  const MonitorEvent();
}

final class MonitorSettingsLoaded extends MonitorEvent {
  const MonitorSettingsLoaded();
}

final class MonitorStatusChanged extends MonitorEvent {
  const MonitorStatusChanged();
}
