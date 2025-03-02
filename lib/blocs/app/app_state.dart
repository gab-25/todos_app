import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AppStatus { authenticated, unauthenticated }

enum AppTabs {
  monitor,
  statistics,
  settings;

  @override
  String toString() {
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
}

class AppState extends Equatable {
  const AppState({this.user, this.tabSelected = AppTabs.monitor})
      : status =
            user != null ? AppStatus.authenticated : AppStatus.unauthenticated;

  final AppStatus status;
  final User? user;
  final AppTabs tabSelected;

  @override
  List<Object> get props => [status, tabSelected];

  AppState copyWith({User? user, AppTabs? tabSelected}) {
    return AppState(
      user: user ?? this.user,
      tabSelected: tabSelected ?? this.tabSelected,
    );
  }
}
