import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/logs.dart';
import 'app_resume_listener_mixin.dart';
import 'banner_ads_manager.dart';
import 'retry_policy_mixin.dart';

class BannerAdsManagerImpl extends BannerAdsManager<BannerAd>
    with RetryPolicyMixin, AppResumeListenerMixin {
  static const int _maxFailedLoadAttempts = 3;
  int _numBannerLoadAttempts = 0;

  BannerAd? _bannerAd;

  BannerAdsManagerImpl({required super.isPro}) {
    if (!isPro) {
      initAppResumeListener();

      _createBannerAd();
    }
  }

  @override
  BannerAd? get bannerAd => _bannerAd;

  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2217402774042534/4056700357';
    } else if (Platform.isIOS) {
      //TODO add iOS ad ID
      return '<Your_IOS_BANNER_AD_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  void dispose() {
    cancelScheduledRetry();
    disposeAppResumeListener();
    super.dispose();
    _bannerAd?.dispose();
  }

  void _createBannerAd() {
    try {
      BannerAd(
        adUnitId: _bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            logs.writeLog(' Banner loaded :${ad.responseInfo?.responseId}');
            _bannerAd = ad as BannerAd;
            _numBannerLoadAttempts = 0;
            resetRetryPolicy();

            notifyListeners();
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            logs.writeLog('BannerAd failed to load: $error.');
            _numBannerLoadAttempts += 1;

            ad.dispose();
            _bannerAd?.dispose();
            _bannerAd = null;
            if (_numBannerLoadAttempts < _maxFailedLoadAttempts) {
              _createBannerAd();
            } else {
              _startBackoffRetry();
            }
          },
          onAdOpened: (Ad ad) {},
          onAdClosed: (Ad ad) {},
          onAdWillDismissScreen: (Ad ad) {},
          onAdImpression: (Ad ad) {},
          onAdClicked: (Ad ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
      ).load();
    } catch (error, _) {
      _bannerAd = null;
      _startBackoffRetry();
    }
  }

  @override
  Duration get retryCooldown => const Duration(seconds: 30);
  @override
  void Function() get onAppResumed => _handleAppResumed;

  void _handleAppResumed() {
    _reloadIfUnavailable(reason: 'app_resumed');
  }

  void _reloadIfUnavailable({
    String reason = 'automatic',
  }) {
    if (bannerAd != null) {
      return;
    }

    _reloadInternal(
      reason: reason,
      ignoreCooldown: false,
    );
  }

  void _reloadInternal({
    required String reason,
    required bool ignoreCooldown,
  }) {
    // Skip retry if it is on cooldown
    final onCooldown = isRetryOnCooldown(
      logName: 'BannerAdsManager',
      reason: reason,
    );

    if (!ignoreCooldown && onCooldown) {
      return;
    }

    logs.writeLog('BannerAdsManager reload, reason: $reason');

    markRetryStarted();
    cancelScheduledRetry();

    _createBannerAd();
  }

  void _startBackoffRetry() => scheduleRetry(
        logName: 'BannerAdsManager',
        action: () => _reloadIfUnavailable(reason: 'backoff'),
      );
}
