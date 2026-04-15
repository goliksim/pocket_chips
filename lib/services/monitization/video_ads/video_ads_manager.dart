import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/iterstitial_ad_state.dart';

abstract class VideoAdsManager extends Notifier<IterstitialAdState> {
  bool get isReady;

  void reloadIfUnavailable({required String reason}) {}

  Future<void> showInterstitialAd({VoidCallback? onAdDismissed});
}
