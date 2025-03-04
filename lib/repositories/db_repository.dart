import 'package:cloud_firestore/cloud_firestore.dart';

class DbRepository {
  DbRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
}
