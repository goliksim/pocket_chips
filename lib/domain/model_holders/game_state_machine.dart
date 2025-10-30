//ОСНОВНАЯ ИГРОВАЯ ЛОГИКА
import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigation/navigation_manager.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/game/widgets/winner_page/view_state/possible_winner_item.dart';
import '../../presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';
import '../../services/toast_manager.dart';
import '../../utils/logs.dart';
import '../models/game/game_session_state.dart';
import '../models/game/game_state_enum.dart';
import '../models/game/game_state_model.dart';
import '../models/game_settings_model.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_id.dart';
import '../models/player/player_model.dart';
import '../repositories/app_repository.dart';
import 'game_settings_provider.dart';
import 'lobby_state_holder.dart';

class GameStateMachine extends AsyncNotifier<GameStateModel>
    implements GameSettingsProvider {
  final LobbyStateHolder _lobbyStateHolder;

  final NavigationManager _navigationManager;
  final AppRepository _appRepository;
  final AppLocalizations _strings;
  final ToastManager _toastManager;

  GameStateMachine({
    required NavigationManager navigationManager,
    required LobbyStateHolder lobbyStateHolder,
    required AppRepository appRepository,
    required ToastManager toastManager,
    required AppLocalizations strings,
  })  : _navigationManager = navigationManager,
        _lobbyStateHolder = lobbyStateHolder,
        _appRepository = appRepository,
        _toastManager = toastManager,
        _strings = strings;

  @override
  FutureOr<GameStateModel> build() async {
    final sessionState = await _appRepository.getGameSessionState();

    final lobbyState = _lobbyStateHolder.activeLobby;

    return GameStateModel(
      lobbyState: lobbyState,
      sessionState: sessionState ??
          GameSessionState(
            bets: {},
            foldedOrInactive: {},
            lapCounter: 0,
          ),
    );
  }

  GameStateModel get stateModel => state.value!;
  GameSessionState get sessionState => stateModel.sessionState;
  LobbyStateModel get lobbyState => stateModel.lobbyState;

  String get currentPlayerUid => sessionState.currentPlayerUid ?? 'none-uid';

  List<PossibleWinnerItem> get possibleWinners => stateModel.activePlayers
      .map(
        (p) => PossibleWinnerItem(
            uid: p.uid,
            assetUrl: p.assetUrl,
            name: p.name,
            bid: sessionState.bets[p.uid]!),
      )
      .toList();

  Iterable<PlayerModel> get activePlayers => stateModel.activePlayers;
  bool get canStartOrContinueGame => stateModel.canStartOrContinueGame;

  int get currentPlayerIndex => lobbyState.players
      .indexWhere((p) => p.uid == sessionState.currentPlayerUid);

  int get playersWithMoneyCount =>
      lobbyState.banks.values.where((element) => element > 0).length;

  bool get checkPlayersHaveMoney => playersWithMoneyCount > 0;

  //Player controls
  void executeRaise(int raiseValue) => _bet(raiseValue);
  void executeAllIn() => _betAllIn();
  void executeCall() => _bet(calculateCallValue());
  void executeCheck() => _newPlayer();
  void executeFold() => _fold();

  void startBetting() {
    if (canStartOrContinueGame) {
      logs.writeLog('Start Betting. Lobby is active}');

      _updateLobbyState(
        lobbyState.copyWith(
          gameState: GameStatusEnum.preFlop,
        ),
      );
      _updateSessionState(
        sessionState.copyWith(
          lapCounter: 0,
        ),
      );

      _processFirstBlinds();
      //TODO:
      //lobbyStorage.write(lobbyState);
      _newPlayer(jumpToUid: sessionState.firstPlayerUid);
    } else {
      _toastManager.showToast(_strings.toast_moreplay);
    }
  }

  // Новый круг
  Future showWinnersAndEndLap({bool fromFold = false}) async {
    _updateLobbyState(
      lobbyState.copyWith(
        gameState: GameStatusEnum.showdown,
      ),
    );

    if (!fromFold) {
      logs.writeLog('Call WinnerChooseWindow');

      final markedWinners = await _navigationManager.showWinnerChooseDialog(
        WinnerChoiceArgs(
          title: _strings.game_win3,
          possibleWinners: possibleWinners,
        ),
      );

      _moneyDistribution(markedWinners ?? {});
    } else {
      final winner = activePlayers.first;
      final totalBets = sessionState.bets.values.reduce((a, b) => a + b);
      lobbyState.banks.update(winner.uid, (value) => value + totalBets);

      await _navigationManager.showWinner(winner);
    }

    logs.writeLog('NEW Lap\tlobby state = 5\t lobbyIndex=-1;');

    _resetPlayers();

    _findNewDealer();

    _updateLobbyState(
      lobbyState.copyWith(
        gameState: GameStatusEnum.gameBreak,
      ),
    );
  }

  // Проверка на выравнивание ставок
  bool checkBidsEqual() {
    int notZeroPlayers = 0;

    var maxBet = sessionState.bets.values.reduce(max);

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
  int calculateRaiseValue() {
    // Сколько нужно добавить для выравнивания
    int toEqual = sessionState.bets.values.reduce(max) -
        (sessionState.bets[currentPlayerUid] ?? 0);

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

    int result = toEqual + [lastRaise, lobbyState.bigBlindValue].reduce(max);

    return result;
  }

  int calculateCallValue() {
    final maxBet = sessionState.bets.values.reduce(max);
    final currentBet = sessionState.bets[sessionState.currentPlayerUid] ?? 0;

    return maxBet - currentBet;
  }

  // PRIVATE PART

  void _bet(int bid) {
    _processBet(currentPlayerUid, bid);

    // После выравнивания ставок на всех улицах, кроме префлопа сразу прыгаем на следующую улицу
    if (sessionState.lapCounter > 0 && checkBidsEqual()) {
      _newState();
    } else {
      _newPlayer();
    }
  }

  void _betAllIn() {
    int bid = _calculateMaxBid();

    return _bet(bid);
  }

  void _processBet(String playerUid, int bid, {int? overrideBank}) {
    sessionState.bets.update(
      playerUid,
      (value) => value + bid,
      ifAbsent: () => bid,
    );
    lobbyState.banks
        .update(playerUid, (value) => overrideBank ?? (value - bid));
  }

  Future<void> _fold() async {
    sessionState.foldedOrInactive.add(currentPlayerUid);

    if (canStartOrContinueGame) {
      _newPlayer();
    } else {
      showWinnersAndEndLap(fromFold: true);
    }
  }

  Future<void> _moneyDistribution(Set<String> winners) async {
    // Упорядоченное множество ставок
    List<int> bets = sessionState.bets.values.toSet().toList()..sort();

    if (bets[0] == 0) {
      bets.removeAt(0);
    }

    logs.writeLog('Bids - $bets');

    // Проходимся по каждому разному значению ставок
    for (int bid in bets) {
      if (bid <= 0) continue;

      logs.writeLog('Winners - $winners');

      // Проверка на сайд-спот
      if (winners.isEmpty && canStartOrContinueGame) {
        final newWinners = await _navigationManager.showWinnerChooseDialog(
          WinnerChoiceArgs(
            title: _strings.game_win4,
            possibleWinners: possibleWinners,
          ),
        );

        return _moneyDistribution(newWinners ?? {});
      }

      // Та сумма которая будет распределяться по победителям для данной ставки
      int sumToDivide = 0;

      // Проходимся по ставкам и проверяем, ставил ли кто-то данную ставку
      for (var entry in sessionState.bets.entries) {
        // Если челик такую ставку поставил
        if (entry.value >= bid) {
          // Если не победитель, то вносим ее в общий банк
          if (!winners.contains(entry.key)) {
            sumToDivide += bid;
          } else {
            // Если это победитель, то он свое вернул
            lobbyState.banks.update(entry.key, (value) => value + bid);
          }
        }
      }

      // Заканчиваем цикл если остаток остался, а челиксы закончились
      // Возвращаем деньги тому, кто поставил больше всех бабок
      if (winners.isEmpty) {
        //_pop();
        for (var player in activePlayers) {
          lobbyState.banks.update(player.uid,
              (value) => value + (sessionState.bets[player.uid] ?? 0));
          //lobbyState.players[i].bank +=
          //    (lobbyState.players[i].bid > 0) ? lobbyState.players[i].bid : 0;
        }
        return;
      }

      final winnersCount = winners.length;

      // Разделенная добыча делится на победителей, причем тока тех, кто еще в игре
      logs.writeLog('Devide on $winnersCount');
      for (var winnerUid in winners) {
        if (sessionState.bets[winnerUid]! > 0) {
          lobbyState.banks.update(
              winnerUid, (value) => value + (sumToDivide ~/ winnersCount));

          logs.writeLog(
            'For ${lobbyState.players.firstWhereOrNull((p) => p.uid == winnerUid)?.name} - ${lobbyState.banks[winnerUid]}',
          );
        }
      }

      // Вычитаем отработанную ставку из списка
      for (int m = 0; m < bets.length; m++) {
        bets[m] -= bid;
      }
      logs.writeLog('Bids - $bets');

      // Выключаем из посчета игроков, чья ставка была равно отработанной
      for (var player in activePlayers) {
        if (sessionState.bets[player.uid] == bid) {
          sessionState.foldedOrInactive.add(player.uid);
          winners.remove(player.uid);
        }

        // Уменьшаем ставки игроков, так как сумма равная [bid] уже отыграла
        sessionState.bets.update(player.uid, (value) => value - bid);
      }
    }

    // pop();
    return;
  }

  // Переходы между игроками
  Future<void> _newPlayer({PlayerId? jumpToUid}) async {
    // Если у игроков деньги все уже пустые, то скипаем
    if (!checkPlayersHaveMoney) {
      logs.writeLog('No one player with money\n${lobbyState.banks}');
      return showWinnersAndEndLap();
    }

    final PlayerId newPlayerUid;

    if (jumpToUid != null) {
      newPlayerUid = jumpToUid;
    } else {
      int newIndex = (currentPlayerIndex + 1) % lobbyState.players.length;

      newPlayerUid = lobbyState.players[newIndex].uid;

      final bidsEqual = checkBidsEqual();
      final firstLap = sessionState.lapCounter <= 0;

      if (!firstLap && bidsEqual) {
        return _newState();
      } else {
        if (newPlayerUid == sessionState.firstPlayerUid && bidsEqual) {
          return _newState();
        }
      }
    }

    if (playersWithMoneyCount < 2) {
      final maxBid = sessionState.bets.values.reduce(max);

      if (sessionState.bets[newPlayerUid] == maxBid) {
        showWinnersAndEndLap();
      }
    }

    // Пропуск лоха без денег
    final playerBank = lobbyState.banks[newPlayerUid] ?? 0;
    if (playerBank <= 0) {
      return _newPlayer();
    }

    // Если челикс фолданул, скипаем его
    if (sessionState.foldedOrInactive.contains(newPlayerUid)) {
      return _newPlayer();
    }

    //raiseBank = minTmpFunction(bidsEqual);

    int lapCounter = sessionState.lapCounter;

    if (newPlayerUid == sessionState.firstPlayerUid) {
      lapCounter += 1;
    }

    _updateSessionState(
      sessionState.copyWith(
        lapCounter: lapCounter,
        currentPlayerUid: newPlayerUid,
      ),
    );
    //TODO SAVE

    logs.writeLog(
      'Turn of ${lobbyState.players.firstWhere((p) => p.uid == newPlayerUid).name}',
    );
    //TODO:
    //lobbyStorage.write(lobbyState);
    return;
  }

  int _calculateMaxBid() {
    // Сколько нужно добавить для выравнивания
    int playerModey(PlayerId playerUid) {
      int thisBank = lobbyState.banks[playerUid] ?? 0;
      int thisMax = thisBank + (sessionState.bets[playerUid] ?? 0);

      return thisMax;
    }

    int thisBank = lobbyState.banks[currentPlayerUid] ?? 0;
    final thisMax = playerModey(currentPlayerUid);

    int maxBid = thisMax;
    for (final player in lobbyState.players) {
      if (!sessionState.foldedOrInactive.contains(player.uid)) {
        var playerMoney = playerModey(player.uid);

        if (thisMax > playerMoney) {
          var toEqual = thisMax - playerMoney;
          if (toEqual < maxBid) {
            maxBid = toEqual;
          }
        }
      }
    }
    if (maxBid == thisMax) maxBid = 0;

    return thisBank - maxBid;
  }

  // Новая улица
  void _newState() async {
    // Проверяем, шобы ставки были одинаковы

    if (checkBidsEqual()) {
      //переходим в новое состояние

      _updateSessionState(
        sessionState.copyWith(
          lapCounter: sessionState.lapCounter + 1,
        ),
      );
      _updateLobbyState(
        lobbyState.copyWith(
          gameState: lobbyState.gameState.next,
        ),
      );

      //TODO:
      //lobbyStorage.write(lobbyState);
    }
    //после префлопа первый игрок - смол блайнд
    if (lobbyState.gameState == GameStatusEnum.flop) {
      for (int i = 1; i < lobbyState.players.length; i++) {
        final dealerPosition =
            lobbyState.players.indexWhere((p) => p.uid == lobbyState.dealerId);

        int localIndex = (i + dealerPosition) % lobbyState.players.length;
        final localPlayer = lobbyState.players[localIndex];

        if (!sessionState.foldedOrInactive.contains(localPlayer.uid)) {
          _updateSessionState(
            sessionState.copyWith(
              firstPlayerUid: localPlayer.uid,
            ),
          );

          break;
        }
      }
    }
    if (lobbyState.gameState == GameStatusEnum.showdown) {
      await showWinnersAndEndLap();
      return null;
    }
    _newPlayer(jumpToUid: sessionState.firstPlayerUid);
  }

  void _resetPlayers() {
    // Cтираем старые ставки и тех, кто фолданул
    for (final player in lobbyState.players) {
      _updateSessionState(
        sessionState.copyWith(bets: {}, foldedOrInactive: {}),
      );

      final playerBank = lobbyState.banks[player.uid] ?? 0;
      if (playerBank <= 0) {
        sessionState.foldedOrInactive.add(player.uid);
      }
    }
  }

  void _findNewDealer() {
    final dealerPosition =
        lobbyState.players.indexWhere((p) => p.uid == lobbyState.dealerId);

    // finding dealer
    for (int i = 1; i < lobbyState.players.length; i++) {
      int localIndex = (i + dealerPosition) % lobbyState.players.length;
      final localPlayer = lobbyState.players[localIndex];

      if (!sessionState.foldedOrInactive.contains(localPlayer.uid)) {
        _updateLobbyState(
          lobbyState.copyWith(
            dealerId: localPlayer.uid,
          ),
        );

        logs.writeLog('new dealer index: $localIndex');
        break;
      }
    }
  }

  // Первые ставки
  void _processFirstBlinds() {
    logs.writeLog('First Blind');

    final dealerPosition =
        lobbyState.players.indexWhere((p) => p.uid == lobbyState.dealerId);

    int bigBlindPosition = dealerPosition;

    // Ищем смолблайнд
    for (int i = 1; i < lobbyState.players.length; i++) {
      int localIndex = (i + dealerPosition) % lobbyState.players.length;

      final localPlayer = lobbyState.players[localIndex];

      if (!sessionState.foldedOrInactive.contains(localPlayer.uid)) {
        final bank = lobbyState.banks[localPlayer.uid] ?? 0;
        // Ставка тех денег, что есть
        if (bank < lobbyState.smallBlindValue) {
          _processBet(
            localPlayer.uid,
            bank,
            overrideBank: 0,
          );
        } else {
          // Ставка для смолблайнд
          _processBet(localPlayer.uid, lobbyState.smallBlindValue);
        }
        logs.writeLog('smallBlindIndex - $localIndex');
        break;
      }
    } // Ищем бигблайнд
    for (int i = 1; i < lobbyState.players.length + 1; i++) {
      int localIndex = (i + dealerPosition) % lobbyState.players.length;

      final localPlayer = lobbyState.players[localIndex];

      if (!sessionState.foldedOrInactive.contains(localPlayer.uid) &&
          sessionState.bets[localPlayer.uid] == 0) {
        final bank = lobbyState.banks[localPlayer.uid] ?? 0;

        // Ставка тех денег, что есть
        if (bank < lobbyState.bigBlindValue) {
          _processBet(
            localPlayer.uid,
            bank,
            overrideBank: 0,
          );
        } else {
          // Ставка для бигблайнда
          _processBet(localPlayer.uid, lobbyState.bigBlindValue);
        }

        logs.writeLog('bigBlindIndex - $localIndex');
        //lobbyState.dealerIndex = (i+lobbyState.dealerIndex)%maxPlayerCount;

        bigBlindPosition = localIndex;
      }
    }

    // Ищем первого игрока
    for (int i = 1; i < lobbyState.players.length; i++) {
      int localIndex = (i + bigBlindPosition) % lobbyState.players.length;

      final localPlayer = lobbyState.players[localIndex];

      if (!sessionState.foldedOrInactive.contains(localPlayer.uid)) {
        _updateSessionState(
          sessionState.copyWith(
            currentPlayerUid: localPlayer.uid,
            firstPlayerUid: localPlayer.uid,
          ),
        );

        logs.writeLog('firstPlayer - ${localPlayer.name}');

        break;
      }
    }
  }

  @override
  GameSettingsModel get getSettings => GameSettingsModel(
        smallBlind: lobbyState.smallBlindValue,
        startingStack: lobbyState.defaultBank,
        canEditStack: lobbyState.gameState.canEditPlayers,
      );

  @override
  Future<void> saveSettings(GameSettingsModel settings) => _updateLobbyState(
        lobbyState.copyWith(
          smallBlindValue: settings.smallBlind,
          defaultBank: settings.startingStack,
        ),
      );

  Future<void> _updateLobbyState(LobbyStateModel newLobby) =>
      _lobbyStateHolder.updateLobby(newLobby);

  Future<void> _updateSessionState(GameSessionState newSession) async {
    state = AsyncData(stateModel.copyWith(sessionState: newSession));

    try {
      await _appRepository.updateGameSessionState(newSession);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении сессии: $e');
    }
  }
}
