import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../app/navigation/navigation_manager.dart';
import '../app/navigation/route_information_parser.dart';
import '../app/navigation/router_delegate.dart';
import '../data/storage/secure_storage/secure_storage.dart';
import '../data/storage/shared_preferences/shared_preferences_storage.dart';
import '../domain/models/pro_version/pro_version_model.dart';
import '../domain/models/purchases/purchasable_product.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localization.dart';
import '../services/analytics_service.dart';
import '../services/crash_reporting_service.dart';
import '../services/event_push_service/handlers/ads_handler.dart';
import '../services/event_push_service/handlers/donation_handler.dart';
import '../services/event_push_service/promotion_service.dart';
import '../services/initialization_manager.dart';
import '../services/monitization/purchases/pro_version_manager.dart';
import '../services/monitization/purchases/purchases_manager.dart';
import '../services/monitization/video_ads/banner_ads_manager.dart';
import '../services/monitization/video_ads/banner_ads_manager_impl.dart';
import '../services/monitization/video_ads/models/iterstitial_ad_state.dart';
import '../services/monitization/video_ads/video_ads_manager.dart';
import '../services/monitization/video_ads/video_ads_manager_impl.dart';
import '../services/toast_manager.dart';
import '../utils/firebase_flags.dart';
import '../utils/theme/theme_manager.dart';
import 'model_holders.dart';

final initializationManagerProvider = Provider<InitializationManager>(
  (ref) => InitializationManager(
    configModelHolder: ref.read(configModelHolderProvider.notifier),
    navigationManager: ref.read(navigationManagerProvider),
    proVersionManager: ref.read(proVersionManagerProvider.notifier),
    remoteConfigLinksHolder: ref.read(remoteConfigLinksHolderProvider.notifier),
    crashReportingService: ref.read(crashReportingServiceProvider),
  ),
);

final crashReportingServiceProvider = Provider<CrashReportingService>(
  (_) => CrashReportingService(),
);

final analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => AnalyticsService(),
);

final currentTimeProvider = Provider<DateTime Function()>(
  (_) => () => DateTime.now().toUtc(),
);

final firebaseAnalyticsObserverProvider = Provider<FirebaseAnalyticsObserver>(
  (ref) => FirebaseAnalyticsObserver(
    analytics: ref.read(analyticsServiceProvider).analytics,
  ),
);

final localStorageProvider = Provider<SharedPreferencesStorage>(
  (ref) => SharedPreferencesStorage(),
);

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(),
);

final navigationKeyProvider = Provider(
  (ref) => GlobalKey<NavigatorState>(debugLabel: 'rootNavigationKey'),
);

final navigationManagerProvider = Provider<NavigationManager>(
  (ref) => NavigationManager(
    navigatorKey: ref.read(navigationKeyProvider),
  ),
);

final routeDelegateProvider = Provider<AppRouterDelegate>(
  (ref) => AppRouterDelegate(
    navigationManager: ref.read(navigationManagerProvider),
    navigatorKey: ref.read(navigationKeyProvider),
    observers: [
      if (kEnableFirebase) ref.read(firebaseAnalyticsObserverProvider),
    ],
  ),
);

final routeInformationParserProvider = Provider<AppRouteInformationParser>(
  (_) => AppRouteInformationParser(),
);

final localeManagerProvider = NotifierProvider<LocaleManager, Locale>(
  LocaleManager.new,
);

final stringsProvider = Provider<AppLocalizations>(
  (ref) {
    final locale = ref.watch(localeManagerProvider);

    return lookupAppLocalizations(locale);
  },
);

final toastManagerProvider = Provider(
  (ref) => ToastManager(),
);

final themeManagerProvider = NotifierProvider<ThemeManager, ThemeMode>(
  ThemeManager.new,
);

final purchasesManagerProvider = AsyncNotifierProvider.autoDispose<
    PurchasesManager, List<PurchasableProduct>>(
  PurchasesManager.new,
);

final proVersionManagerProvider =
    AsyncNotifierProvider<ProVersionManager, ProVersionModel>(
  ProVersionManager.new,
);

final proVersionProvider = Provider<bool>(
  (ref) =>
      ref.watch(proVersionOfferModelHolderProvider).value?.isPurchased ?? false,
);

final videoAdsManagerProvider =
    NotifierProvider<VideoAdsManager, IterstitialAdState>(
  VideoAdsManagerImpl.new,
);

final bannerAdsManagerProvider = Provider<BannerAdsManager<BannerAd>>(
  (ref) => BannerAdsManagerImpl(
    isPro: ref.watch(proVersionProvider),
  ),
);

final currentBannerProvider = StreamProvider.autoDispose<BannerAd?>((ref) {
  final manager = ref.watch(bannerAdsManagerProvider);
  final controller = StreamController<BannerAd?>();

  void listener() => controller.add(manager.bannerAd);

  manager.addListener(listener);
  controller.add(manager.bannerAd);

  ref.onDispose(() {
    manager.removeListener(listener);
    controller.close();
  });

  return controller.stream;
});

final promotionManagerProvider = Provider<PromotionManager>(
  (ref) => PromotionManager(
    handlers: [
      ref.read(donationHandlerProvider),
      ref.watch(adsHandler),
    ],
  ),
);

final donationHandlerProvider = Provider<DonationHandler>(
  (ref) => DonationHandler(
    navigationManager: ref.read(navigationManagerProvider),
  ),
);

final adsHandler = Provider<AdvertisementHandler>(
  (ref) => AdvertisementHandler(
    videoAdsManager: ref.read(videoAdsManagerProvider.notifier),
    isPro: ref.watch(proVersionProvider),
  ),
);
