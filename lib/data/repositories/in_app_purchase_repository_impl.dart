import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as iap;

import '../../../domain/repositories/in_app_purchase_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';

class InAppPurchaseRepositoryImpl implements InAppPurchaseRepository {
  late StreamSubscription<List<iap.PurchaseDetails>> _subscription;
  StreamController<List<iap.PurchaseDetails>>? _purchaseStreamController;

  /// Cache for storing pending purchases from the stream
  /// Key: purchaseId, Value: iap.PurchaseDetails
  final Map<String, iap.PurchaseDetails> _pendingPurchasesToComplete = {};

  static const _logName = 'InAppPurchaseRepository';

  @override
  Future<bool> isStoreAvailable() async {
    if (kIsWeb) return false;

    try {
      logs.writeLog('$_logName: check store availability');
      final bool available = await iap.InAppPurchase.instance.isAvailable();
      logs.writeLog('$_logName: store available = $available');
      return available;
    } on PlatformException catch (e) {
      logs.writeLog('$_logName: store availability error: $e');
      return false;
    }
  }

  @override
  Future<List<String>> getProductIds() async =>
      Constants.inAppProductsKeys.toList();

  @override
  Future<Set<iap.ProductDetails>> getProductDetails(
    List<String> productIds,
  ) async {
    try {
      logs.writeLog('$_logName: fetching product details for $productIds');

      final available = await isStoreAvailable();
      if (!available) {
        throw Exception('Store not available');
      }

      final productDetailsList =
          await iap.InAppPurchase.instance.queryProductDetails(
        productIds.toSet(),
      );

      logs.writeLog(
        '$_logName: fetched ${productDetailsList.productDetails.length} products',
      );

      return productDetailsList.productDetails.toSet();
    } catch (e) {
      logs.writeLog('$_logName: fetch product details error: $e');
      return {};
    }
  }

  @override
  Future<bool> buyProduct(String productId) async {
    try {
      logs.writeLog('$_logName: buying product $productId');

      final available = await isStoreAvailable();
      if (!available) {
        throw Exception('Store not available');
      }

      // Получить деталь товара
      final productDetails = await getProductDetails([productId]);

      if (productDetails.isEmpty) {
        throw Exception('Product not found');
      }

      final product = productDetails.first;

      if (isConsumable(productId)) {
        await iap.InAppPurchase.instance.buyConsumable(
          purchaseParam: iap.PurchaseParam(productDetails: product),
        );
      } else {
        await iap.InAppPurchase.instance.buyNonConsumable(
          purchaseParam: iap.PurchaseParam(productDetails: product),
        );
      }

      return true;
    } catch (e) {
      logs.writeLog('$_logName: buy product error: $e');
      return false;
    }
  }

  @override
  Stream<List<iap.PurchaseDetails>> watchPurchases() {
    if (kIsWeb) return Stream<List<iap.PurchaseDetails>>.empty();

    if (_purchaseStreamController != null) {
      return _purchaseStreamController!.stream;
    }

    _purchaseStreamController =
        StreamController<List<iap.PurchaseDetails>>.broadcast();

    final purchaseUpdated = iap.InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _onStreamDone,
      onError: _onStreamError,
    );

    return _purchaseStreamController!.stream;
  }

  Future<void> _onPurchaseUpdate(
    List<iap.PurchaseDetails> purchaseDetailsList,
  ) async {
    // Store purchases in cache for later completion
    for (final purchase in purchaseDetailsList) {
      if (purchase.pendingCompletePurchase && purchase.purchaseID != null) {
        _pendingPurchasesToComplete[purchase.purchaseID!] = purchase;
      }
    }
    _purchaseStreamController?.add(purchaseDetailsList);
  }

  void _onStreamDone() {
    logs.writeLog('$_logName: purchase stream done');
  }

  void _onStreamError(dynamic error) {
    logs.writeLog('$_logName: purchase stream error: $error');
    _purchaseStreamController?.addError(error);
  }

  @override
  Future<void> completePurchase(String purchaseId) async {
    try {
      logs.writeLog('$_logName: completing purchase $purchaseId');

      final purchaseDetails = _pendingPurchasesToComplete[purchaseId];
      if (purchaseDetails == null) {
        logs.writeLog('$_logName: purchase not found in cache for $purchaseId');
        return;
      }

      await iap.InAppPurchase.instance.completePurchase(purchaseDetails);
      _pendingPurchasesToComplete.remove(purchaseId);

      logs.writeLog('$_logName: purchase completed');
    } catch (e) {
      logs.writeLog('$_logName: complete purchase error: $e');
    }
  }

  @override
  Future<void> restorePurchases() async {
    try {
      logs.writeLog('$_logName: restoring purchases');

      final available = await isStoreAvailable();
      if (!available) {
        throw Exception('Store not available');
      }

      await iap.InAppPurchase.instance.restorePurchases();
      logs.writeLog('$_logName: purchases restored');
    } on Exception catch (e) {
      logs.writeLog('$_logName: restore purchases error: $e');
      rethrow;
    }
  }

  @override
  bool isConsumable(String productId) =>
      Constants.inAppConsumableProductsKeys.contains(productId);

  /// Clear resources
  void dispose() {
    _subscription.cancel();
    _purchaseStreamController?.close();
  }
}
