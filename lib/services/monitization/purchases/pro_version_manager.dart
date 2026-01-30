import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/pro_version_model.dart';
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
  List<String> get kIds => [Constants.pocketChipsPROItemKey];

  @override
  bool isConsumable(String productId) => true;

  bool proConfirmedByRestore = false;
  Timer? _restoreTimer;

  @override
  FutureOr<ProVersionModel> build() async {
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
    } on Exception catch (e) {
      toastManager.showToast(e.toString());

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
    restorePurchases();

    await Future.delayed(const Duration(seconds: 2));

    if (state.value?.isPurchased == true) {
      return;
    }

    final product = state.value?.availableProduct;

    if (product == null) {
      throw Exception('Product not found to buy');
    }

    return buyProduct(product.productDetails);
  }

  /// Receive a purchase update and apply the purchase to the app logic.
  @override
  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Validating the purchase
      var validPurchase = await verifyPurchase(purchaseDetails);

      if (validPurchase) {
        // Applying the purchase
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

        logs.writeLog('Pro version purchased/restored');
      } else {
        //TODO Handle invalid purchase
      }
    }

    // Confirm that the purchase has been processed correctly.
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }
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
}
