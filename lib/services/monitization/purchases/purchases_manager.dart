import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../di/repositories.dart';
import '../../../domain/models/purchases/purchasable_product.dart';
import '../../../domain/models/purchases/purchase_details.dart';
import '../../../domain/models/purchases/purchase_status.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
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
  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (!ref.mounted) {
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Validating the purchase
      var validPurchase =
          await repository.verifyPurchase(purchaseDetails.productID);

      if (validPurchase) {
        // Applying the purchase
        //TODO make a dialog and add tests
        logs.writeLog('Purchase valid: ${purchaseDetails.productID}');
        toastManager.showToast(
          '${strings.toast_purchase_success_named} ${strings.getProductNameById(purchaseDetails.productID)}!',
        );
      } else {
        //TODO Handle invalid purchase
      }
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      //TODO make a dialog and add tests
      logs.writeLog('Purchase pending: ${purchaseDetails.productID}');
      toastManager.showToast(
        '${strings.toast_purchase_pending_state_named} ${strings.getProductNameById(purchaseDetails.productID)}...',
      );
    }

    if (purchaseDetails.status == PurchaseStatus.error) {
      logs.writeLog('Error purchase: ${purchaseDetails.productID}');
      toastManager.showToast(
        '${strings.toast_purchase_error_named} ${strings.getProductNameById(purchaseDetails.productID)}.',
      );
    }

    if (purchaseDetails.productID == Constants.pocketChipsPROItemKey) {
      return;
    }

    // Confirm that the purchase has been processed correctly.
    if (purchaseDetails.pendingCompletePurchase) {
      await repository.completePurchase(purchaseDetails.productID);
    }
  }
}
