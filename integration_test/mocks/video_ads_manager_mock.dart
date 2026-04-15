import 'dart:ui';

import 'package:pocket_chips/services/monitization/video_ads/models/iterstitial_ad_state.dart';
import 'package:pocket_chips/services/monitization/video_ads/video_ads_manager.dart';

enum MockScenario {
  success,
  offline,
  error,
}

class MockGoogleAdsManager extends VideoAdsManager {
  MockScenario _scenario = MockScenario.success;
  final Duration _loadingTime;

  MockGoogleAdsManager({
    Duration loadingTime = Duration.zero,
  }) : _loadingTime = loadingTime;

  @override
  IterstitialAdState build() {
    Future.delayed(_loadingTime).then(
      (_) {
        switch (_scenario) {
          case MockScenario.success:
            state = IterstitialAdState.ready;
            break;
          case MockScenario.error:
            state = IterstitialAdState.error;
            break;
          case MockScenario.offline:
            state = IterstitialAdState.unavailable;
            break;
        }
      },
    );

    return IterstitialAdState.loading;
  }

  @override
  void reloadIfUnavailable({required String reason}) {
    switch (_scenario) {
      case MockScenario.success:
        state = IterstitialAdState.ready;
        break;
      case MockScenario.error:
        state = IterstitialAdState.error;
        break;
      case MockScenario.offline:
        state = IterstitialAdState.unavailable;
        break;
    }
  }

  void setScenario(MockScenario scenario) {
    _scenario = scenario;
  }

  @override
  // Not showing in test
  bool get isReady => false;

  @override
  // Not showing in test
  Future<void> showInterstitialAd({VoidCallback? onAdDismissed}) async {}
}
