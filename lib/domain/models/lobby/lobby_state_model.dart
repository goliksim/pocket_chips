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
  BlindLevelModel get currentLevel => settings.progression.map(
        (simple) => simple.blinds,
        pro: (pro) => pro.levels.first, //TODO тут нифига не первый
      );

  int get smallBlindValue => currentLevel.smallBlind;

  int get bigBlindValue => smallBlindValue * 2;

  AnteType get anteType => currentLevel.anteType;

  int? get anteValue => currentLevel.anteValue;
}
