import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'monitization_test.mocks.dart';
import 'tests/monitization/monitization_test_1.dart';
import 'tests/monitization/monitization_test_2.dart';
import 'tests/monitization/monitization_test_3.dart';
import 'tests/monitization/monitization_test_4.dart';
import 'tests/monitization/monitization_test_5.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Monitization tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Monitization Test 1',
        ($) => runMonitizationTest1(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Monitization Test 2',
        ($) => runMonitizationTest2(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Monitization Test 3',
        ($) => runMonitizationTest3(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Monitization Test 4',
        ($) => runMonitizationTest4(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Monitization Test 5',
        ($) => runMonitizationTest5(
          $,
          mockAppRepository,
        ),
      );
    },
  );
}
