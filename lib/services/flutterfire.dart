import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter101/services/crashlytics_service.dart';

bootstrapeFlutterFire() async {
  await Firebase.initializeApp();
  final Crashlytics _crashlytics = Crashlytics(FirebaseCrashlytics.instance);
  await _crashlytics.toggleCrashlytics(false);
}
