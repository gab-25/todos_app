import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(const ProfileState());

  final AuthRepository _authRepository;

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onAvatarChanged(String avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  Future<void> onSave() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    await _authRepository.currentUser!.updateDisplayName(state.name);
    emit(state.copyWith(status: ProfileStatus.success));
  }
}
