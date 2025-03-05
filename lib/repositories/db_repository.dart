import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DbRepository {
  DbRepository()
      : _firestore = FirebaseFirestore.instance,
        _database = FirebaseDatabase.instance;

  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;
}
