import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_level_model.freezed.dart';

enum AnteType {
  none,
  traditional,
  bigBlindAnte,
}

enum BlindProgressionType {
  manual,
  everyNHands,
  everyNMinutes,
}

@freezed
abstract class BlindLevelModel with _$BlindLevelModel {
  const factory BlindLevelModel({
    required int smallBlind,
    @Default(AnteType.none) AnteType anteType,
    @Default(0) int anteValue,
  }) = _BlindLevelModel;
}
