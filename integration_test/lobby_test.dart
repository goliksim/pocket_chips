import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'lobby_test.mocks.dart';
import 'tests/lobby/lobby_test_1.dart';
import 'tests/lobby/lobby_test_10.dart';
import 'tests/lobby/lobby_test_11.dart';
import 'tests/lobby/lobby_test_12.dart';
import 'tests/lobby/lobby_test_2.dart';
import 'tests/lobby/lobby_test_3.dart';
import 'tests/lobby/lobby_test_4.dart';
import 'tests/lobby/lobby_test_5.dart';
import 'tests/lobby/lobby_test_6.dart';
import 'tests/lobby/lobby_test_7.dart';
import 'tests/lobby/lobby_test_8.dart';
import 'tests/lobby/lobby_test_9.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Lobby tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Lobby Test 1',
        ($) => runLobbyTest1($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 2',
        ($) => runLobbyTest2($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 3',
        ($) => runLobbyTest3($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 4',
        ($) => runLobbyTest4($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 5',
        ($) => runLobbyTest5($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 6',
        ($) => runLobbyTest6($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 7',
        ($) => runLobbyTest7($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 8',
        ($) => runLobbyTest8($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 9',
        ($) => runLobbyTest9($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 10',
        ($) => runLobbyTest10($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 11',
        ($) => runLobbyTest11($, mockAppRepository),
      );

      patrolTest(
        'Lobby Test 12',
        ($) => runLobbyTest12($, mockAppRepository),
      );
    },
  );
}
