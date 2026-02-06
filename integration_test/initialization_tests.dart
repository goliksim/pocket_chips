import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'initialization_tests.mocks.dart';
import 'tests/initialization/initialization_test_1.dart';
import 'tests/initialization/initialization_test_2.dart';

@GenerateMocks([AppRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Initialization tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Initialization Test 1',
        (WidgetTester tester) => runInitialization1(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Initialization Test 2',
        (WidgetTester tester) => runInitialization2(
          tester,
          mockAppRepository,
        ),
      );
    },
  );
}
