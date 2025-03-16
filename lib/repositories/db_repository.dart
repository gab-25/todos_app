import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_monitor_app/models/user_settings.dart';

class DbRepository {
  DbRepository()
      : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<UserSettings?> getSettings(String userId) async {
    final userSettings = await _firestore.collection('settings').doc(userId).get();
    if (!userSettings.exists) {
      return null;
    }
    return UserSettings.fromJson(userSettings.data()!);
  }

  Future<void> saveSettings(UserSettings settings, String userId) async {
    final userSettings = _firestore.collection('settings').doc(userId);
    await userSettings.set(settings.toJson());
  }

  Future<void> saveShellyCloudResponseToken(Map<String, dynamic> responseToken, String userId) async {
    final userSettings = _firestore.collection('settings').doc(userId);
    await userSettings.set({'shelly_cloud': responseToken}, SetOptions(merge: true));
    print('Shelly Cloud response token saved');
  }
}
