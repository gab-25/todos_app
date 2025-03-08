import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository)
      : super(ProfileState(
          email: _authRepository.currentUser!.email!,
          name: _authRepository.currentUser!.displayName ?? '',
          avatar: _authRepository.currentUser!.photoURL ?? '',
        ));

  final AuthRepository _authRepository;

  final TextEditingController editNameCtrl = TextEditingController();
  final TextEditingController editAvatarCtrl = TextEditingController();

  void onEditNameChanged(String name) {
    editNameCtrl.text = name;
  }

  void onEditAvatarChanged(String avatar) {
    editAvatarCtrl.text = avatar;
  }

  Future<void> onSave() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    await _authRepository.currentUser!.updateDisplayName(editNameCtrl.text);
    // await _authRepository.currentUser!.updatePhotoURL(editAvatarCtrl.text);
    emit(state.copyWith(
      status: ProfileStatus.success,
      name: _authRepository.currentUser!.displayName!,
      // avatar: _authRepository.currentUser!.photoURL!,
    ));
  }
}
