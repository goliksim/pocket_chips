import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_progression_state.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_game_settings_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../mocks/lobby_state_holder_mock.dart';
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';

LobbyStateModel buildLobbyState({
  required List<PlayerModel> players,
  int bank = defaultLobbyBank,
  int smallBlind = defaultSmallBlindValue,
  GameStatusEnum gameState = GameStatusEnum.notStarted,
  String? dealerId,
  Map<String, int>? banks,
  BlindProgressionModel? progression,
}) =>
    LobbyStateModel(
      players: players,
      banks: banks ?? {for (var player in players) player.uid: bank},
      defaultBank: bank,
      gameState: gameState,
      dealerId: dealerId,
      settings: LobbyGameSettingsModel(
        progression: progression ??
            BlindProgressionModel(
              progressionType: BlindProgressionType.manual,
              progressionInterval: null,
              blinds: BlindLevelModel(smallBlind: smallBlind),
            ),
      ),
    );

GameSessionState buildSessionState({
  Map<String, int>? bets,
  Set<String>? foldedPlayers,
  int lapCounter = 0,
  String? currentPlayerUid,
  String? firstPlayerUid,
  GameProgressionState? progressionState,
}) =>
    GameSessionState(
      bets: bets ?? {},
      foldedPlayers: foldedPlayers ?? {},
      lapCounter: lapCounter,
      currentPlayerUid: currentPlayerUid,
      firstPlayerUid: firstPlayerUid,
      progressionState: progressionState ?? const GameProgressionState(),
    );

TAction pumpGameApp({
  required PatrolTester tester,
  required MockAppRepository repository,
  required LobbyStateModel lobbyState,
  required List<PlayerModel> savedPlayers,
  GameSessionState? sessionState,
}) =>
    () async {
      final mock = repository as dynamic;

      when(mock.getConfig()).thenAnswer((_) async => defaultConfig());
      when(mock.isProVersion()).thenAnswer((_) async => true);
      when(mock.getLobbyState()).thenAnswer((_) async => lobbyState);
      when(mock.getSavedPlayers()).thenAnswer(
        (_) async => List<PlayerModel>.from(savedPlayers),
      );
      when(mock.updateLobbyState(any)).thenAnswer((_) async {});
      when(mock.updateGameSessionState(any)).thenAnswer((_) async {});
      when(mock.changeProVersion(any)).thenAnswer((_) async {});
      when(mock.getGameSessionState()).thenAnswer((_) async => sessionState);

      when(mock.addPlayer(any)).thenAnswer((invocation) async {
        final player = invocation.positionalArguments.first as PlayerModel;
        savedPlayers.add(player);
      });
      when(mock.removePlayer(any)).thenAnswer((invocation) async {
        final uid = invocation.positionalArguments.first as String;
        savedPlayers.removeWhere((player) => player.uid == uid);
      });
      when(mock.updatePlayer(any)).thenAnswer(
        (invocation) async {
          final player = invocation.positionalArguments.first as PlayerModel;
          final index = savedPlayers.indexWhere((p) => p.uid == player.uid);
          if (index != -1) {
            savedPlayers[index] = player;
          }
        },
      );

      final mockPurchasesRepository =
          MockPurchasesRepository(hasPurchasesForRestore: true)
            ..setScenario(MockScenario.success);

      await tester.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            appRepositoryProvider.overrideWithValue(repository),
            lobbyStateHolderProvider.overrideWith(
              () => MockLobbyStateHolder(initialState: lobbyState),
            ),
            proVersionRepositoryProvider
                .overrideWithValue(mockPurchasesRepository),
          ],
          child: const MyApp(),
        ),
      );
    };

TAction openGamePage(
  PatrolTester tester,
) {
  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);

  return runTestActions(
    [
      homePage.verifyHomePageVisibility(),
      homePage.continueGame(),
      lobbyPage.verifyVisibility(),
      lobbyPage.toGame(),
    ],
  );
}
