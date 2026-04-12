import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/app/theme_provider.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/di/view_models.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_progression_state.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_game_settings_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/l10n/app_localizations.dart';
import 'package:pocket_chips/presentation/game/view_state/game_table_state.dart';
import 'package:pocket_chips/presentation/game/widgets/game_contol/game_control.dart';
import 'package:pocket_chips/presentation/game/widgets/game_progression_widget.dart';
import 'package:pocket_chips/services/assets_provider.dart';
import 'package:pocket_chips/services/event_push_service/handlers/event_handler.dart';
import 'package:pocket_chips/services/event_push_service/promotion_service.dart';

import 'repository_mock.dart';

void main() {
  group('Game progression UI', () {
    testWidgets('Simple mode with one level hides progression UI', (
      tester,
    ) async {
      await _pumpProgressionWidget(
        tester,
        const GameTableState(
          players: [],
          smallBlindValue: 25,
          progressionType: BlindProgressionType.manual,
          anteType: AnteType.none,
          showProgression: false,
          progressionLevel: 1,
        ),
      );

      expect(find.byKey(GameKeys.progressionSetupLabel), findsOneWidget);
      expect(find.byKey(GameKeys.progressionLevel(1)), findsNothing);
      expect(find.byKey(GameKeys.progressionIntervalValue(1)), findsNothing);
      expect(find.byKey(GameKeys.blinds(25)), findsOneWidget);
    });

    testWidgets('Pro mode with one level hides progression UI', (tester) async {
      await _pumpProgressionWidget(
        tester,
        const GameTableState(
          players: [],
          smallBlindValue: 25,
          progressionType: BlindProgressionType.everyNHands,
          anteType: AnteType.none,
          showProgression: false,
          progressionLevel: 1,
        ),
      );

      expect(find.byKey(GameKeys.progressionSetupLabel), findsOneWidget);
      expect(find.byKey(GameKeys.progressionLevel(1)), findsNothing);
      expect(find.byKey(GameKeys.progressionIntervalValue(1)), findsNothing);
      expect(find.byKey(GameKeys.blinds(25)), findsOneWidget);
    });

    testWidgets('Last level hides progression label and level-up button', (
      tester,
    ) async {
      final players = _buildPlayers(2);
      final repo = MockAppRepository(
        lobbyState: _buildLobbyState(
          players: players,
          gameState: GameStatusEnum.gameBreak,
          progression: const BlindProgressionModel.pro(
            progressionType: BlindProgressionType.manual,
            progressionInterval: null,
            levels: [
              BlindLevelModel(smallBlind: 10),
              BlindLevelModel(smallBlind: 20),
            ],
          ),
        ),
        gameSessionState: GameSessionState(
          bets: const {},
          foldedPlayers: const {},
          lapCounter: 0,
          progressionState: const GameProgressionState(currentLevelIndex: 1),
        ),
      );

      await _pumpGameControlHarness(tester, repo);

      expect(find.byKey(GameKeys.progressionSetupLabel), findsNothing);
      expect(find.byKey(GameKeys.progressionLevel(2)), findsOneWidget);
      expect(find.byKey(GameKeys.increaseLevelButton), findsNothing);
      expect(find.byKey(GameKeys.blinds(20)), findsOneWidget);
    });

    testWidgets('Not started timed progression does not show countdown', (
      tester,
    ) async {
      final players = _buildPlayers(2);
      var currentTime = DateTime.utc(2026, 4, 3, 12, 0);
      final repo = MockAppRepository(
        lobbyState: _buildLobbyState(
          players: players,
          gameState: GameStatusEnum.notStarted,
          progression: const BlindProgressionModel.pro(
            progressionType: BlindProgressionType.everyNMinutes,
            progressionInterval: 2,
            levels: [
              BlindLevelModel(smallBlind: 10),
              BlindLevelModel(smallBlind: 20),
            ],
          ),
        ),
        gameSessionState: GameSessionState(
          bets: const {},
          foldedPlayers: const {},
          lapCounter: 0,
          progressionState: GameProgressionState(
            currentLevelIndex: 0,
            nextLevelAtEpochMsUtc: null,
          ),
        ),
      );

      await _pumpGameControlHarness(
        tester,
        repo,
        nowProvider: () => currentTime,
      );

      expect(find.byKey(GameKeys.progressionLevel(1)), findsOneWidget);
      expect(find.byKey(GameKeys.progressionIntervalValue(3)), findsNothing);

      currentTime = currentTime.add(const Duration(minutes: 1));
      await tester.pump(const Duration(minutes: 1));
      await tester.pump();

      expect(find.byKey(GameKeys.progressionIntervalValue(3)), findsNothing);
      expect(find.byKey(GameKeys.progressionIntervalValue(2)), findsNothing);
    });

    testWidgets('Breakdown timed progression updates countdown every minute', (
      tester,
    ) async {
      final players = _buildPlayers(2);
      var currentTime = DateTime.utc(2026, 4, 3, 12, 0);
      final repo = MockAppRepository(
        lobbyState: _buildLobbyState(
          players: players,
          gameState: GameStatusEnum.gameBreak,
          progression: const BlindProgressionModel.pro(
            progressionType: BlindProgressionType.everyNMinutes,
            progressionInterval: 2,
            levels: [
              BlindLevelModel(smallBlind: 10),
              BlindLevelModel(smallBlind: 20),
              BlindLevelModel(smallBlind: 40),
            ],
          ),
        ),
        gameSessionState: GameSessionState(
          bets: const {},
          foldedPlayers: const {},
          lapCounter: 0,
          progressionState: GameProgressionState(
            currentLevelIndex: 0,
            nextLevelAtEpochMsUtc: currentTime
                .add(const Duration(seconds: 130))
                .millisecondsSinceEpoch,
          ),
        ),
      );

      await _pumpGameControlHarness(
        tester,
        repo,
        nowProvider: () => currentTime,
      );

      expect(find.byKey(GameKeys.progressionIntervalValue(3)), findsOneWidget);

      currentTime = currentTime.add(const Duration(seconds: 61));
      await tester.pump(const Duration(seconds: 61));
      await tester.pump();

      expect(find.byKey(GameKeys.progressionIntervalValue(3)), findsNothing);
      expect(find.byKey(GameKeys.progressionIntervalValue(2)), findsOneWidget);
    });
  });
}

