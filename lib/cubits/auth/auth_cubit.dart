import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/repositories/user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._userRepository) : super(const AuthState());

  final UserRepository _userRepository;

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: AuthStatus.initial));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: AuthStatus.initial));
  }

  Future<void> onLogin() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _userRepository.authUserByEmailAndPassword(state.email, state.password);
    if (result) {
      emit(state.copyWith(status: AuthStatus.success));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> onLogout() async {
    _userRepository.setUserAuthToNull();
    emit(state.copyWith(status: AuthStatus.initial));
  }
}
