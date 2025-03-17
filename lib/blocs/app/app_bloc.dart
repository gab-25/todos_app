import 'package:todos_app/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppUserChanged>(_onAppUserChanged);
  }

  void _onAppUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    if (event.user == null) {
      emit(state.copyWith(user: null, status: AppStatus.unauthenticated));
    } else {
      emit(state.copyWith(user: event.user, status: AppStatus.authenticated));
    }
  }
}
