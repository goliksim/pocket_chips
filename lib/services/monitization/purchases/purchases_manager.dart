import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/purchasable_product.dart';

class PurchasesManager extends AsyncNotifier<List<PurchasableProduct>> {
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  FutureOr<List<PurchasableProduct>> build() {
    _purchaseListening();
    ref.onDispose(() => _subscription.cancel());

    return _loadPurchases();
  }

  /// Публичный метод покупки товара
  Future<void> buyProduct(String productId) async {
    final product = state.requireValue
        .firstWhereOrNull((element) => element.id == productId);

    if (product == null) {
      throw Exception('Product not found');
    }

    bool isConsumable(String productId) =>
        Constants.inAppConsumableProductsKeys.contains(productId);

    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    if (isConsumable(product.id)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    logs.writeLog('PurcasesManager: restore purchases');

    await InAppPurchase.instance.restorePurchases();
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

  Future<void> _checkStoreAccess() async {
    try {
      logs.writeLog('PurcasesManager: check store access');
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        throw Exception('Store not available');
      }

      logs.writeLog('PurcasesManager: store is available');
    } on PlatformException catch (_) {
      throw Exception('Store not available');
    }
  }

  Future<List<PurchasableProduct>> _loadPurchases() async {
    try {
      await _checkStoreAccess();

      final List<String> kIds = Constants.inAppProductsKeys;
      logs.writeLog('PurcasesManager: fetch products');
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(kIds.toSet());
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }

      final products = response.productDetails
          .map((e) => PurchasableProduct(e))
          .toList()
        ..sortBy<num>((e) => kIds.indexOf(e.id));
      logs.writeLog('PurcasesManager: fetched ${products.length} products');

      return products;
    } on Exception catch (e) {
      logs.writeLog(e.toString());
      _toastManager.showToast(e.toString());

      return [];
    }
  }

  //Listening to purchase updates
  void _purchaseListening() {
    final purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    //iapRepo.addListener(purchasesUpdate);
  }

  //Получаем обновления о покупках
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  //Получаем обновление о покупке, применяет покупку к логике приложения.
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Валидируем покупку
      var validPurchase = await _verifyPurchase(purchaseDetails);

      if (validPurchase) {
        // Применяем покупку
        //TODO сделать модалку и повесить тесты
        logs.writeLog('Purchase valid: ${purchaseDetails.productID}');
        _toastManager.showToast(
          '${_strings.toast_purchase_success_named} ${_strings.getProductNameById(purchaseDetails.productID)}!',
        );
      } else {
        //TODO Handle invalid purchase
      }
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      //TODO сделать модалку и повесить тесты
      logs.writeLog('Purchase pending: ${purchaseDetails.productID}');
      _toastManager.showToast(
        '${_strings.toast_purchase_pending_state_named} ${_strings.getProductNameById(purchaseDetails.productID)}...',
      );
    }

    if (purchaseDetails.status == PurchaseStatus.error) {
      logs.writeLog('Error purchase: ${purchaseDetails.error?.message}');
      _toastManager.showToast(
        '${_strings.toast_purchase_error_named} ${_strings.getProductNameById(purchaseDetails.productID)}.',
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

  // TODO verify with backend
  // https://github.com/flutter/codelabs/blob/main/in_app_purchases/complete/app/lib/logic/dash_purchases.dart#L116
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async => true;

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    logs.writeLog('Purchase stream error: $error');
    _toastManager.showToast(_strings.toast_purchases_updating_error);
  }
}
