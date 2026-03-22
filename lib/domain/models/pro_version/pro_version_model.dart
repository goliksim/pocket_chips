import 'package:freezed_annotation/freezed_annotation.dart';

import '../purchases/purchasable_product.dart';

part 'pro_version_model.freezed.dart';

@freezed
abstract class ProVersionModel with _$ProVersionModel {
  const factory ProVersionModel({
    @Default(false) bool forceDisable,
    @Default(false) isPurchased,
    PurchasableProduct? availableProduct,
  }) = _ProVersionModel;
}
