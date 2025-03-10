class ShellyCloudSettings {
  ShellyCloudSettings({this.accessToken, this.refreshToken, this.tokenType, this.expiresIn});

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  factory ShellyCloudSettings.fromJson(Map<String, dynamic> json) {
    return ShellyCloudSettings(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}

class UserSettings {
  UserSettings({this.shellyCloud});

  ShellyCloudSettings? shellyCloud;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      shellyCloud: json['shelly_cloud'] != null ? ShellyCloudSettings.fromJson(json['shelly_cloud']) : null,
    );
  }
}
