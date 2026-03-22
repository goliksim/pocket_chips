import 'package:freezed_annotation/freezed_annotation.dart';

import 'purchase_item_state.dart';

part 'donation_view_state.freezed.dart';

@freezed
abstract class DonationViewState with _$DonationViewState {
  const factory DonationViewState({
    required List<PurchaseItemState> availableItems,
    PurchaseItemState? videoAdItem,
  }) = _DonationViewState;
}
