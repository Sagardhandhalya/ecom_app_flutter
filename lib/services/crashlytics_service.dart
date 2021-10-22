import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Crashlytics {
  final FirebaseCrashlytics _crashlytics;

  toggleCrashlytics(bool status) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(status);
  }

  Crashlytics(this._crashlytics);
}
