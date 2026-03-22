import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'initialization_test.mocks.dart';
import 'tests/initialization/initialization_test_1.dart';
import 'tests/initialization/initialization_test_2.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Initialization tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Initialization Test 1',
        ($) => runInitialization1(
          $,
          mockAppRepository,
        ),
      );

      patrolTest(
        'Initialization Test 2',
        ($) => runInitialization2(
          $,
          mockAppRepository,
        ),
      );
    },
  );
}
