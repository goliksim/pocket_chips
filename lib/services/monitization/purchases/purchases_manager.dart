import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/purchasable_product.dart';
import 'purchases_mixin.dart';

class PurchasesManager extends AsyncNotifier<List<PurchasableProduct>>
    with PurchasesMixin {
  @override
  String get logName => 'PurchasesManager';

  @override
  ToastManager get toastManager => ref.read(toastManagerProvider);
  @override
  AppLocalizations get strings => ref.read(stringsProvider);

  @override
  List<String> get kIds => Constants.inAppProductsKeys.toList();

  @override
  bool isConsumable(String productId) =>
      Constants.inAppConsumableProductsKeys.contains(productId);

  @override
  FutureOr<List<PurchasableProduct>> build() {
    init();
    ref.onDispose(dispose);

    return loadPurchases();
  }

  @override
  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Валидируем покупку
      var validPurchase = await verifyPurchase(purchaseDetails);

      if (validPurchase) {
        // Применяем покупку
        //TODO сделать модалку и повесить тесты
        logs.writeLog('Purchase valid: ${purchaseDetails.productID}');
        toastManager.showToast(
          '${strings.toast_purchase_success_named} ${strings.getProductNameById(purchaseDetails.productID)}!',
        );
      } else {
        //TODO Handle invalid purchase
      }
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      //TODO сделать модалку и повесить тесты
      logs.writeLog('Purchase pending: ${purchaseDetails.productID}');
      toastManager.showToast(
        '${strings.toast_purchase_pending_state_named} ${strings.getProductNameById(purchaseDetails.productID)}...',
      );
    }

    if (purchaseDetails.status == PurchaseStatus.error) {
      logs.writeLog('Error purchase: ${purchaseDetails.error?.message}');
      toastManager.showToast(
        '${strings.toast_purchase_error_named} ${strings.getProductNameById(purchaseDetails.productID)}.',
      );
    }

    if (purchaseDetails.productID == Constants.pocketChipsPROItemKey) {
      return;
    }

    // Подтверждаем, что покупка обработана правильно.
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }
  }

  Future<void> buyItem(String productId) async {
    final product = state.requireValue
        .firstWhereOrNull((element) => element.id == productId);

    if (product == null) {
      throw Exception('Product not found');
    }

    return super.buyProduct(product.productDetails);
  }

  /// Публичный метод обновления покупок
  /*void purchasesUpdate() {
    var subscriptions = <PurchasableProduct>[];
    var upgrades = <PurchasableProduct>[];
    // Get a list of purchasable products for the subscription and upgrade.
    // This should be 1 per type.
    if (products.isNotEmpty) {
      subscriptions = products
          .where((element) => element.productDetails.id == storeKeySubscription)
          .toList();
      upgrades = products
          .where((element) => element.productDetails.id == storeKeyUpgrade)
          .toList();
    }

    // Set the subscription and show/hide purchased on the purchases page.
    if (iapRepository.hasActiveSubscription) {
      subscriptionManager.applySubscription();
      for (var element in subscriptions) {
        _updateStatus(element, ProductStatus.purchased);
      }
    } else {
      subscriptionManager.removeSubscription();
      for (var element in subscriptions) {
        _updateStatus(element, ProductStatus.purchasable);
      }
    }

    // Set the single buy upgrade and show/hide purchased on the purchases page.
    if (iapRepository.hasUpgrade != _upgrade) {
      _upgrade = iapRepository.hasUpgrade;
      for (var element in upgrades) {
        _updateStatus(
          element,
          _upgrade ? ProductStatus.purchased : ProductStatus.purchasable,
        );
      }
      notifyListeners();
    }
  }

  void _updateStatus(PurchasableProduct product, ProductStatus status) {
    if (product.status != status) {
      product.status = status;
      notifyListeners();
    }
  }*/
}
