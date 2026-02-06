import 'dart:async';

import 'package:collection/collection.dart';

import '../../../domain/models/purchases/purchasable_product.dart';
import '../../../domain/models/purchases/purchase_details.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';

mixin PurchasesMixin {
  String get logName;

  ToastManager get toastManager;
  AppLocalizations get strings;
  PurchasesRepository get repository;

  List<String> get kIds;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  FutureOr<void> init() {
    _purchaseListening();
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Process purchase update
  /// Called automatically when the purchase status changes.
  Future<void> handlePurchase(PurchaseDetails purchaseDetails);

  /// Load available products for purchase
  Future<List<PurchasableProduct>> loadPurchases() async {
    try {
      logs.writeLog('$logName: fetch products');
      final List<PurchasableProduct> products = await repository.getProducts();

      logs.writeLog('$logName: fetched ${products.length} products');

      return products..sortBy<num>((e) => kIds.indexOf(e.id));
    } on Exception catch (e) {
      logs.writeLog(e.toString());
      toastManager.showToast(e.toString());

      return [];
    }
  }

  /// Buy product
  Future<void> buyProduct(String productId) => repository.buyProduct(productId);

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    logs.writeLog('$logName: restore purchases');
    await repository.restorePurchases();
  }

  /// Listen for purchase updates in real-time
  void _purchaseListening() {
    if (_subscription != null) {
      return;
    }

    final purchaseUpdated = repository.watchPurchaseUpdates();
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
  }

  /// Receive updates about purchases
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await handlePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    logs.writeLog('$logName: stream done');
    _subscription?.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    logs.writeLog('$logName: Purchase stream error: $error');
    toastManager.showToast(strings.toast_purchases_updating_error);
  }
}
