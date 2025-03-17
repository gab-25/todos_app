import 'package:todos_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository)
      : super(ProfileState(
          email: _authRepository.currentUser!.email,
          name: _authRepository.currentUser!.name,
          avatar: _authRepository.currentUser!.avatar,
        ));

  final AuthRepository _authRepository;

  String? _editNameCtrl;
  String? _editAvatarCtrl;
  String? _newPasswordCtrl;

  void onEditNameChanged(String name) {
    _editNameCtrl = name;
  }

  void onEditAvatarChanged(String avatar) {
    _editAvatarCtrl = avatar;
  }

  void onNewPasswordChanged(String value) {
    _newPasswordCtrl = value;
  }

  Future<void> onSaveEditProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await _authRepository.updateUser(_authRepository.currentUser!.copyWith(
        name: _editNameCtrl,
        avatar: _editAvatarCtrl,
      ));
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: _authRepository.currentUser!.name,
        avatar: _authRepository.currentUser!.avatar,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error));
    }
  }

  Future<void> onSaveChangePassword() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await _authRepository.updateUser(_authRepository.currentUser!.copyWith(
        password: _newPasswordCtrl,
      ));
      emit(state.copyWith(status: ProfileStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error));
    }
  }
}
