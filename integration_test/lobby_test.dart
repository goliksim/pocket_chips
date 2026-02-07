import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'lobby_test.mocks.dart';
import 'tests/lobby/lobby_test_11.dart';
import 'tests/lobby/lobby_test_12.dart';

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
        'Lobby Test 11',
        (WidgetTester tester) => runLobbyTest11(tester, mockAppRepository),
      );

      testWidgets(
        'Lobby Test 12',
        (WidgetTester tester) => runLobbyTest12(tester, mockAppRepository),
      );
    },
  );
}
