part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}
final class AppUserAuthChanged extends AppEvent {
  const AppUserAuthChanged();
}
