import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState({this.status = AppStatus.unauthenticated, this.user});

  final AppStatus status;
  final User? user;

  @override
  List<Object> get props => [status];

  AppState copyWith({AppStatus? status, User? user}) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
