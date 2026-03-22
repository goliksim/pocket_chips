import 'package:collection/collection.dart';

import '../domain/models/game/game_state_model.dart';
import '../domain/models/lobby/lobby_state_model.dart';
import '../domain/models/player/player_id.dart';
import '../domain/models/player/player_model.dart';

extension GameStateModelX on GameStateModel {
  bool isPlayerActive(PlayerId playerUid) =>
      !sessionState.foldedPlayers.contains(playerUid);

  Iterable<PlayerModel> get activePlayers =>
      lobbyState.players.where((e) => isPlayerActive(e.uid));

  bool get canStartOrContinueGame => activePlayersWithMoney.length >= 2;

  Set<String> get possibleWinnersUids => activePlayers
      .where((p) => (sessionState.bets[p.uid] ?? 0) > 0)
      .map((p) => p.uid)
      .toSet();

  PlayerModel? get currentPlayer =>
      lobbyState.players.findByUid(sessionState.currentPlayerUid);

  bool isPlayerActiveWithMoney(PlayerId playerUid) =>
      isPlayerActive(playerUid) && ((lobbyState.banks[playerUid] ?? 0) > 0);

  Iterable<PlayerModel> get activePlayersWithMoney =>
      lobbyState.players.where((p) => isPlayerActiveWithMoney(p.uid));

  int get activePlayersWithMoneyCount => activePlayersWithMoney.length;
}

extension GameSessionStateX on GameStateModel {
  bool checkBidsEqual() {
    final bets = activePlayers.map((p) => sessionState.bets[p.uid] ?? 0);
    if (bets.isEmpty) return true;

    final maxBet = bets.max;

    for (final player in activePlayers) {
      final bid = sessionState.bets[player.uid] ?? 0;
      final bank = lobbyState.banks[player.uid] ?? 0;

      bool isEqual = (bid == maxBet);
      bool isAllIn = ((bid > 0) && (bank <= 0));

      if (!(isEqual || isAllIn)) {
        return false;
      }
    }

    return true;
  }

  // TODO: add settings (disable over-raising an all-in raise if it is less than the minimum raise)
  // https://www.reddit.com/r/poker/comments/oqrmyk/minimal_raise/?tl=ru

  /// Calculating the raise/reraise amount
  (int, bool) calculateRaiseValue(String currentPlayerUid) {
    // How much should be added for equal bets?
    int toEqual = (sessionState.bets.values.maxOrNull ?? 0) -
        (sessionState.bets[currentPlayerUid] ?? 0);

    // Suitable for a bet or an all-in move if there is still $1 left (bet)
    List<int> bids = activePlayers
        .map((p) => sessionState.bets[p.uid] ?? 0)
        .toSet()
        .toList()
      ..sort();

    // Last raise
    int lastRaise = 0;
    if (bids.length > 1) {
      lastRaise = bids[bids.length - 1] - bids[bids.length - 2];
    }

    int result = toEqual + [lastRaise, lobbyState.bigBlindValue].max;

    final bool raiseIsAllIn =
        result >= (lobbyState.banks[currentPlayerUid] ?? 0);

    return (result, raiseIsAllIn);
  }

  (int, bool) calculateCallValue(String currentPlayerUid) {
    final maxBet =
        [sessionState.bets.values.maxOrNull ?? 0, lobbyState.bigBlindValue].max;
    final currentBet = sessionState.bets[currentPlayerUid] ?? 0;

    final result = maxBet - currentBet;
    final callIsAllIn = (result >= (lobbyState.banks[currentPlayerUid] ?? 0));

    return (result, callIsAllIn);
  }
}
