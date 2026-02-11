import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../di/repositories.dart';
import '../../../domain/models/pro_version/pro_version_model.dart';
import '../../../domain/models/purchases/purchase_details.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../analytics_service.dart';
import '../../crash_reporting_service.dart';
import '../../toast_manager.dart';
import 'purchases_mixin.dart';

class ProVersionManager extends AsyncNotifier<ProVersionModel>
    with PurchasesMixin {
  @override
  String get logName => 'ProVersionManager';

  @override
  ToastManager get toastManager => ref.read(toastManagerProvider);
  @override
  AppLocalizations get strings => ref.read(stringsProvider);
  @override
  // Important to use ProVersionRepository here
  PurchasesRepository get repository => ref.read(proVersionRepositoryProvider);
  @override
  AnalyticsService get analytics => ref.read(analyticsServiceProvider);
  @override
  CrashReportingService get crashReporting =>
      ref.read(crashReportingServiceProvider);

  @override
  List<String> get kIds => [Constants.pocketChipsPROItemKey];

  bool proConfirmedByRestore = false;
  Timer? _restoreTimer;

  @override
  FutureOr<ProVersionModel> build() async {
    logs.writeLog('ProVersionManager build');

    init();
    ref.onDispose(() {
      dispose();
      _restoreTimer?.cancel();
    });

    final product = (await loadPurchases())
        .firstWhere((p) => p.id == Constants.pocketChipsPROItemKey);

    return ProVersionModel(
      availableProduct: product,
      isPurchased: state.value?.isPurchased ?? false,
      forceDisable: state.value?.forceDisable ?? false,
    );
  }

  @override
  Future<void> restorePurchases() async {
    try {
      await super.restorePurchases();
    } catch (error, trace) {
      logs.writeLog('$logName: ${error.toString()}');
      await crashReporting.recordError(
        error: error,
        trace: trace,
        reason: 'ProVersionManager.restorePurchases',
      );

      return;
    }

    // Waiting for purchases to be restored and turning off the PRO if they haven't confirmed it.
    _restoreTimer = Timer(const Duration(seconds: 5), () {
      if (!proConfirmedByRestore) {
        logs.writeLog('ProVersionManager: force disable');
        // Disable PRO
        state = AsyncData(
          ProVersionModel(
            forceDisable: true,
            isPurchased: false,
            availableProduct: state.value?.availableProduct,
          ),
        );
      }
    });
  }

  Future<void> buyPro() async {
    await super.restorePurchases();

    await Future.delayed(const Duration(seconds: 2));

    if (!ref.mounted || state.value?.isPurchased == true) {
      return;
    }
    final product = state.value?.availableProduct;

    if (product == null) {
      throw Exception('Product not found to buy');
    }

    return buyProduct(product.id);
  }

  @override
  Future<void> applyPurchase(PurchaseDetails purchaseDetails) async {
    //TODO make a dialog and add tests

    proConfirmedByRestore = true;
    // Enable PRO
    state = AsyncData(
      ProVersionModel(
        isPurchased: true,
        forceDisable: false,
        availableProduct: state.value?.availableProduct,
      ),
    );

    await super.applyPurchase(purchaseDetails);
  }

  void debugDisablePro() {
    if (kDebugMode) {
      state = AsyncData(
        ProVersionModel(
          isPurchased: false,
          forceDisable: true,
          availableProduct: state.value?.availableProduct,
        ),
      );
    }
  }

  void debugEnablePro() {
    if (kDebugMode) {
      state = AsyncData(
        ProVersionModel(
          isPurchased: true,
          forceDisable: false,
          availableProduct: state.value?.availableProduct,
        ),
      );
    }
  }
}
