import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'lobby_tests.mocks.dart';
import 'tests/lobby/lobby_test_1.dart';
import 'tests/lobby/lobby_test_10.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Lobby tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Lobby Test 1',
        (WidgetTester tester) => runLobbyTest1(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 2',
        (WidgetTester tester) => runLobbyTest2(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 3',
        (WidgetTester tester) => runLobbyTest3(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 4',
        (WidgetTester tester) => runLobbyTest4(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 5',
        (WidgetTester tester) => runLobbyTest5(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 6',
        (WidgetTester tester) => runLobbyTest6(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 7',
        (WidgetTester tester) => runLobbyTest7(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 8',
        (WidgetTester tester) => runLobbyTest8(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 9',
        (WidgetTester tester) => runLobbyTest9(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 10',
        (WidgetTester tester) => runLobbyTest10(tester, mockAppRepository),
      );
    },
  );
}