Future<void> _pumpProgressionWidget(
  WidgetTester tester,
  GameTableState tableState,
) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScreenUtilInit(
          designSize: const Size(320, 800),
          builder: (_, __) => AppThemeBuilder(
            builder: (context, _) => Scaffold(
              body: GameProgressionWidget(tableState: tableState),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<void> _pumpGameControlHarness(
  WidgetTester tester,
  MockAppRepository repository, {
  DateTime Function()? nowProvider,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        if (nowProvider != null)
          currentTimeProvider.overrideWithValue(nowProvider),
        promotionManagerProvider.overrideWithValue(
          PromotionManager(handlers: <EventHandler>[]),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScreenUtilInit(
          designSize: const Size(320, 800),
          builder: (_, __) => AppThemeBuilder(
            builder: (context, _) => Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final viewState = ref.watch(gamePageViewModelProvider);

                  return viewState.maybeWhen(
                    data: (data) => GameControl(
                      viewModel: ref.read(gamePageViewModelProvider.notifier),
                      statsWidget: GameProgressionWidget(
                        tableState: data.tableState,
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

List<PlayerModel> _buildPlayers(int count) => List.generate(
      count,
      (index) => PlayerModel(
        uid: 'widget_player_$index',
        name: 'Widget Player $index',
        assetUrl: AssetsProvider.emptyPlayerAsset,
      ),
    );

LobbyStateModel _buildLobbyState({
  required List<PlayerModel> players,
  required GameStatusEnum gameState,
  required BlindProgressionModel progression,
}) =>
    LobbyStateModel(
      players: players,
      banks: {for (final player in players) player.uid: 5000},
      settings: LobbyGameSettingsModel(progression: progression),
      gameState: gameState,
      defaultBank: 5000,
      dealerId: players.first.uid,
    );
