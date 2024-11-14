import 'package:firebase_core/firebase_core.dart';
import 'package:proteine_flutter/proteine.dart';
import 'package:dcdg/dcdg.dart';
void main() async {
  await Proteine.start(firebaseOptions: FirebaseOptions(
    apiKey: 'your-api-key',
    appId: 'your-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
  ));
}