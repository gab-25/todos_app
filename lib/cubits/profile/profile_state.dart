part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    required this.email,
    required this.name,
    this.avatar,
    this.status = ProfileStatus.initial,
    this.shellyCloudConnected = false,
    this.shellyCloudDeviceId,
  });

  final String email;
  final String name;
  final String? avatar;
  final ProfileStatus status;
  final bool shellyCloudConnected;
  final String? shellyCloudDeviceId;

  @override
  List<Object?> get props => [email, name, avatar, status, shellyCloudConnected, shellyCloudDeviceId];

  ProfileState copyWith({
    String? email,
    String? name,
    String? avatar,
    ProfileStatus? status,
    bool? shellyCloudConnected,
    String? shellyCloudDeviceId,
  }) {
    return ProfileState(
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      shellyCloudConnected: shellyCloudConnected ?? this.shellyCloudConnected,
      shellyCloudDeviceId: shellyCloudDeviceId ?? this.shellyCloudDeviceId,
    );
  }
}
