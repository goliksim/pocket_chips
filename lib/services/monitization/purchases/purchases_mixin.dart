import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/purchases/purchasable_product.dart';
import '../../../domain/models/purchases/purchase_details.dart';
import '../../../domain/models/purchases/purchase_status.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/logs.dart';
import '../../analytics_event.dart';
import '../../analytics_service.dart';
import '../../crash_reporting_service.dart';
import '../../toast_manager.dart';

mixin PurchasesMixin<T> on AsyncNotifier<T> {
  String get logName;

  @protected
  ToastManager get toastManager;
  @protected
  AppLocalizations get strings;
  @protected
  PurchasesRepository get repository;
  @protected
  AnalyticsService get analytics;
  @protected
  CrashReportingService get crashReporting;

  @protected
  List<String> get kIds;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  FutureOr<void> init() {
    _purchaseListening();
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> applyPurchase(PurchaseDetails purchaseDetails) async {
    // Confirm that the purchase has been processed correctly.
    if (purchaseDetails.pendingCompletePurchase) {
      await repository.completePurchase(purchaseDetails.productID);
    }
  }

  /// Process purchase update
  /// Called automatically when the purchase status changes.
  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (!ref.mounted) {
      return;
    }

    try {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Validating the purchase
        var validPurchase =
            await repository.verifyPurchase(purchaseDetails.productID);

        if (validPurchase) {
          logs.writeLog('Purchase valid: ${purchaseDetails.productID}');

          await analytics.logEvent(
            purchaseDetails.status == PurchaseStatus.purchased
                ? AnalyticsEvent.purchaseSuccess(purchaseDetails.productID)
                : AnalyticsEvent.purchaseRestored(purchaseDetails.productID),
          );

          // Apply purchase
          await applyPurchase(purchaseDetails);
        } else {
          // Invalid purchase
          await analytics.logEvent(
            AnalyticsEvent.purchaseInvalid(purchaseDetails.productID),
          );
          await crashReporting.recordError(
            error: Exception('Invalid purchase: ${purchaseDetails.productID}'),
            trace: StackTrace.current,
            reason: 'PurchasesManager.handlePurchase.invalid',
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        //TODO make a dialog and add tests
        logs.writeLog('Purchase pending: ${purchaseDetails.productID}');
        toastManager.showToast(
          '${strings.toast_purchase_pending_state_named} ${strings.getProductNameById(purchaseDetails.productID)}...',
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        logs.writeLog('Error purchase: ${purchaseDetails.productID}');
        toastManager.showToast(
          '${strings.toast_purchase_error_named} ${strings.getProductNameById(purchaseDetails.productID)}.',
        );
        await analytics.logEvent(
          AnalyticsEvent.purchaseInvalid(purchaseDetails.productID),
        );
        await crashReporting.recordError(
          error: Exception('Purchase error: ${purchaseDetails.productID}'),
          trace: StackTrace.current,
          reason: 'PurchasesManager.handlePurchase.error',
        );
      }
    } catch (error, trace) {
      await crashReporting.recordError(
        error: error,
        trace: trace,
        reason: 'PurchasesManager.handlePurchase',
      );
    }
  }

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
    await analytics.logEvent(AnalyticsEvent.purchaseRestoreAttempt);

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
