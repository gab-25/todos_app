import 'package:energy_monitor_app/models/user.dart';
import 'package:equatable/equatable.dart';

enum AppStatus { authenticated, unauthenticated }
class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.unauthenticated,
    this.user = const User(),
  });

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  AppState copyWith({AppStatus? status}) {
    return AppState(
      status: status ?? this.status,
      user: user,
    );
  }
}
