part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLoginPressed extends AppEvent {
  const AppLoginPressed(this.email, this.password);

  final String email;
  final String password;
}

final class AppLogoutPressed extends AppEvent {
  const AppLogoutPressed();
}

final class AppUserUpdated extends AppEvent {
  const AppUserUpdated();
}
