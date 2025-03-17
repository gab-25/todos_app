import 'package:todos_app/models/user.dart';
import 'package:todos_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._authRepository) : super(const AppState()) {
    on<AppLoginPressed>(_onLoginPressed);
    on<AppLogoutPressed>(_onLogoutPressed);
    on<AppUserUpdated>(_onAppUserUpdated);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginPressed(AppLoginPressed event, Emitter<AppState> emit) async {
    final result = await _authRepository.signIn(
      email: event.email,
      password: event.password,
    );
    if (result) {
      emit(state.copyWith(
        user: _authRepository.currentUser,
        status: AppStatus.authenticated,
      ));
    } else {
      emit(state.copyWith(status: AppStatus.unauthenticated));
    }
  }

  void _onLogoutPressed(AppLogoutPressed event, Emitter<AppState> emit) async {
    await _authRepository.signOut();
    emit(state.copyWith(
      user: null,
      status: AppStatus.unauthenticated,
    ));
  }

  void _onAppUserUpdated(AppUserUpdated event, Emitter<AppState> emit) {
    emit(state.copyWith(user: _authRepository.currentUser));
  }
}
