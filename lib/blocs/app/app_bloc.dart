import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:energy_monitor_app/blocs/app/app_event.dart';
import 'package:energy_monitor_app/blocs/app/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AppState()) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepository _authRepository;

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) {
    return emit.onEach(
      _authRepository.user,
      onData: (user) => emit(AppState(user: user)),
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) {
    _authRepository.signOut();
  }
}
