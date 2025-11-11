import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
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
  Map<String, int>? banks,
  int? defaultBank,
  GameStatusEnum? gameState,
}) =>
    LobbyStateModel(
      players: players,
      gameState: gameState ?? GameStatusEnum.notStarted,
      dealerId: dealerId ?? players.first.uid,
      smallBlindValue: smallBlindValue,
      banks: banks ??
          Map.fromEntries(
            players.map((p) => MapEntry(p.uid, defaultBank ?? 1000)),
          ),
    );
