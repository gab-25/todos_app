part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    required this.email,
    required this.name,
    this.avatar,
    this.status = ProfileStatus.initial,
  });

  final String email;
  final String name;
  final String? avatar;
  final ProfileStatus status;

  @override
  List<Object?> get props => [email, name, avatar, status];

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
    );
  }
}
