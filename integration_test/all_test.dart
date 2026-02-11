import 'package:flutter_test/flutter_test.dart';

import 'game_test.dart' as game_test;
import 'initialization_test.dart' as initialization_test;
import 'lobby_test.dart' as lobby_test;
import 'monitization_test.dart' as monitization_test;
import 'navigation_test.dart' as navigation_test;
import 'pro_version_test.dart' as pro_version_test;
import 'solver_test.dart' as solver_test;

void main() {
  group('game_test', game_test.main);
  group('initialization_test', initialization_test.main);
  group('lobby_test', lobby_test.main);
  group('monitization_test', monitization_test.main);
  group('navigation_test', navigation_test.main);
  group('pro_version_test', pro_version_test.main);
  group('solver_test', solver_test.main);
}
