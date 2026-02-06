import 'package:freezed_annotation/freezed_annotation.dart';

import 'donation_item_action.dart';
import 'donation_lead_item.dart';

part 'purchase_item_state.freezed.dart';

@freezed
abstract class PurchaseItemState with _$PurchaseItemState {
  const factory PurchaseItemState({
    required DonationLeadItem lead,
    required String id,
    required String name,
    required String priceText,
    required DonationItemAction action,
    @Default(false) bool alreadyPurchased,
  }) = LoadedPurchaseItemState;

  const factory PurchaseItemState.loading({
    @Default(DonationLeadItem.loading()) DonationLeadItem lead,
    String? id,
  }) = _PurchaseItemLoadingState;

  const PurchaseItemState._();

  bool get alreadyPurchased => map(
        (data) => data.alreadyPurchased,
        loading: (_) => false,
      );

  bool get isLoaded => map(
        (data) => true,
        loading: (_) => false,
      );
}
