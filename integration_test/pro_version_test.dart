import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'pro_version_test.mocks.dart';
import 'tests/pro_version/pro_version_test_1.dart';
import 'tests/pro_version/pro_version_test_2.dart';
import 'tests/pro_version/pro_version_test_3.dart';
import 'tests/pro_version/pro_version_test_4.dart';
import 'tests/pro_version/pro_version_test_5.dart';
import 'tests/pro_version/pro_version_test_6.dart';
import 'tests/pro_version/pro_version_test_7.dart';
import 'tests/pro_version/pro_version_test_8.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Pro Version tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Pro Version Test 1',
        ($) => runProVersionTest1(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 2',
        ($) => runProVersionTest2(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 3',
        ($) => runProVersionTest3(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 4',
        ($) => runProVersionTest4(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 5',
        ($) => runProVersionTest5(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 6',
        ($) => runProVersionTest6(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 7',
        ($) => runProVersionTest7(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Pro Version Test 8',
        ($) => runProVersionTest8(
          $,
          mockAppRepository,
        ),
      );
    },
  );
}
