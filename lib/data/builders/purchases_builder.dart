import 'package:in_app_purchase/in_app_purchase.dart' as iap;

import '../../domain/models/purchases/purchasable_product.dart';
import '../../domain/models/purchases/purchase_details.dart' as domain;
import '../../domain/models/purchases/purchase_status.dart' as domain;

abstract class PurchasesModelBuilder {
  /// Convert iap.ProductDetails to PurchasableProduct
  static PurchasableProduct convertProductDetails(iap.ProductDetails product) =>
      PurchasableProduct(
        id: product.id,
        price: product.price,
        rawPrice: product.rawPrice,
        currencyCode: product.currencyCode,
        title: product.title,
      );

  /// Convert iap.PurchaseDetails to domain.PurchaseDetails
  static domain.PurchaseDetails toDomainPurchaseDetails(
    iap.PurchaseDetails original,
  ) =>
      domain.PurchaseDetails(
        productID: original.productID,
        status: _toDomainPurchaseStatus(original.status),
        purchaseId: original.purchaseID ?? 'unknown_id',
        //purchaseTime: original.transactionDate != null ? int.tryParse(original.transactionDate!) ?? 0 : 0,
        //error: original.error != null ? domain.PurchaseError( code: original.error!.code.toString(), message: original.error!.message, ) : null,
        pendingCompletePurchase: original.pendingCompletePurchase,
      );

  /// Convert iap.PurchaseStatus to domain.PurchaseStatus
  static domain.PurchaseStatus _toDomainPurchaseStatus(
    iap.PurchaseStatus status,
  ) =>
      switch (status) {
        iap.PurchaseStatus.purchased => domain.PurchaseStatus.purchased,
        iap.PurchaseStatus.pending => domain.PurchaseStatus.pending,
        iap.PurchaseStatus.error => domain.PurchaseStatus.error,
        iap.PurchaseStatus.restored => domain.PurchaseStatus.restored,
        iap.PurchaseStatus.canceled => domain.PurchaseStatus.canceled,
      };
}
