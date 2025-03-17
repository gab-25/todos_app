part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  const AuthState({
    this.email = '',
    this.password = '',
    this.status = AuthStatus.initial,
    this.user,
  });

  final String email;
  final String password;
  final AuthStatus status;
  final User? user;

  @override
  List<Object?> get props => [email, password, status, user];

  AuthState copyWith({
    String? email,
    String? password,
    AuthStatus? status,
    User? user,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
