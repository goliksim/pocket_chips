import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../domain/model_holders/game_state_machine.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/lobby/lobby_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../view_state/game_page_view_state.dart';
import '../view_state/game_player_item.dart';
import '../view_state/game_table_state.dart';

class GamePageViewModel with ChangeNotifier {
  final GameStateMachine _gameStateMachine;
  final NavigationManager _navigationManager;
  final AppLocalizations _strings;

  late GamePageViewState viewState;

  GamePageViewModel({
    required GameStateMachine gameStateMachine,
    required NavigationManager navigationManager,
    required AppLocalizations strings,
  })  : _gameStateMachine = gameStateMachine,
        _navigationManager = navigationManager,
        _strings = strings {
    _init();
  }

  void _init() {
    final gameModel = _gameStateMachine.stateModel;
    final gameState = gameModel.lobbyState.gameState;
    final players = gameModel.lobbyState.players;

    final int dealerIndex =
        players.indexWhere((p) => p.uid == gameModel.lobbyState.dealerId);

    final int tableRotationOffset = players.length ~/ 2 - dealerIndex;
    //changeOffset();

    changeGameStateText(gameState);

    // Если Вдруг крашнулось на выборе, тогда снова выведем окно
    Future.delayed(const Duration(milliseconds: 200), () {
      if (gameState == GameStatusEnum.showdown) {
        _gameStateMachine.showWinnersAndEndLap();
      }
    });

    viewState = GamePageViewState(
      tableState: GameTableState(
        players: players
            .map((p) => GamePlayerItem(
                  uid: p.uid,
                  name: p.name,
                  assetUrl: p.assetUrl,
                  isDealer: p.uid == gameModel.lobbyState.dealerId,
                  isCurrent: p.uid == gameModel.sessionState.currentPlayerUid,
                  isFolded:
                      gameModel.sessionState.foldedOrInactive.contains(p.uid),
                ))
            .toList(),
        tableRotationOffset: tableRotationOffset,
        smallBlindValue: gameModel.lobbyState.smallBlindValue,
      ),
      gameStatus: gameState,
      currentGameState: getGameStateName(
        strings: _strings,
        state: gameState,
      ),
      canEditPlayer: gameState.canEditPlayers,
    );
  }

  // Крутим стол
  void mixPlayersPosition() {
    var tableRotationOffset = viewState.tableState.tableRotationOffset;

    tableRotationOffset =
        (tableRotationOffset.abs() + 1) % viewState.tableState.players.length;

    viewState = viewState.copyWith(
      tableState: viewState.tableState.copyWith(
        tableRotationOffset: tableRotationOffset,
      ),
    );

    notifyListeners();
  }

  // Меняем отступы у игроков
  void changeOffset() {
    Random rnd = Random();

    List<double> arr = [];
    for (int p = 0; p < maxPlayerCount; p++) {
      arr.add((rnd.nextInt(40) - 20) / 360 * 2 * pi);
    }
    arr[0] = 0.0;

    viewState = viewState.copyWith(
      tableState: viewState.tableState.copyWith(
        tablePlayersOffsets: arr,
      ),
    );

    notifyListeners();
  }

  // Временное изменение текста
  void changeGameStateText(GameStatusEnum enumValue) async {
    viewState = viewState.copyWith(
      currentGameState: getGameStateName(
        strings: _strings,
        state: enumValue,
      ),
    );

    notifyListeners();
  }

  Future<void> openPlayerEditor(String? playerUid) =>
      _navigationManager.showPlayerEditor(playerUid);

  Future<void> showSavedPlayers() => _navigationManager.showSavedPlayers();
}
