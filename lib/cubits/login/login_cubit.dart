import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/repositories/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._userRepository) : super(const LoginState());

  final UserRepository _userRepository;

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  Future<void> onLogin() async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _userRepository.authUserByEmailAndPassword(state.email, state.password);
    if (result) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> onLogout() async {
    _userRepository.setUserAuthToNull();
    emit(state.copyWith(status: LoginStatus.initial));
  }
}
