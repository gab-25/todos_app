import 'package:todos_app/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/repositories/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._userRepository) : super(const AppState()) {
    on<AppUserAuthChanged>(_onAppUserAuthChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onAppUserAuthChanged(AppUserAuthChanged event, Emitter<AppState> emit) {
    return emit.onEach(_userRepository.userAuth, onData: (user) {
      print('User: $user');
      if (user != null) {
        emit(state.copyWith(user: user, status: AppStatus.authenticated));
      } else {
        emit(state.copyWith(user: null, status: AppStatus.unauthenticated));
      }
    }, onError: (e, s) {
      print(e);
      emit(state.copyWith(user: null, status: AppStatus.unauthenticated));
    });
  }
}
