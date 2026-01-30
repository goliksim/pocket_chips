import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'pro_version_tests.mocks.dart';
import 'tests/pro_version_test_1.dart';
import 'tests/pro_version_test_2.dart';
import 'tests/pro_version_test_3.dart';
import 'tests/pro_version_test_4.dart';
import 'tests/pro_version_test_5.dart';
import 'tests/pro_version_test_6.dart';

@GenerateMocks([AppRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Pro Version tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Pro Version Test 1',
        (WidgetTester tester) => runProVersionTest1(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Pro Version Test 2',
        (WidgetTester tester) => runProVersionTest2(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Pro Version Test 3',
        (WidgetTester tester) => runProVersionTest3(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Pro Version Test 4',
        (WidgetTester tester) => runProVersionTest4(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Pro Version Test 5',
        (WidgetTester tester) => runProVersionTest5(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Pro Version Test 6',
        (WidgetTester tester) => runProVersionTest6(
          tester,
          mockAppRepository,
        ),
      );
    },
  );
}
