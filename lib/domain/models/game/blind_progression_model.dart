import 'package:freezed_annotation/freezed_annotation.dart';

import '../lobby/lobby_state_model.dart';
import 'blind_level_model.dart';

part 'blind_progression_model.freezed.dart';

@freezed
abstract class BlindProgressionModel with _$BlindProgressionModel {
  const factory BlindProgressionModel({
    required BlindProgressionType progressionType,
    required int? progressionInterval,
    required BlindLevelModel blinds,
  }) = SimpleBlindProgressionModel;

  const factory BlindProgressionModel.pro({
    required BlindProgressionType progressionType,
    required int? progressionInterval,
    required List<BlindLevelModel> levels,
  }) = ProBlindProgressionModel;

  static const BlindProgressionModel defaultModel = BlindProgressionModel(
    progressionType: BlindProgressionType.manual,
    progressionInterval: null,
    blinds: BlindLevelModel(smallBlind: defaultSmallBlindValue),
  );
}

extension BlindProgressionModelX on BlindProgressionModel {
  List<BlindLevelModel> get levels => map(
        (e) => [e.blinds],
        pro: (e) => e.levels.isNotEmpty
            ? e.levels
            : [BlindLevelModel(smallBlind: defaultSmallBlindValue)],
      );
}
