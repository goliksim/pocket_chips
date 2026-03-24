import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'game_test.mocks.dart';
import 'tests/game/game_test_1.dart';
import 'tests/game/game_test_10.dart';
import 'tests/game/game_test_11.dart';
import 'tests/game/game_test_2.dart';
import 'tests/game/game_test_3.dart';
import 'tests/game/game_test_4.dart';
import 'tests/game/game_test_5.dart';
import 'tests/game/game_test_6.dart';
import 'tests/game/game_test_7.dart';
import 'tests/game/game_test_8.dart';
import 'tests/game/game_test_9.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Game tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Game Test 1',
        ($) => runGameTest1($, mockAppRepository),
      );

      patrolTest(
        'Game Test 2',
        ($) => runGameTest2($, mockAppRepository),
      );

      patrolTest(
        'Game Test 3',
        ($) => runGameTest3($, mockAppRepository),
      );

      patrolTest(
        'Game Test 4',
        ($) => runGameTest4($, mockAppRepository),
      );

      patrolTest(
        'Game Test 5',
        ($) => runGameTest5($, mockAppRepository),
      );

      patrolTest(
        'Game Test 6',
        ($) => runGameTest6($, mockAppRepository),
      );

      patrolTest(
        'Game Test 7',
        ($) => runGameTest7($, mockAppRepository),
      );

      patrolTest(
        'Game Test 8',
        ($) => runGameTest8($, mockAppRepository),
      );

      patrolTest(
        'Game Test 9',
        ($) => runGameTest9($, mockAppRepository),
      );

      patrolTest(
        'Game Test 10',
        ($) => runGameTest10($, mockAppRepository),
      );

      patrolTest(
        'Game Test 11',
        ($) => runGameTest11($, mockAppRepository),
      );
    },
  );
}
