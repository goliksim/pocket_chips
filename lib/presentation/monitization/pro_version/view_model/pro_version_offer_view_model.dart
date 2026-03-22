import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../di/domain_managers.dart';
import '../../../../di/model_holders.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/analytics_event.dart';
import '../../../../services/analytics_service.dart';
import '../../../../services/crash_reporting_service.dart';
import '../../../../services/monitization/purchases/pro_version_manager.dart';
import '../../../../services/toast_manager.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/logs.dart';
import '../view_state/pro_version_offer_view_state.dart';

class ProVersionOfferViewModel extends AsyncNotifier<ProVersionOfferViewState> {
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  ProVersionManager get _proVersionManager =>
      ref.read(proVersionManagerProvider.notifier);

  @override
  FutureOr<ProVersionOfferViewState> build() async {
    logs.writeLog('ProVersionOfferViewModel: build');

    if (state.value == null) {
      Future.microtask(
        () => ref.read(proVersionManagerProvider.notifier).runBuild(),
      );
    }

    final data = await ref.watch(proVersionOfferModelHolderProvider.future);

    return ProVersionOfferViewState(
      isAvailable: data.availableProduct != null,
      alreadyPurchased: data.isPurchased,
      priceText: data.availableProduct?.price,
    );
  }

  Future<void> purchasePro() async {
    try {
      await _analytics.logEvent(
        AnalyticsEvent.purchaseAttempt(Constants.pocketChipsPROItemKey),
      );
      await _proVersionManager.buyPro();
    } catch (error, trace) {
      await _crashReporting.recordError(
        error: error,
        trace: trace,
        reason: 'ProVersionOfferViewModel.purchasePro',
      );
      _toastManager.showToast(_strings.toast_unav);
      logs.writeLog(error.toString());
    }
  }

  void pop() => _navigationManager.pop();
}
