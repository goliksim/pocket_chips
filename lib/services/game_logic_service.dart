import 'package:collection/collection.dart';

import '../domain/models/game/game_state_model.dart';
import '../domain/models/lobby/lobby_state_model.dart';
import '../domain/models/player/player_id.dart';
import '../domain/models/player/player_model.dart';
import '../presentation/game/widgets/winner_page/view_state/possible_winner_item.dart';

extension GameStateModelX on GameStateModel {
  Iterable<PlayerModel> get activePlayers => lobbyState.players
      .whereNot((e) => sessionState.foldedOrInactive.contains(e.uid));

  bool get canStartOrContinueGame => activePlayers.length >= 2;

  List<PossibleWinnerItem> get possibleWinners => activePlayers
      .map(
        (p) => PossibleWinnerItem(
          uid: p.uid,
          assetUrl: p.assetUrl,
          name: p.name,
          bid: sessionState.bets[p.uid] ?? 0,
        ),
      )
      .toList();

  int get currentPlayerIndex => lobbyState.players
      .indexWhere((p) => p.uid == sessionState.currentPlayerUid);

  int get activePlayersWithMoneyCount =>
      activePlayers.where((p) => (lobbyState.banks[p.uid] ?? 0) > 0).length;

  bool isPlayerActive(PlayerId playerUid) =>
      !sessionState.foldedOrInactive.contains(playerUid);

  bool checkBidsEqual() {
    int notZeroPlayers = 0;

    var maxBet = sessionState.bets.values.maxOrNull ?? 0;

    for (var player in activePlayers) {
      final bid = sessionState.bets[player.uid] ?? 0;
      final bank = lobbyState.banks[player.uid] ?? 0;

      bool equalBool = (bid == maxBet);
      bool allInBool = ((bid > 0) && (bank <= 0));

      if (bank > 0) {
        notZeroPlayers += 1;
      }

      if (!(equalBool || allInBool)) {
        return false;
      }
    }

    //проверка на 1 оставшегося чела
    if (notZeroPlayers <= 1) {
      return true;
    }

    return sessionState.lapCounter != 0;
  }

  // Подсчет величины рейза-ререйза
  int calculateRaiseValue(String currentPlayerUid) {
    // Сколько нужно добавить для выравнивания
    int toEqual = sessionState.bets.values.maxOrNull ??
        0 - (sessionState.bets[currentPlayerUid] ?? 0);

    // Подходит под ставку или ход в олл ин, если остался условно 1 бакс (бет)
    List<int> bids = activePlayers
        .map((p) => sessionState.bets[p.uid] ?? 0)
        .toSet()
        .toList()
      ..sort();

    // Последнее повышение
    int lastRaise = 0;
    if (bids.length > 1) {
      lastRaise = bids[bids.length - 1] - bids[bids.length - 2];
    }

    int result = toEqual + [lastRaise, lobbyState.bigBlindValue].max;

    return result;
  }

  int calculateCallValue(String currentPlayerUid) {
    final maxBet = sessionState.bets.values.maxOrNull ?? 0;
    final currentBet = sessionState.bets[currentPlayerUid] ?? 0;

    return maxBet - currentBet;
  }
}
