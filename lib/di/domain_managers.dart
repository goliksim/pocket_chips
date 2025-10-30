import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/navigation/navigation_manager.dart';
import '../app/navigation/route_information_parser.dart';
import '../app/navigation/router_delegate.dart';
import '../data/storage/shared_preferences/shared_preferences_storage.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localization.dart';
import '../services/initialization_manager.dart';
import '../services/toast_manager.dart';
import 'model_holders.dart';

final initializationManagerProvider = Provider<InitializationManager>(
  (ref) => InitializationManager(
    configModelHolder: ref.watch(configModelHolderProvider),
    navigationManager: ref.watch(navigationManagerProvider),
  ),
);

final localStorageProvider = Provider<SharedPreferencesStorage>(
  (ref) => SharedPreferencesStorage(),
);

final navigationKeyProvider = Provider(
  (ref) => GlobalKey<NavigatorState>(debugLabel: 'rootNavigationKey'),
);

final navigationManagerProvider = Provider<NavigationManager>(
  (ref) => NavigationManager(
    navigatorKey: ref.watch(navigationKeyProvider),
  ),
);

final routeDelegateProvider = Provider<AppRouterDelegate>(
  (ref) => AppRouterDelegate(
    navigationManager: ref.watch(navigationManagerProvider),
    navigatorKey: ref.watch(navigationKeyProvider),
  ),
);

final routeInformationParserProvider = Provider<AppRouteInformationParser>(
  (_) => AppRouteInformationParser(),
);

final localeManagerProvider = Provider<LocaleManager>(
  (ref) => LocaleManager(
    configModelHolder: ref.watch(configModelHolderProvider),
    addListener: (listener) =>
        ref.listen(configModelHolderProvider, (_, __) => listener()),
  ),
);

final stringsProvider = Provider<AppLocalizations>(
  (ref) {
    final locale = ref.watch(localeManagerProvider).lang;

    return lookupAppLocalizations(locale);
  },
);

final toastManagerProvider = Provider(
  (ref) => ToastManager(),
);
