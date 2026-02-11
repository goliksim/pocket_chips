import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'analytics_event.dart';

class AnalyticsService {
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  Future<void> logEvent(AnalyticsEvent event) async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    await analytics.logEvent(
      name: event.name,
      parameters: event.parameters,
    );
  }
}
