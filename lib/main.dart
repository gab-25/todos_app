import 'package:energy_monitor_app/repositories/auth_repository.dart';
import 'package:energy_monitor_app/ui/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  print('Firebase Messaging token: ${await FirebaseMessaging.instance.getToken()}');

  final AuthRepository authRepository = AuthRepository();

  runApp(App(authRepository: authRepository));
}
