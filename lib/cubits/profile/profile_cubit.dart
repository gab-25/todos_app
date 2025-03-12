import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:energy_monitor_app/services/shelly_cloud_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository, this._dbRepository)
      : super(ProfileState(
          email: _authRepository.currentUser!.email!,
          name: _authRepository.currentUser!.displayName ?? '',
          avatar: _authRepository.currentUser!.photoURL ?? '',
        )) {
    _init();
  }

  final AuthRepository _authRepository;
  final DbRepository _dbRepository;
  final ShellyCloudService _shellyCloudService = const ShellyCloudService();

  String? _editNameCtrl;
  String? _editAvatarCtrl;

  String? _shellyCloudEmailCtrl;
  String? _shellyCloudPasswordCtrl;

  void _init() async {
    final userStates = await _dbRepository.getCurrentStates(_authRepository.currentUser!.uid);
    emit(state.copyWith(shellyCloudConnected: userStates?.shellyCloudConnected ?? false));
  }

  void onEditNameChanged(String name) {
    _editNameCtrl = name;
  }

  void onEditAvatarChanged(String avatar) {
    _editAvatarCtrl = avatar;
  }

  void onShellyCloudEmailChanged(String email) {
    _shellyCloudEmailCtrl = email;
  }

  void onShellyCloudPasswordChanged(String password) {
    _shellyCloudPasswordCtrl = password;
  }

  Future<void> onSave() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    await _authRepository.currentUser!.updateDisplayName(_editNameCtrl);
    // await _authRepository.currentUser!.updatePhotoURL(_editAvatarCtrl);
    emit(state.copyWith(
      status: ProfileStatus.success,
      name: _authRepository.currentUser!.displayName!,
      // avatar: _authRepository.currentUser!.photoURL!,
    ));
  }

  Future<void> onShellyCloudSignIn() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final jsonResponseToken = await _shellyCloudService.getAccessToken(_shellyCloudEmailCtrl!, _shellyCloudPasswordCtrl!);
      print('Shelly Cloud sign in success');
      await _dbRepository.saveShellyCloudResponseToken(jsonResponseToken, _authRepository.currentUser!.uid);
      emit(state.copyWith(status: ProfileStatus.success, shellyCloudConnected: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error, shellyCloudConnected: false));
    }
  }
}
