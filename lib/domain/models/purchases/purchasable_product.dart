import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'purchasable_product.freezed.dart';

@freezed
abstract class PurchasableProduct with _$PurchasableProduct {
  const factory PurchasableProduct({
    required String id,
    required String price,
    required double rawPrice,
    required String currencyCode,
    String? title,
  }) = _PurchasableProduct;
}

extension PurchasableProductX on ProductDetails {
  PurchasableProduct get toDomain => PurchasableProduct(
        id: id,
        price: price,
        rawPrice: rawPrice,
        currencyCode: currencyCode,
        title: title,
      );
}
