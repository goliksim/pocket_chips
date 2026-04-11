import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_progression_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Shrinking levels clamps active progression level to the new last level
Future<void> runGameTest13(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];
  const progression = BlindProgressionModel.pro(
    progressionType: BlindProgressionType.manual,
    progressionInterval: null,
    levels: [
      BlindLevelModel(smallBlind: 10),
      BlindLevelModel(smallBlind: 20),
      BlindLevelModel(smallBlind: 30),
      BlindLevelModel(smallBlind: 40),
      BlindLevelModel(smallBlind: 50),
    ],
  );

  final gamePage = GamePageTester(tester);
  final settingsDialog = GameSettingsDialogTester(tester);

  await runAction(
    pumpGameApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(
        players: players,
        dealerId: players.first.uid,
        gameState: GameStatusEnum.gameBreak,
        progression: progression,
      ),
      sessionState: buildSessionState(
        progressionState: const GameProgressionState(currentLevelIndex: 4),
      ),
      savedPlayers: savedPlayers,
    ),
  );

  await runTestActions(
    [
      openGamePage(tester),
      gamePage.verifySmallBlindValues(50),
      gamePage.verifyProgressionSetupLabel(),
      gamePage.openSettins(),
      settingsDialog.verifyVisibility(),
      settingsDialog.enterLevelsCount('2'),
      settingsDialog.saveChangesAndExit(),
      gamePage.verifyVisibility(),
      gamePage.verifySmallBlindValues(20),
      gamePage.verifyProgressionSetupLabel(),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.verifyPlayerBetValue(
        name: players.first.name,
        expectedBet: 20,
      ),
    ],
  )();
}
