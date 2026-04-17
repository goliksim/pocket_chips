import 'package:freezed_annotation/freezed_annotation.dart';

import 'possible_winner_item.dart';

part 'winner_choice_args.freezed.dart';

@freezed
abstract class WinnerChoiceArgs with _$WinnerChoiceArgs {
  const factory WinnerChoiceArgs({
    required bool isSidePot,
    required int potValue,
    required List<PossibleWinnerItem> possibleWinners,
    int? anteValue,
    int? foldedValue,
  }) = _WinnerChoiceArgs;
}
