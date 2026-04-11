import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'game_state_machine_test.mocks.dart';
import 'tests/test_call_value_calculation.dart';
import 'tests/test_execute_call.dart';
import 'tests/test_execute_check.dart';
import 'tests/test_execute_fold.dart';
import 'tests/test_execute_raise.dart';
import 'tests/test_hands_up_starting_bet.dart';
import 'tests/test_initialization.dart';
import 'tests/test_progression.dart';
import 'tests/test_raise_value_calculation.dart';
import 'tests/test_showndown_step.dart';
import 'tests/test_starting_bet.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'GameStateMachine',
    () {
      late ProviderContainer container;
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();

        container = ProviderContainer.test(
          overrides: [
            appRepositoryProvider.overrideWithValue(mockAppRepository),
          ],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test(
        'Initialization Test',
        () => runInitialization(container, mockAppRepository),
      );

      test(
        'Initialization with auto-fold for players with zero bank',
        () => runInitializationAndAutoFold(container, mockAppRepository),
      );
      test(
        'Initialization restores saved blind progression state',
        () => runInitializationWithSavedHandsProgressionTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        'Manual progression resets after rebuild in notStarted state',
        () => runManualProgressionResetOnRebuildTest(mockAppRepository),
      );
      test(
        'Manual progression clamps current level on restore',
        () => runManualProgressionClampOnRestoreTest(
          container,
          mockAppRepository,
        ),
      );

      test(
        'Hands progression advances level after completed hand',
        () => runEveryNHandsProgressionTest(container, mockAppRepository),
      );

      test(
        'Timed progression advances on restore during breakdown',
        () => runTimedProgressionAdvanceOnRestoreTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        'Hands progression does not advance after reaching last level',
        () => runEveryNHandsLastLevelNoAdvanceTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        'Manual progression does not change during active hand',
        () => runManualProgressionIgnoredDuringHandTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        'Manual progression stays on last level',
        () => runManualProgressionStaysOnLastLevelTest(
          container,
          mockAppRepository,
        ),
      );

      // ---

      test(
        '[Hands-up] startingBetting test',
        () => runHandUpStaringBetTest(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, first player all in',
        () => runHandUpStaringBetFirstAllInTest(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, second player all in',
        () => runHandUpStaringBetSecondAllInTest(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, all in players',
        () => runHandUpStaringBetAllInTest(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, has inactive',
        () => runHandUpStartingBetNoChipsTest(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, has inactive 2',
        () => runHandUpStartingBetNoChips2Test(container, mockAppRepository),
      );

      test(
        '[Hands-up] startingBetting test, has inactive and all in',
        () => runHandUpStartingBetHasNoChipsWithAllInTest(
          container,
          mockAppRepository,
        ),
      );

      // ---

      test(
        '[Starting-Betting] common test',
        () => runStartingBettingTest(container, mockAppRepository),
      );

      test(
        '[Starting-Betting] common test no players',
        () => runStartingBettingWithNoPlayersTest(container, mockAppRepository),
      );

      test(
        '[Starting-Betting] first player has no chips',
        () => runStartingBetFirstNoChipsTest(container, mockAppRepository),
      );

      test(
        '[Starting-Betting] second player has no chips',
        () => runStartingBetSecondNoChipsTest(container, mockAppRepository),
      );
      test(
        '[Starting-Betting] traditional ante is posted before blinds',
        () => runStartingBetTraditionalAntePriorityTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Starting-Betting] BBA is posted after big blind',
        () => runStartingBetBigBlindAntePriorityTest(
          container,
          mockAppRepository,
        ),
      );

      test(
        '[Starting-Betting] first&second players has no chips',
        () =>
            runStartingBetFirstSecondNoChipsTest(container, mockAppRepository),
      );

      test(
        '[Starting-Betting] first&second players has no chips 2',
        () =>
            runStartingBetFirstSecondNoChips2Test(container, mockAppRepository),
      );

      // ---

      test(
        '[Raise Value] calculate pre-flop raise value for small blind',
        () => runRaiseValueCalculationSmallBlindTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Raise Value] calculate pre-flop raise value for big blind',
        () =>
            runRaiseValueCalculationBigBlindTest(container, mockAppRepository),
      );
      test(
        '[Raise Value] calculate pre-flop raise value for big blind, small blind folded',
        () =>
            runRaiseValueCalculationBigBlind2Test(container, mockAppRepository),
      );
      test(
        '[Raise Value] calculate pre-flop re-raise value',
        () =>
            runReRaisePreflopValueCalculationTest(container, mockAppRepository),
      );
      test(
        '[Raise Value] calculate flop re-raise value',
        () => runReRaiseFlopValueCalculationTest(container, mockAppRepository),
      );
      test(
        '[Raise Value] calculate for equal bets on not pre-plop street (big blind)',
        () => runBetValueCalculationTurnTest(container, mockAppRepository),
      );
      test(
        '[Raise Value] calculate value is all in case',
        () => runReRaiseValueCalculationAllInTest(container, mockAppRepository),
      );

      // ---

      test(
        '[Call Value] calculate pre-flop call value for small blind',
        () =>
            runCallValueCalculationSmallBlindTest(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate pre-flop call value for big blind',
        () => runCallValueCalculationBigBlindTest(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate pre-flop call value for big blind, small blind folded',
        () =>
            runCallValueCalculationBigBlind2Test(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate pre-flop call raise value',
        () => runCallRaisePreflopValueCalculationTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Call Value] calculate flop call raise value',
        () => runReCallFlopValueCalculationTest(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate for equal bets on not pre-plop street (big blind)',
        () => runCallValueCalculationTurnTest(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate value after bigblind fold',
        () => runCallValueCalculationBBAllInTest(container, mockAppRepository),
      );
      test(
        '[Call Value] calculate value is all in case',
        () =>
            runCallRaiseValueCalculationAllInTest(container, mockAppRepository),
      );

      test(
        '[Execute FOLD] common fold',
        () => runExecuteFoldTest(container, mockAppRepository),
      );
      test(
        '[Execute FOLD] fold last player on equal flop',
        () => runExecuteFoldLastPlayerFlopTest(container, mockAppRepository),
      );
      test(
        '[Execute FOLD] fold last player on equal pre-flop',
        () => runExecuteFoldLastPlayerPreFlopTest(container, mockAppRepository),
      );
      test(
        '[Execute FOLD] fold all players except one',
        () => runExecuteFoldAllPlayersPreFlopTest(container, mockAppRepository),
      );
      test(
        '[Execute FOLD] fold player with 2 inactive',
        () =>
            runExecuteFoldPlayerWithInactiveTest(container, mockAppRepository),
      );

      //---

      test(
        '[Execute CHECK] сheck on big blind player on pre-flop hand-up',
        () => runExecuteCheckHandUpBigBlindTest(container, mockAppRepository),
      );

      // ---

      test(
        '[Showdown Test] check auto show single winner and money distibution',
        () => runShowdownWinFromFoldedTest(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution for 1 winner',
        () => runShowdownEqualBidsOneWinnerTest(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution for 2 winners',
        () => runShowdownEqualBidsTwoWinnerTest(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution for all winners',
        () => runShowdownEqualBidsAllWinnersTest(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution with 2 allin player in pre-flop',
        () => runShowdownTwoAllPreflopInTest(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution with 2 allin player in pre-flop (biglind winner)',
        () => runShowdownTwoAllPreflopIn2Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution with 2 allin player in pre-flop (allin and biglind winner)',
        () => runShowdownTwoAllPreflopIn3Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] show winner selection and money distribution with 2 allin player in pre-flop (all winners)',
        () => runShowdownTwoAllPreflopIn4Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] distribution test 1',
        () => runShowdownDistribution1Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] distribution test 2',
        () => runShowdownDistribution2Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] distribution test 3',
        () => runShowdownDistribution3Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] distribution test 4',
        () => runShowdownDistribution4Test(container, mockAppRepository),
      );
      test(
        '[Showdown Test] folded dead money is carried into next pot',
        () => runShowdownFoldedDeadMoneyEffectTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Showdown Test] traditional ante stays proportional in side pots',
        () => runShowdownTraditionalAnteDistributionTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Showdown Test] traditional ante with short stack logic creates zero bid pot',
        () => runShowdownTraditionalAnteShortStackEffectTest(
          container,
          mockAppRepository,
        ),
      );
      test(
        '[Showdown Test] traditional ante matched by everyone skips zero bid pot and splits early',
        () => runShowdownTraditionalAnteNormalEffectTest(
          container,
          mockAppRepository,
        ),
      );

      //---

      test(
        '[Call Test] final call after raise test',
        () => runExecuteCallFinalAfterRaiseTest(container, mockAppRepository),
      );
      test(
        '[Call Test] final call after re-raise test',
        () => runExecuteCallFinalAfterReRaiseTest(container, mockAppRepository),
      );

      //---
      test(
        '[Raise Test] re-raise on last player before equal',
        () => runExecuteReRaiseLastTest(container, mockAppRepository),
      );
    },
  );
}
