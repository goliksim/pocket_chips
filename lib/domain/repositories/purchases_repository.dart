import '../models/purchases/purchasable_product.dart';
import '../models/purchases/purchase_details.dart';

abstract class PurchasesRepository {
  /// Load available products for purchase
  Future<List<PurchasableProduct>> getProducts();

  /// Buy product
  Future<void> buyProduct(String id);

  /// Listen to real-time shopping updates
  /// Returns a stream with details of each purchase
  Stream<List<PurchaseDetails>> watchPurchaseUpdates();

  /// Complete your purchase after it has been processed
  Future<void> completePurchase(String purchaseId);

  /// Restore previous purchases
  Future<void> restorePurchases();

  /// Check the validity of the purchase
  Future<bool> verifyPurchase(String purchaseId);
}
