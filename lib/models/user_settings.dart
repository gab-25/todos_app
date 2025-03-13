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

class PowerSettings {
  PowerSettings({this.maxValue, this.limitValue});

  final double? maxValue;
  final double? limitValue;

  factory PowerSettings.fromJson(Map<String, dynamic> json) {
    return PowerSettings(
      maxValue: (json['max_value'] as num?)?.toDouble(),
      limitValue: (json['limit_value'] as num?)?.toDouble(),
    );
  }
}

class UserSettings {
  UserSettings({this.shellyCloud, this.power});

  ShellyCloudSettings? shellyCloud;
  PowerSettings? power;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      shellyCloud: json['shelly_cloud'] != null ? ShellyCloudSettings.fromJson(json['shelly_cloud']) : null,
      power: json['power'] != null ? PowerSettings.fromJson(json['power']) : null,
    );
  }
}
