import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashReportingService {
  Future<void> recordError({
    required Object error,
    required StackTrace trace,
    String? reason,
    bool fatal = false,
  }) async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    await FirebaseCrashlytics.instance.recordError(
      error,
      trace,
      reason: reason,
      fatal: fatal,
    );
  }

  Future<void> log(String message) async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    await FirebaseCrashlytics.instance.log(message);
  }
}
