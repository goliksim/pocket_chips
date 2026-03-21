import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../di/domain_managers.dart';
import '../../../utils/logs.dart';
import '../../analytics_event.dart';
import '../../analytics_service.dart';
import '../../crash_reporting_service.dart';
import 'app_resume_listener_mixin.dart';
import 'models/iterstitial_ad_state.dart';
import 'retry_policy_mixin.dart';

class GoogleAdsManager extends Notifier<IterstitialAdState>
    with RetryPolicyMixin, AppResumeListenerMixin {
  static const int _maxFailedLoadAttempts = 3;

  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;

  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  bool get isReady => state == IterstitialAdState.ready;

  @override
  Duration get retryCooldown => const Duration(seconds: 30);
  @override
  void Function() get onAppResumed => _handleAppResumed;

  //RewardedAd? _rewardedAd;
  //final int _numRewardedLoadAttempts = 0;

  @override
  IterstitialAdState build() {
    initAppResumeListener();

    ref.onDispose(() {
      cancelScheduledRetry();
      disposeAppResumeListener();
      _interstitialAd?.dispose();
    });

    if (kIsWeb) {
      return IterstitialAdState.unavailable;
    }

    _createInterstitialAd();

    return IterstitialAdState.loading;
  }

  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2217402774042534/4615570149';
    } else if (Platform.isIOS) {
      //TODO add iOS ad ID
      return '<Your_IOS_Interstitial_AD_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void reload() => _reloadInternal(
        reason: 'manual',
        ignoreCooldown: true,
      );

  void reloadIfUnavailable({
    String reason = 'automatic',
  }) {
    if (state != IterstitialAdState.unavailable) {
      return;
    }

    _reloadInternal(
      reason: reason,
      ignoreCooldown: false,
    );
  }

  Future<void> showInterstitialAd({VoidCallback? onAdDismissed}) async {
    final interstitialAd = _interstitialAd;

    if (interstitialAd == null) {
      logs.writeLog('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) async {
        logs.writeLog(
          'InterstitialAd onAdShowedFullScreenContent: ${ad.responseInfo?.responseId}',
        );
        await _analytics.logEvent(AnalyticsEvent.adInterstitialShown);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        logs.writeLog(
          'InterstitialAd onAdDismissedFullScreenContent: ${ad.responseInfo?.responseId}',
        );
        onAdDismissed?.call();

        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        logs.writeLog(
          'InterstitialAd ${ad.responseInfo?.responseId} onAdFailedToShowFullScreenContent: $error',
        );
        unawaited(
          _crashReporting.recordError(
            error: error,
            trace: StackTrace.current,
            reason: 'InterstitialAd onAdFailedToShowFullScreenContent',
          ),
        );
        unawaited(_analytics.logEvent(AnalyticsEvent.adInterstitialFailed));
        ad.dispose();
        _createInterstitialAd();
      },
    );
    interstitialAd.show();

    state = IterstitialAdState.loading;
  }

  void _reloadInternal({
    required String reason,
    required bool ignoreCooldown,
  }) {
    if (kIsWeb) return;
    // Skip reload while ad is loading
    if (state == IterstitialAdState.loading) {
      logs.writeLog('GoogleAdsManager skip reload while ad is loading');
      return;
    }

    // Skip retry if it is on cooldown
    final onCooldown = isRetryOnCooldown(
      logName: 'GoogleAdsManager',
      reason: reason,
    );

    if (!ignoreCooldown && onCooldown) {
      return;
    }

    logs.writeLog('GoogleAdsManager reload, reason: $reason');

    markRetryStarted();
    cancelScheduledRetry();

    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    state = IterstitialAdState.loading;

    try {
      InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            logs.writeLog(
              'InterstitialAd loaded: ${ad.responseInfo?.responseId}',
            );
            resetRetryPolicy();
            _numInterstitialLoadAttempts = 0;
            ad.setImmersiveMode(true);
            _interstitialAd = ad;

            state = IterstitialAdState.ready;
          },
          onAdFailedToLoad: (LoadAdError error) {
            logs.writeLog('InterstitialAd failed to load: $error.');
            unawaited(
              _crashReporting.recordError(
                error: error,
                trace: StackTrace.current,
                reason: 'InterstitialAd failed to load',
              ),
            );
            unawaited(_analytics.logEvent(AnalyticsEvent.adInterstitialFailed));
            _numInterstitialLoadAttempts += 1;

            if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
              _createInterstitialAd();
            } else {
              state = IterstitialAdState.unavailable;
              _startBackoffRetry();
            }
          },
        ),
      );
    } catch (error, trace) {
      state = IterstitialAdState.unavailable;
      _startBackoffRetry();
      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'GoogleAdsManager._createInterstitialAd',
        ),
      );
    }
  }

  void _startBackoffRetry() => scheduleRetry(
        logName: 'GoogleAdsManager',
        action: () => reloadIfUnavailable(reason: 'backoff'),
      );

  void _handleAppResumed() {
    reloadIfUnavailable(reason: 'app_resumed');
  }

  /*void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'TODO',
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          logs.writeLog('$ad loaded.');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          logs.writeLog('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }*/

  /*void _showRewardedAd() {
    if (_rewardedAd == null) {
      logs.writeLog('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          logs.writeLog('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        logs.writeLog('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        logs.writeLog('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        logs.writeLog(
            '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedAd = null;
  }*/
}
