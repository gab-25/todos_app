import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ShellyCloudService {
  const ShellyCloudService();

  Future<Map<String, dynamic>> getAccessToken(String email, String password) async {
    final http.Response responseAuthorization =
        await http.post(Uri.parse('https://api.shelly.cloud/oauth/login'), body: {
      'email': email,
      'password': sha1.convert(utf8.encode(password)).toString(),
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
    jsonResponseToken['url'] = userData['user_api_url'];

    return jsonResponseToken;
  }

  Future<Map<String, dynamic>> getStatisticsData(
    String url,
    String accessToken,
    DateTime dateFrom,
    DateTime? dateTo,
  ) async {
    final String dateRange = dateTo == null ? 'day' : 'custom';
    url += "/v2/statistics/power-consumption/overall?date_range=$dateRange&date_from=${Uri.encodeComponent(dateFrom.toIso8601String().replaceFirst('T', ' '))}";
    if (dateTo != null) {
      url += '&date_to=${Uri.encodeComponent(dateTo.toIso8601String().replaceFirst('T', ' '))}';
    }
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['isok'] == false) {
      throw Exception(jsonResponse['errors']);
    }

    return jsonResponse;
  }
}
