import 'dart:async';

import 'package:pocket_chips/domain/models/purchases/purchasable_product.dart';
import 'package:pocket_chips/domain/models/purchases/purchase_details.dart';
import 'package:pocket_chips/domain/models/purchases/purchase_status.dart';
import 'package:pocket_chips/domain/repositories/purchases_repository.dart';
import 'package:pocket_chips/utils/constants.dart';

enum MockScenario {
  success,
  offline,
  error,
}

class MockPurchasesRepository implements PurchasesRepository {
  MockScenario _scenario = MockScenario.success;
  final Duration _loadingTime;
  final bool _shouldRestorePurchases;

  final Set<String> _purchasedProducts = {};
  late StreamController<List<PurchaseDetails>> _purchaseController;

  MockPurchasesRepository({
    bool hasPurchasesForRestore = false,
    Duration loadingTime = Duration.zero,
  })  : _shouldRestorePurchases = hasPurchasesForRestore,
        _loadingTime = loadingTime {
    _purchaseController = StreamController<List<PurchaseDetails>>.broadcast();
  }

  /// Set the scenario for this mock (success, offline, error)
  void setScenario(MockScenario scenario) {
    _scenario = scenario;
  }

  /// Check if product is purchased
  bool isPurchased(String productId) => _purchasedProducts.contains(productId);

  /// Clear all purchases
  void clearPurchases() {
    _purchasedProducts.clear();
  }

  @override
  Future<void> buyProduct(String id) async {
    switch (_scenario) {
      case MockScenario.offline:
        throw Exception('No internet connection');
      case MockScenario.error:
        throw Exception('Purchase failed');
      case MockScenario.success:
        _simulatePurchase(id);
        return;
    }
  }

  @override
  Future<void> completePurchase(String purchaseId) async {
    switch (_scenario) {
      case MockScenario.offline:
        throw Exception('No internet connection');
      case MockScenario.error:
        throw Exception('Failed to complete purchase');
      case MockScenario.success:
        // Purchase is already completed in simulatePurchase
        return;
    }
  }

  @override
  Future<List<PurchasableProduct>> getProducts() async {
    switch (_scenario) {
      case MockScenario.offline:
        throw Exception('No internet connection');
      case MockScenario.error:
        throw Exception('Failed to fetch products');
      case MockScenario.success:
        await Future.delayed(_loadingTime);

        return [
          PurchasableProduct(
            id: Constants.pocketChipsPROItemKey,
            price: '\$9.99',
            rawPrice: 9.99,
            currencyCode: 'USD',
            title: 'Pocket Chips PRO',
          ),
          PurchasableProduct(
            id: Constants.inAppConsumableProductsKeys.first,
            price: '\$1.99',
            rawPrice: 1.99,
            currencyCode: 'USD',
            title: 'Donation',
          ),
        ];
    }
  }

  @override
  Future<void> restorePurchases() async {
    switch (_scenario) {
      case MockScenario.offline:
        throw Exception('No internet connection');
      case MockScenario.error:
        throw Exception('Failed to restore purchases');
      case MockScenario.success:
        if (_shouldRestorePurchases) {
          _simulatePurchase(Constants.pocketChipsPROItemKey);
        }
        return;
    }
  }

  @override
  Future<bool> verifyPurchase(String purchaseId) async {
    switch (_scenario) {
      case MockScenario.offline:
        throw Exception('No internet connection');
      case MockScenario.error:
        return false;
      case MockScenario.success:
        return true;
    }
  }

  @override
  Stream<List<PurchaseDetails>> watchPurchaseUpdates() =>
      _purchaseController.stream;

  void dispose() {
    _purchaseController.close();
  }

  /// Simulate a purchase
  void _simulatePurchase(String productId) {
    _purchasedProducts.add(productId);
    _purchaseController.add([
      PurchaseDetails(
        productID: productId,
        status: PurchaseStatus.purchased,
        purchaseId: 'mock_purchase_id_$productId',
        pendingCompletePurchase: true,
      ),
    ]);
  }
}
