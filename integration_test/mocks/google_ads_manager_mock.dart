import 'package:pocket_chips/services/monitization/video_ads/google_ads_manager.dart';
import 'package:pocket_chips/services/monitization/video_ads/models/iterstitial_ad_state.dart';

enum MockScenario {
  success,
  offline,
  error,
}

class MockGoogleAdsManager extends GoogleAdsManager {
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
  void reload() {
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
}
