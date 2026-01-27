import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/purchasable_product.dart';

mixin PurchasesMixin<T> {
  String get logName;

  ToastManager get toastManager;
  AppLocalizations get strings;

  List<String> get kIds;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  FutureOr<void> init() {
    _purchaseListening();
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> handlePurchase(PurchaseDetails purchaseDetails);

  Future<List<PurchasableProduct>> loadPurchases() async {
    try {
      await _checkStoreAccess();

      logs.writeLog('$logName: fetch products');
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(kIds.toSet());
      if (response.notFoundIDs.isNotEmpty) {
        // TODO: Handle the error.
      }

      final products = response.productDetails
          .map((e) => PurchasableProduct(e))
          .toList()
        ..sortBy<num>((e) => kIds.indexOf(e.id));
      logs.writeLog('$logName: fetched ${products.length} products');

      return products;
    } on Exception catch (e) {
      logs.writeLog(e.toString());
      toastManager.showToast(e.toString());

      return [];
    }
  }

  bool isConsumable(String productId);

  /// Public method of purchasing products
  Future<void> buyProduct(ProductDetails details) async {
    final purchaseParam = PurchaseParam(productDetails: details);
    if (isConsumable(details.id)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> _checkStoreAccess() async {
    try {
      logs.writeLog('$logName: check store access');
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        throw Exception('Store not available');
      }

      logs.writeLog('$logName: store is available');
    } on PlatformException catch (_) {
      throw Exception('Store not available');
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
      await handlePurchase(purchaseDetails);
    }
  }

  Future<void> restorePurchases() async {
    logs.writeLog('$logName: restore purchases');

    await _checkStoreAccess();

    await InAppPurchase.instance.restorePurchases();
  }

  // TODO verify with backend
  // https://github.com/flutter/codelabs/blob/main/in_app_purchases/complete/app/lib/logic/dash_purchases.dart#L116
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async => true;

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    logs.writeLog('Purchase stream error: $error');
    toastManager.showToast(strings.toast_purchases_updating_error);
  }
}
