import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'game_tests.mocks.dart';
import 'tests/game/game_test_1.dart';
import 'tests/game/game_test_10.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Game tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Game Test 1',
        (WidgetTester tester) => runGameTest1(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 2',
        (WidgetTester tester) => runGameTest2(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 3',
        (WidgetTester tester) => runGameTest3(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 4',
        (WidgetTester tester) => runGameTest4(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 5',
        (WidgetTester tester) => runGameTest5(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 6',
        (WidgetTester tester) => runGameTest6(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 7',
        (WidgetTester tester) => runGameTest7(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 8',
        (WidgetTester tester) => runGameTest8(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 9',
        (WidgetTester tester) => runGameTest9(tester, mockAppRepository),
      );

      testWidgets(
        'Game Test 10',
        (WidgetTester tester) => runGameTest10(tester, mockAppRepository),
      );
    },
  );
}
