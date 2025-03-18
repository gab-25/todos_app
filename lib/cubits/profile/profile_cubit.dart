import 'package:todos_app/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository)
      : super(ProfileState(
          email: _userRepository.currentUserAuth!.email,
          name: _userRepository.currentUserAuth!.name,
          avatar: _userRepository.currentUserAuth!.avatar,
        ));

  final UserRepository _userRepository;

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
      await _userRepository.updateUser(_userRepository.currentUserAuth!.copyWith(
        name: _editNameCtrl,
        avatar: _editAvatarCtrl,
      ));
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: _editNameCtrl,
        avatar: _editAvatarCtrl,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error));
    }
  }

  Future<void> onSaveChangePassword() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await _userRepository.updateUser(_userRepository.currentUserAuth!.copyWith(
        password: _newPasswordCtrl,
      ));
      emit(state.copyWith(status: ProfileStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error));
    }
  }
}
