import 'package:energy_monitor_app/cubits/login/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  Future<void> onLogin() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      print("User: ${credential.user}");
      if (credential.user != null) {
        emit(state.copyWith(status: LoginStatus.success));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  void onLogout() {
    emit(const LoginState());
  }
}
