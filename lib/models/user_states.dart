class UserStates {
  UserStates({required this.shellyCloudConnected});

  final bool shellyCloudConnected;

  factory UserStates.fromJson(Map<dynamic, dynamic> json) {
    return UserStates(
      shellyCloudConnected: json['shelly_cloud_connected'] ?? false,
    );
  }
}
