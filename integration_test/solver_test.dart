import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'solver_test.mocks.dart';
import 'tests/solver/solver_test_1.dart';
import 'tests/solver/solver_test_2.dart';

@GenerateMocks([AppRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Solver tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Solver Test 1',
        (WidgetTester tester) => runSolverTest1(tester, mockAppRepository),
      );

      testWidgets(
        'Solver Test 2',
        (WidgetTester tester) => runSolverTest2(tester, mockAppRepository),
      );
    },
  );
}
