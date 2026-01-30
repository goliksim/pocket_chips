import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_version_offer_view_state.freezed.dart';

@freezed
abstract class ProVersionOfferViewState with _$ProVersionOfferViewState {
  const factory ProVersionOfferViewState({
    required bool isAvailable,
    required bool alreadyPurchased,
    String? priceText,
  }) = _ProVersionOfferViewState;
}
