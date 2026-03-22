import 'package:freezed_annotation/freezed_annotation.dart';

import 'possible_winner_item.dart';

part 'winner_choice_args.freezed.dart';

@freezed
abstract class WinnerChoiceArgs with _$WinnerChoiceArgs {
  const factory WinnerChoiceArgs({
    required String title,
    required List<PossibleWinnerItem> possibleWinners,
  }) = _WinnerChoiceArgs;
}
