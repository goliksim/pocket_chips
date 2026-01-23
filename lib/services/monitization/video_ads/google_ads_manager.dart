import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/logs.dart';

class GoogleAdsManager with ChangeNotifier {
  static const int _maxFailedLoadAttempts = 3;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  //RewardedAd? _rewardedAd;
  //final int _numRewardedLoadAttempts = 0;

  GoogleAdsManager() {
    _createInterstitialAd();
    //_createRewardedAd();
  }

  bool get loaded => _interstitialAd != null;

  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2217402774042534/4615570149';
    } else if (Platform.isIOS) {
      return '<Your_IOS_Interstitial_AD_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    //_rewardedAd?.dispose();
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
    _interstitialAd!.show();
    _interstitialAd = null;
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
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);

          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          logs.writeLog('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            _createInterstitialAd();
          }

          notifyListeners();
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
