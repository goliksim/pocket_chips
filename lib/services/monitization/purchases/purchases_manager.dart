import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../di/repositories.dart';
import '../../../domain/models/purchases/purchasable_product.dart';
import '../../../domain/models/purchases/purchase_details.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../analytics_service.dart';
import '../../crash_reporting_service.dart';
import '../../toast_manager.dart';
import 'purchases_mixin.dart';

class PurchasesManager extends AsyncNotifier<List<PurchasableProduct>>
    with PurchasesMixin {
  @override
  String get logName => 'PurchasesManager';

  @override
  ToastManager get toastManager => ref.read(toastManagerProvider);
  @override
  PurchasesRepository get repository => ref.read(purchasesRepositoryProvider);
  @override
  AppLocalizations get strings => ref.read(stringsProvider);
  @override
  AnalyticsService get analytics => ref.read(analyticsServiceProvider);

  @override
  CrashReportingService get crashReporting =>
      ref.read(crashReportingServiceProvider);

  @override
  List<String> get kIds => Constants.inAppProductsKeys.toList();

  @override
  FutureOr<List<PurchasableProduct>> build() {
    init();
    logs.writeLog('PurchasesManager build');
    ref.onDispose(() {
      logs.writeLog('PurchasesManager dispose');
      dispose();
    });

    return loadPurchases();
  }

  @override
  Future<void> applyPurchase(PurchaseDetails purchaseDetails) async {
    //TODO make a dialog and add tests
    toastManager.showToast(
      '${strings.toast_purchase_success_named} ${strings.getProductNameById(purchaseDetails.productID)}!',
    );

    return;
  }
}
