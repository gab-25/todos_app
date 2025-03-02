import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState({this.user})
      : status =
            user != null ? AppStatus.authenticated : AppStatus.unauthenticated;

  final AppStatus status;
  final User? user;

  @override
  List<Object> get props => [status];
}
