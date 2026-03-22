import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_lead_item.freezed.dart';

@freezed
abstract class DonationLeadItem with _$DonationLeadItem {
  const factory DonationLeadItem.videoAd() = _DonationLeadItemVideoAd;

  const factory DonationLeadItem.pro() = _DonationLeadItemPro;

  const factory DonationLeadItem.chips({
    required int chipsValue,
  }) = _DonationLeadItemChips;

  const factory DonationLeadItem.loading() = _DonationLeadItemLoading;
}
