import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/toast_manager.dart';

import 'lobby_state_holder_test.mocks.dart';
import 'tests/test_add_player.dart';
import 'tests/test_remove_player.dart';
import 'tests/test_reorder_player.dart';
import 'tests/test_reset_lobby.dart';
import 'tests/test_save_settings.dart';
import 'tests/test_starting_stack_change.dart';
import 'tests/test_update_player.dart';

@GenerateMocks([
  AppRepository,
  ToastManager,
])
void main() {
  group(
    'LobbyStateHolder',
    () {
      late ProviderContainer container;
      late MockAppRepository mockAppRepository;
      late MockToastManager mockToastManager;

      setUp(() {
        mockAppRepository = MockAppRepository();
        mockToastManager = MockToastManager();

        container = ProviderContainer.test(
          overrides: [
            appRepositoryProvider.overrideWithValue(mockAppRepository),
            toastManagerProvider.overrideWithValue(mockToastManager)
          ],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test(
        'StartingStackChange test',
        () => runStartingStackChangeTest(container, mockAppRepository),
      );

      test(
        'Reset lobby test',
        () => runResetLobbyChangeTest(container, mockAppRepository),
      );

      test(
        'Add Player test',
        () => runAddPlayerTest(container, mockAppRepository),
      );
      test(
        'Add Player with custom bank test',
        () => runAddPlayerCustomBankTest(container, mockAppRepository),
      );
      test(
        'Add Exist Player test',
        () => runAddExistPlayerTest(container, mockAppRepository),
      );
      test(
        'Add Exist Name Player test',
        () => runAddExistNamePlayerTest(container, mockAppRepository),
      );
      test(
        'Add Player To max lobby test',
        () => runAddPlayerWhileMaxTest(container, mockAppRepository),
      );

      test(
        'Update Player test',
        () => runUpdatePlayerTest(container, mockAppRepository),
      );
      test(
        'Update Player to exist one test',
        () => runUpdatePlayerToExistTest(container, mockAppRepository),
      );
      test(
        'Update Player to exist name test',
        () => runUpdatePlayerToExistNameTest(container, mockAppRepository),
      );
      test(
        'Update Player and disable dealer test',
        () => runUpdatePlayerDisableDealerTest(
          container,
          mockAppRepository,
          mockToastManager,
        ),
      );

      test(
        'Remove Player test',
        () => runRemovePlayerTest(container, mockAppRepository),
      );
      test(
        'Remove Unexisted Player',
        () => runRemoveUnexistedPlayerTest(container, mockAppRepository),
      );
      test(
        'Remove dealer Player',
        () => runRemoveDealerPlayerTest(container, mockAppRepository),
      );
      test(
        'Remove dealer first Player',
        () => runRemoveDealerFirstPlayerTest(container, mockAppRepository),
      );
      test(
        'Remove last Player',
        () => runRemoveLastPlayerTest(container, mockAppRepository),
      );

      test(
        'Reorder player to same place test',
        () => runReorderSamePlayerTest(container, mockAppRepository),
      );
      test(
        'Reorder one player test',
        () => runReorderSinglePlayerTest(container, mockAppRepository),
      );
      test(
        'Reorder two players to each other test',
        () => runReorderTwoPlayersTest(container, mockAppRepository),
      );
      test(
        'Reorder last to first player test',
        () => runReorderToFirstTest(container, mockAppRepository),
      );
      test(
        'Reorder first to last player test',
        () => runReorderToLastTest(container, mockAppRepository),
      );

      test(
        'Saving settings same bank test',
        () => runSaveSettingsSameBankTest(container, mockAppRepository),
      );
      test(
        'Saving settings new bank test',
        () => runSaveSettingsNewBankTest(container, mockAppRepository),
      );
      test(
        'Saving settings new small blind test',
        () => runSaveSettingsNewSmallBlindTest(container, mockAppRepository),
      );
      test(
        'Saving settings no editing test',
        () => runSaveSettingsNoEditingTest(container, mockAppRepository),
      );
    },
  );
}
