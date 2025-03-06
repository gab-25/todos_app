part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    required this.name,
    required this.avatar,
    this.status = ProfileStatus.initial,
  });

  final String name;
  final String avatar;
  final ProfileStatus status;

  @override
  List<Object?> get props => [name, avatar, status];

  ProfileState copyWith({
    String? name,
    String? avatar,
    ProfileStatus? status,
  }) {
    return ProfileState(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
    );
  }
}
