part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}
final class AppStatusChanged extends AppEvent {
  const AppStatusChanged();
}

final class AppLogoutPressed extends AppEvent {
  const AppLogoutPressed();
}

final class AppUserUpdated extends AppEvent {
  const AppUserUpdated();
}
