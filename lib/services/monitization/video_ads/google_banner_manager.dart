import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/logs.dart';

class GoogleBannersManager with ChangeNotifier {
  static const int _maxFailedLoadAttempts = 3;
  int _numBannerLoadAttempts = 0;

  BannerAd? _bannerAd;

  GoogleBannersManager({
    required bool isPro,
  }) {
    if (!isPro) {
      _createBannerAd();
    }
  }

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
    super.dispose();
    _bannerAd?.dispose();
  }

  void _createBannerAd() {
    BannerAd(
      adUnitId: _bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          logs.writeLog('Banner loaded :${ad.responseInfo?.responseId}');
          _bannerAd = ad as BannerAd;
          _numBannerLoadAttempts = 0;

          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logs.writeLog('BannerAd failed to load: $error.');
          _numBannerLoadAttempts += 1;
          _bannerAd = null;
          if (_numBannerLoadAttempts < _maxFailedLoadAttempts) {
            _createBannerAd();
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
  }
}
