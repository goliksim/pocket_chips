import 'package:freezed_annotation/freezed_annotation.dart';

import '../game/blind_level_model.dart';
import '../game/blind_progression_model.dart';
import '../game/game_state_enum.dart';
import '../player/player_model.dart';
import 'lobby_game_settings_model.dart';

part 'lobby_state_model.freezed.dart';

const int defaultSmallBlindValue = 25;
const int defaultLobbyBank = 5000;

const int maxPlayerCount = 10;
const int noProPlayerCount = 5;

@freezed
abstract class LobbyStateModel with _$LobbyStateModel {
  const factory LobbyStateModel({
    required List<PlayerModel> players,
    required Map<String, int> banks,
    @Default(LobbyGameSettingsModel.defaultModel)
    LobbyGameSettingsModel settings,
    @Default(GameStatusEnum.notStarted) GameStatusEnum gameState,
    @Default(defaultLobbyBank) int defaultBank,
    String? dealerId,
  }) = _LobbyStateModel;

  factory LobbyStateModel.empty() => LobbyStateModel(
        players: [],
        banks: {},
      );
}

extension LobbyStateModelX on LobbyStateModel {
  Iterable<BlindLevelModel> get _progressionLevels =>
      settings.progression.levels;

  int get minRecommendedStartingStack {
    final firstLevel = _progressionLevels.firstOrNull;
    if (firstLevel == null) {
      return 0;
    }

    return firstLevel.minRecommendedStartingStack;
  }
}
