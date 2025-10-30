import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_editing_state.freezed.dart';

@freezed
abstract class PlayerEditingState with _$PlayerEditingState {
  const factory PlayerEditingState({
    required String assetUrl,
    required bool makeDealer,
    required String? nameInput,
    required int bankInput,
  }) = _PlayerEditingState;
}
