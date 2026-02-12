import '../../domain/models/purchases/purchasable_product.dart';
import '../../domain/models/purchases/purchase_details.dart';
import '../../domain/repositories/in_app_purchase_repository.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../../utils/constants.dart';
import '../builders/purchases_builder.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  final InAppPurchaseRepository _inAppPurchaseRepository;

  PurchasesRepositoryImpl({
    required InAppPurchaseRepository inAppPurchaseRepository,
  }) : _inAppPurchaseRepository = inAppPurchaseRepository;

  @override
  Future<void> buyProduct(String productId) async {
    await _inAppPurchaseRepository.buyProduct(productId);
  }

  @override
  Future<List<PurchasableProduct>> getProducts() async {
    final productIds = await _inAppPurchaseRepository.getProductIds();
    final productDetails =
        await _inAppPurchaseRepository.getProductDetails(productIds);

    return productDetails
        .map(PurchasesModelBuilder.convertProductDetails)
        .toList();
  }

  @override
  Stream<List<PurchaseDetails>> watchPurchaseUpdates() =>
      _inAppPurchaseRepository.watchPurchases().map(
            (purchases) => purchases
                .map(PurchasesModelBuilder.toDomainPurchaseDetails)
                .where((e) => e.productID != Constants.pocketChipsPROItemKey)
                .toList(),
          );

  @override
  Future<void> completePurchase(String purchaseId) async {
    await _inAppPurchaseRepository.completePurchase(purchaseId);
  }

  @override
  Future<void> restorePurchases() =>
      _inAppPurchaseRepository.restorePurchases();

  @override
  // TODO verify with backend
  // https://github.com/flutter/codelabs/blob/main/in_app_purchases/complete/app/lib/logic/dash_purchases.dart#L116
  Future<bool> verifyPurchase(String purchaseId) async => true;
}
