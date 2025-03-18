part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  const AuthState({
    this.email = '',
    this.password = '',
    this.status = AuthStatus.initial,
  });

  final String email;
  final String password;
  final AuthStatus status;

  @override
  List<Object?> get props => [email, password, status];

  AuthState copyWith({
    String? email,
    String? password,
    AuthStatus? status,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
