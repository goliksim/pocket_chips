import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../di/domain_managers.dart';
import '../../../utils/logs.dart';
import '../../analytics_event.dart';
import '../../analytics_service.dart';
import '../../crash_reporting_service.dart';
import 'models/iterstitial_ad_state.dart';

class GoogleAdsManager extends Notifier<IterstitialAdState> {
  static const int _maxFailedLoadAttempts = 3;

  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;

  bool get isReady => state == IterstitialAdState.ready;
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  //RewardedAd? _rewardedAd;
  //final int _numRewardedLoadAttempts = 0;

  @override
  IterstitialAdState build() {
    ref.onDispose(() {
      _interstitialAd?.dispose();
    });

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

  void reload() {
    logs.writeLog('GoogleAdsManager reload');

    _createInterstitialAd();
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

  void _createInterstitialAd() {
    try {
      InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            logs.writeLog(
              'InterstitialAd loaded: ${ad.responseInfo?.responseId}',
            );
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
            }
          },
        ),
      );
    } catch (error, trace) {
      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'GoogleAdsManager._createInterstitialAd',
        ),
      );
    }
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
