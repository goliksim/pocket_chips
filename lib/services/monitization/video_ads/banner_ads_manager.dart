import 'package:flutter/material.dart';

abstract class BannerAdsManager<T> with ChangeNotifier {
  T? _bannerAd;
  bool isPro;

  T? get bannerAd => _bannerAd;

  BannerAdsManager({required this.isPro});
}
