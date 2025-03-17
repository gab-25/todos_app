import 'package:todos_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  Future<void> onLogin() async {
    emit(state.copyWith(status: LoginStatus.loading));
    bool result = await _authRepository.signIn(email: state.email, password: state.password);
    if (result) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
