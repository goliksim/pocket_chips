import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'monitization_tests.mocks.dart';
import 'tests/monitization/monitization_test_1.dart';
import 'tests/monitization/monitization_test_2.dart';
import 'tests/monitization/monitization_test_3.dart';
import 'tests/monitization/monitization_test_4.dart';
import 'tests/monitization/monitization_test_5.dart';

@GenerateMocks([AppRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Monitization tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      testWidgets(
        'Monitization Test 1',
        (WidgetTester tester) => runMonitizationTest1(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Monitization Test 2',
        (WidgetTester tester) => runMonitizationTest2(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Monitization Test 3',
        (WidgetTester tester) => runMonitizationTest3(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Monitization Test 4',
        (WidgetTester tester) => runMonitizationTest4(
          tester,
          mockAppRepository,
        ),
      );

      testWidgets(
        'Monitization Test 5',
        (WidgetTester tester) => runMonitizationTest5(
          tester,
          mockAppRepository,
        ),
      );
    },
  );
}
