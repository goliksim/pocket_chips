import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';

import '../../mocks/lobby_state_holder_mock.dart';
import '../../mocks/purchases_repository_mock.dart';
import '../../solver_tests.mocks.dart';

ConfigModel defaultConfig() => ConfigModel(
      isDark: false,
      firstLaunch: false,
      locale: 'en',
      version: '2.0.0',
    );

Future<void> pumpHomeApp({
  required WidgetTester tester,
  required MockAppRepository repository,
}) async {
  final mock = repository as dynamic;

  when(mock.getConfig()).thenAnswer((_) async => defaultConfig());
  when(mock.isProVersion()).thenAnswer((_) async => true);
  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.success);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        lobbyStateHolderProvider.overrideWith(
          () => MockLobbyStateHolder(initialState: LobbyStateModel.empty()),
        ),
        proVersionRepository.overrideWithValue(mockPurchasesRepository),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();
}
