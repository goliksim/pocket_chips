import 'package:in_app_purchase/in_app_purchase.dart';

///Encapsulates all interactions with the InAppPurchase package.
abstract class InAppPurchaseRepository {
  /// Check app store availability
  Future<bool> isStoreAvailable();

  /// Get a list of available product IDs
  Future<List<String>> getProductIds();

  /// Get product details for the specified product IDs
  /// Returns a set of ProductDetails for each product ID
  Future<Set<ProductDetails>> getProductDetails(List<String> productIds);

  /// Buy a product by ID
  /// Returns true if the purchase has started, false if an error occurs.
  Future<bool> buyProduct(String productId);

  /// Listen to shopping updates
  /// Returns a stream with details of each purchase
  Stream<List<PurchaseDetails>> watchPurchases();

  /// Complete your purchase by product ID (after it has been processed)
  /// The purchase details are cached internally from the purchase stream
  Future<void> completePurchase(String purchaseId);

  /// Restore previous purchases
  Future<void> restorePurchases();

  /// Check whether a product is consumable
  bool isConsumable(String productId);
}
