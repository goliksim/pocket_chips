import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/navigation/navigation_manager.dart';
import '../app/navigation/route_information_parser.dart';
import '../app/navigation/router_delegate.dart';
import '../data/storage/secure_storage/secure_storage.dart';
import '../data/storage/shared_preferences/shared_preferences_storage.dart';
import '../domain/models/pro_version/pro_version_model.dart';
import '../domain/models/purchases/purchasable_product.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localization.dart';
import '../services/event_push_service/handlers/ads_handler.dart';
import '../services/event_push_service/handlers/donation_handler.dart';
import '../services/event_push_service/promotion_service.dart';
import '../services/initialization_manager.dart';
import '../services/monitization/purchases/pro_version_manager.dart';
import '../services/monitization/purchases/purchases_manager.dart';
import '../services/monitization/video_ads/google_ads_manager.dart';
import '../services/monitization/video_ads/models/iterstitial_ad_state.dart';
import '../services/toast_manager.dart';
import '../utils/theme/theme_manager.dart';
import 'model_holders.dart';

final initializationManagerProvider = Provider<InitializationManager>(
  (ref) => InitializationManager(
    configModelHolder: ref.read(configModelHolderProvider.notifier),
    navigationManager: ref.read(navigationManagerProvider),
    proVersionManager: ref.read(proVersionManagerProvider.notifier),
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

final googleAdsManagerProvider =
    NotifierProvider<GoogleAdsManager, IterstitialAdState>(
  GoogleAdsManager.new,
);

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
    googleAdsManager: ref.read(googleAdsManagerProvider.notifier),
    isPro: ref.watch(proVersionProvider),
  ),
);
