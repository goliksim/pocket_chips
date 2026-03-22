import 'package:freezed_annotation/freezed_annotation.dart';

part 'possible_winner_item.freezed.dart';

@freezed
abstract class PossibleWinnerItem with _$PossibleWinnerItem {
  const factory PossibleWinnerItem({
    required String uid,
    required String assetUrl,
    required String name,
    required int bid,
  }) = _PossibleWinnerItem;
}
