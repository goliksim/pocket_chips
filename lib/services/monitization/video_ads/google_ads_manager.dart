import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/logs.dart';
import 'models/iterstitial_ad_state.dart';

class GoogleAdsManager extends Notifier<IterstitialAdState> {
  static const int _maxFailedLoadAttempts = 3;

  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;

  bool get isReady => state == IterstitialAdState.ready;

  //RewardedAd? _rewardedAd;
  //final int _numRewardedLoadAttempts = 0;

  @override
  IterstitialAdState build() {
    ref.onDispose(() {
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
      return '<Your_IOS_Interstitial_AD_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void reload() {
    if (kIsWeb) return;

    logs.writeLog('GoogleAdsManager reload');

    _createInterstitialAd();
  }

  Future<void> showInterstitialAd({VoidCallback? onAdDismissed}) async {
    if (_interstitialAd == null) {
      logs.writeLog('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => logs.writeLog(
        'InterstitialAd onAdShowedFullScreenContent: ${ad.responseInfo?.responseId}',
      ),
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
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd?.show();

    state = IterstitialAdState.loading;
  }

  void _createInterstitialAd() {
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
          _numInterstitialLoadAttempts += 1;

          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            _createInterstitialAd();
          } else {
            state = IterstitialAdState.unavailable;
          }
        },
      ),
    );
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
