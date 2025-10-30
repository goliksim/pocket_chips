import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_control_result.freezed.dart';

@freezed
abstract class GameControlResult with _$GameControlResult {
  const factory GameControlResult.raise({
    required int raiseValue,
  }) = GameControlRaiseResult;

  const factory GameControlResult.allIn() = _GameControlAllInResult;

  const factory GameControlResult.call() = _GameControlCallResult;

  const factory GameControlResult.check() = _GameControlCheckResult;

  const factory GameControlResult.fold() = _GameControlFoldResult;
}
