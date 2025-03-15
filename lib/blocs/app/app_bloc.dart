import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._authRepository) : super(const AppState()) {
    on<AppStatusChanged>(_onAppStatusChanged);
    on<AppLogoutPressed>(_onLogoutPressed);
    on<AppUserUpdated>(_onAppUserUpdated);
  }

  final AuthRepository _authRepository;

  Future<void> _onAppStatusChanged(AppStatusChanged event, Emitter<AppState> emit) {
    return emit.onEach(
      _authRepository.user,
      onData: (user) async {
        if (user != null) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          print('FirebaseMessaging token: $fcmToken');
          if (kReleaseMode) {
            await FirebaseFirestore.instance
                .collection('settings')
                .doc(user.uid)
                .set({'fcm_token': fcmToken}, SetOptions(merge: true));
          }
        }
        emit(state.copyWith(user: user, status: user != null ? AppStatus.authenticated : AppStatus.unauthenticated));
      },
      onError: addError,
    );
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
