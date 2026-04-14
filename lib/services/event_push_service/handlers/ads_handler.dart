import 'dart:async';

import '../../../utils/logs.dart';
import '../../monitization/video_ads/video_ads_manager.dart';
import 'event_handler.dart';

class AdvertisementHandler implements EventHandler {
  static const _cooldown = Duration(minutes: 5);
  DateTime? _lastShowTime;

  final VideoAdsManager _googleAdsManager;
  final bool _isPro;

  AdvertisementHandler({
    required VideoAdsManager videoAdsManager,
    required bool isPro,
  })  : _googleAdsManager = videoAdsManager,
        _isPro = isPro {
    // The first showing after 1 minutes after first launch
    _lastShowTime = DateTime.now().subtract(Duration(minutes: 4));
  }

  @override
  EventType get type => EventType.advertisement;

  @override
  bool isReady() {
    if (_isPro) {
      // Not showing add for PRO users
      logs.writeLog('AdvertisementHandler is disabled via PRO mode');
      return false;
    }

    if (!_googleAdsManager.isReady) {
      logs.writeLog('AdvertisementHandler: Ads not ready');
      return false;
    }

    final isReady = _lastShowTime == null ||
        DateTime.now().difference(_lastShowTime!) > _cooldown;

    if (isReady) {
      return true;
    }
    final nextShowTime = _lastShowTime!.add(_cooldown);
    final left = nextShowTime.difference(DateTime.now()).inSeconds;

    logs.writeLog('AdvertisementHandler is not ready, $left seconds left');

    return false;
  }

  @override
  Future<void> show() async {
    final completer = Completer<void>();
    _googleAdsManager.showInterstitialAd(onAdDismissed: () {
      completer.complete();
    });
    _lastShowTime = DateTime.now();
    return completer.future;
  }
}
