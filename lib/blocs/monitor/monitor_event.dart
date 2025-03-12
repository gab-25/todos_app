part of 'monitor_bloc.dart';

sealed class MonitorEvent {
  const MonitorEvent();
}

final class MonitorPowerChanged extends MonitorEvent {
  const MonitorPowerChanged();
}
