import '../../domain/models/purchases/purchasable_product.dart';
import '../../domain/models/purchases/purchase_details.dart';
import '../../domain/repositories/in_app_purchase_repository.dart';
import '../../utils/constants.dart';
import '../builders/purchases_builder.dart';
import 'purchases_repository_impl.dart';

class ProVersionRepository extends PurchasesRepositoryImpl {
  final InAppPurchaseRepository _inAppPurchaseRepository;

  ProVersionRepository({
    required super.inAppPurchaseRepository,
  }) : _inAppPurchaseRepository = inAppPurchaseRepository;

  @override
  Future<List<PurchasableProduct>> getProducts() async {
    final productDetails = await _inAppPurchaseRepository
        .getProductDetails([Constants.pocketChipsPROItemKey]);

    return productDetails
        .map(PurchasesModelBuilder.convertProductDetails)
        .toList();
  }

  @override
  Stream<List<PurchaseDetails>> watchPurchaseUpdates() =>
      _inAppPurchaseRepository.watchPurchases().map(
            (purchases) => purchases
                .map(PurchasesModelBuilder.toDomainPurchaseDetails)
                .where((e) => e.productID == Constants.pocketChipsPROItemKey)
                .toList(),
          );
}
