import '../../domain/models/game/blind_level_model.dart';
import '../../domain/models/game/blind_progression_model.dart';
import '../../domain/models/lobby/lobby_game_settings_model.dart';
import '../../domain/models/lobby/lobby_state_model.dart';
import '../storage/entities/blind_progression_entity.dart';
import '../storage/entities/lobby_game_settings_entity.dart';
import 'blind_level_builder.dart';

class LobbyGameSettingsEntityBuilder {
  static LobbyGameSettingsModel fromEntity(
    LobbyGameSettingsEntity entity,
  ) {
    final mode = entity.progression.mode;
    final levels = entity.progression.levels
        .map(BlindLevelEntityBuilder.fromEntity)
        .toList();

    final List<BlindLevelModel> levelsFallback = levels.isNotEmpty
        ? levels
        : [
            BlindLevelModel(smallBlind: defaultSmallBlindValue),
          ];

    BlindProgressionModel progression;
    switch (mode) {
      case BlindProgressionMode.simple:
        progression = BlindProgressionModel(
          progressionType: entity.progression.progressionType,
          progressionInterval: entity.progression.progressionInterval,
          blinds: levelsFallback.first,
        );
        break;
      case BlindProgressionMode.pro:
        progression = BlindProgressionModel.pro(
          progressionType: entity.progression.progressionType,
          progressionInterval: entity.progression.progressionInterval,
          levels: levelsFallback.toList(),
        );
        break;
    }

    return LobbyGameSettingsModel(
      allowCustomBets: entity.allowCustomBets,
      sitOutMode: entity.sitOutMode,
      progression: progression,
    );
  }

  static LobbyGameSettingsEntity toEntity(
    LobbyGameSettingsModel model,
  ) =>
      LobbyGameSettingsEntity(
        allowCustomBets: model.allowCustomBets,
        sitOutMode: model.sitOutMode,
        progression: BlindProgressionEntity(
          mode: model.progression.mode,
          progressionType: model.progression.progressionType,
          progressionInterval: model.progression.progressionInterval,
          levels: model.progression.levels
              .map(BlindLevelEntityBuilder.toEntity)
              .toList(),
        ),
      );
}
