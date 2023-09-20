
// ignore_for_file: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:flutter/material.dart';

import '../data/storage.dart';
import '../ui/ui_widgets.dart';

Map<String, bool> placements = {
    UnityAdManager.interstitialVideoAdPlacementId: true,
    UnityAdManager.rewardedVideoAdPlacementId: true,
};

class UnityAdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'some_key';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'some_key';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    return 'Start_Page';
  }

  static String get interstitialVideoAdPlacementId {
    return 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return 'Rewarded_Android';
  }
}

Future<void> unityInit(callback) async{
      await UnityAds.init(
      gameId: UnityAdManager.gameId,
      onComplete: () async {
        logs.writeLog('UnityAds: Initialization Complete');
        await loadAds(callback);
        
      },
      onFailed: (error, message) => logs.writeLog('UnityAds: Initialization Failed: $error $message'));
}

  Future<void> loadAds(callback) async{
    for (var placementId in placements.keys) {
      await _loadAd(placementId, callback);
      
    }
  }

  Future<void> _loadAd(String placementId, callback) async {
    await UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        logs.writeLog('UnityAds: Load Complete $placementId');
        
        placements[placementId] = true;
        callback(true);
      },
      onFailed: (placementId, error, message) {
        callback(false);
        logs.writeLog('Load Failed $placementId: $error $message');
      } 
    );
  }

  void showAd(String placementId, callback) {
      placements[placementId] = false;
    UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (placementId) {
        logs.writeLog('UnityAds: Video Ad $placementId completed');
        showToast('toast.thanks'.tr());
        _loadAd(placementId, callback);
      },
      onFailed: (placementId, error, message) {
        logs.writeLog('UnityAds: Video Ad $placementId failed: $error $message');
        _loadAd(placementId, callback);
      },
      onStart: (placementId) => logs.writeLog('UnityAds: Video Ad $placementId started'),
      onClick: (placementId) => logs.writeLog('UnityAds: Video Ad $placementId click'),
      onSkipped: (placementId) {
        logs.writeLog('UnityAds: Video Ad $placementId skipped');
        _loadAd(placementId, callback);
      },
    );
  }

Widget unityBanner() => UnityBannerAd(
              placementId: UnityAdManager.bannerAdPlacementId,
              onLoad: (placementId) => logs.writeLog('UnityAds: Banner loaded: $placementId'),
              onClick: (placementId) => logs.writeLog('UnityAds: Banner clicked: $placementId'),
              onFailed: (placementId, error, message) =>
                  logs.writeLog('UnityAds: Banner Ad $placementId failed: $error $message'),
            );