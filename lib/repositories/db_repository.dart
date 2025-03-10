import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DbRepository {
  DbRepository()
      : _firestore = FirebaseFirestore.instance,
        _database = FirebaseDatabase.instance;

  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;

  Future<Map<String, dynamic>?> getSettings(String userId) async {
    final userSettings = await _firestore.collection('settings').doc(userId).get();
    return userSettings.data();
  }

  Future<void> saveShellyCloudResponseToken(Map<String, dynamic> responseToken, String userId) async {
    final userSettings = _firestore.collection('settings').doc(userId);
    await userSettings.set({'shelly_cloud': responseToken}, SetOptions(merge: true));
    print('Shelly Cloud response token saved');
  }
}
