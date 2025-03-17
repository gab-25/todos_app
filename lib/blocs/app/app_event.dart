part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}
final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User? user;
}
