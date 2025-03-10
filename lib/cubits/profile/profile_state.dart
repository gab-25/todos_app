part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    required this.email,
    required this.name,
    required this.avatar,
    this.status = ProfileStatus.initial,
    this.shellyCloudConnected = false,
  });

  final String email;
  final String name;
  final String avatar;
  final ProfileStatus status;

  final bool shellyCloudConnected;

  @override
  List<Object?> get props => [name, avatar, status];

  ProfileState copyWith({
    String? email,
    String? name,
    String? avatar,
    ProfileStatus? status,
    bool? shellyCloudConnected,
  }) {
    return ProfileState(
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      shellyCloudConnected: shellyCloudConnected ?? this.shellyCloudConnected,
    );
  }
}
