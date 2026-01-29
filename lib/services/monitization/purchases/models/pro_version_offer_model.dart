import 'package:freezed_annotation/freezed_annotation.dart';

import 'purchasable_product.dart';

part 'pro_version_offer_model.freezed.dart';

@freezed
abstract class ProVersionOfferModel with _$ProVersionOfferModel {
  const factory ProVersionOfferModel({
    @Default(false) bool isPurchased,
    PurchasableProduct? availableProduct,
  }) = _ProVersionOfferModel;
}
