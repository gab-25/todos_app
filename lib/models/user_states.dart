class UserStates {
  UserStates({required this.shellyCloudConnected, this.power = 0});

  final bool shellyCloudConnected;
  final double power;

  factory UserStates.fromJson(Map<dynamic, dynamic> json) {
    return UserStates(
      shellyCloudConnected: json['shelly_cloud_connected'] ?? false,
      power: json['power'] ?? 0.0,
    );
  }
}
