import 'dart:convert';

import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/repositories/db_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

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

  String? _editNameCtrl;
  String? _editAvatarCtrl;

  String? _shellyCloudEmailCtrl;
  String? _shellyCloudPasswordCtrl;

  Future<void> _init() async {
    final userSettings = await _dbRepository.getSettings(_authRepository.currentUser!.uid);
    emit(state.copyWith(shellyCloudConnected: userSettings!['shelly_cloud'] != null));
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
      final http.Response responseAuthorization =
          await http.post(Uri.parse('https://api.shelly.cloud/oauth/login'), body: {
        'email': _shellyCloudEmailCtrl,
        'password': sha1.convert(utf8.encode(_shellyCloudPasswordCtrl!)).toString(),
        'client_id': 'shelly-diy',
      });
      final Map<String, dynamic> jsonResponseAuthorization = json.decode(responseAuthorization.body);
      if (jsonResponseAuthorization['isok'] == false) {
        throw Exception(jsonResponseAuthorization['errors']);
      }
      final String authorizationCode = jsonResponseAuthorization['data']['code'];
      final Map<String, dynamic> userData =
          json.decode(utf8.decode(base64.decode(base64.normalize(authorizationCode.split('.')[1]))));
      final http.Response responseToken = await http.post(Uri.parse("${userData['user_api_url']}/oauth/auth"), body: {
        'client_id': 'shelly-diy',
        'grant_type': 'code',
        'code': authorizationCode,
      });
      final Map<String, dynamic> jsonResponseToken = json.decode(responseToken.body);
      if (jsonResponseToken['isok'] == false) {
        throw Exception(jsonResponseToken['errors']);
      }
      print('Shelly Cloud sign in success');
      await _dbRepository.saveShellyCloudResponseToken(jsonResponseToken, _authRepository.currentUser!.uid);
      emit(state.copyWith(status: ProfileStatus.success, shellyCloudConnected: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.error, shellyCloudConnected: false));
    }
  }
}
