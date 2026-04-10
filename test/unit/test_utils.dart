import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_game_settings_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/services/assets_provider.dart';

List<PlayerModel> createPlayers(int count) => List.generate(
      count,
      (i) => PlayerModel(
        uid: 'p${i + 1}',
        name: 'Player ${i + 1}',
        assetUrl: AssetsProvider.emptyPlayerAsset,
      ),
    );

// Helper function to create a default lobby state
LobbyStateModel createLobbyState(
  List<PlayerModel> players, {
  String? dealerId,
  int smallBlindValue = 10,
  AnteType anteType = AnteType.none,
  int? anteValue,
  bool allowCustomBets = false,
  Map<String, int>? banks,
  int? defaultBank,
  GameStatusEnum? gameState,
}) =>
    LobbyStateModel(
      players: players,
      gameState: gameState ?? GameStatusEnum.notStarted,
      dealerId: dealerId ?? players.first.uid,
      settings: LobbyGameSettingsModel(
        progression: BlindProgressionModel(
          progressionType: BlindProgressionType.manual,
          progressionInterval: null,
          blinds: BlindLevelModel(
            smallBlind: smallBlindValue,
            anteType: anteType,
            anteValue: anteValue,
          ),
        ),
      ),
      banks: banks ??
          Map.fromEntries(
            players.map((p) => MapEntry(p.uid, defaultBank ?? 1000)),
          ),
    );
