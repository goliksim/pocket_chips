import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import 'solver_test.mocks.dart';
import 'tests/solver/solver_test_1.dart';
import 'tests/solver/solver_test_2.dart';

@GenerateMocks([AppRepository])
void main() {
  group(
    'Solver tests',
    () {
      late MockAppRepository mockAppRepository;

      setUp(() {
        mockAppRepository = MockAppRepository();
      });

      patrolTest(
        'Solver Test 1',
        ($) => runSolverTest1($, mockAppRepository),
      );

      patrolTest(
        'Solver Test 2',
        ($) => runSolverTest2($, mockAppRepository),
      );
    },
  );
}
