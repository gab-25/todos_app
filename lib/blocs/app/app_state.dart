part of 'app_bloc.dart';

enum AppStatus { initial, authenticated, unauthenticated }
class AppState extends Equatable {
  const AppState({this.user, this.status = AppStatus.initial});

  final AppStatus status;
  final User? user;

  @override
  List<Object?> get props => [status, user];

  AppState copyWith({User? user, AppStatus? status}) {
    return AppState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
