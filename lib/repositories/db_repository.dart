import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_monitor_app/models/user_settings.dart';
import 'package:energy_monitor_app/models/user_states.dart';
import 'package:firebase_database/firebase_database.dart';

class DbRepository {
  DbRepository()
      : _firestore = FirebaseFirestore.instance,
        _database = FirebaseDatabase.instance;

  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;

  Future<UserSettings?> getSettings(String userId) async {
    final userSettings = await _firestore.collection('settings').doc(userId).get();
    if (!userSettings.exists) {
      return null;
    }
    return UserSettings.fromJson(userSettings.data()!);
  }

  Future<UserStates?> getStates(String userId) async {
    final userStates = await _database.ref().child('states/$userId').get();
    if (!userStates.exists) {
      return null;
    }
    return UserStates.fromJson(userStates.value as Map<String, dynamic>);
  }

  Future<void> saveShellyCloudResponseToken(Map<String, dynamic> responseToken, String userId) async {
    final userSettings = _firestore.collection('settings').doc(userId);
    await userSettings.set({'shelly_cloud': responseToken}, SetOptions(merge: true));
    print('Shelly Cloud response token saved');
    final userActions = _database.ref().child('actions/$userId');
    await userActions.set({'type': 'connect_shelly_cloud'});
    print('Shelly Cloud send action connect_shelly_cloud');
  }
}
