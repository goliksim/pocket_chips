import 'package:freezed_annotation/freezed_annotation.dart';

import 'purchase_status.dart';

part 'purchase_details.freezed.dart';

/// Purchase details (platform independent)
@freezed
abstract class PurchaseDetails with _$PurchaseDetails {
  const factory PurchaseDetails({
    required String productID,
    required PurchaseStatus status,
    required String purchaseId,
    //required int purchaseTime,
    //String? billingClientPayload,
    //PurchaseError? error,
    @Default(false) bool pendingCompletePurchase,
  }) = _PurchaseDetails;
}
