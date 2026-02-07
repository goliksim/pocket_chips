import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../../lobby_test.mocks.dart';
import '../../mocks/lobby_state_holder_mock.dart';
import '../../mocks/purchases_repository_mock.dart';

ConfigModel defaultConfig() => ConfigModel(
      isDark: false,
      firstLaunch: false,
      locale: 'en',
      version: '2.0.0',
    );

List<PlayerModel> buildPlayers(
  int count, {
  int startIndex = 0,
  String namePrefix = 'name',
}) =>
    List.generate(
      count,
      (index) => PlayerModel(
        uid: 'test_uid_${startIndex + index}',
        name: '${namePrefix}_${startIndex + index}',
        assetUrl: AssetsProvider.emptyPlayerAsset,
      ),
    );

LobbyStateModel buildLobbyState({
  required List<PlayerModel> players,
  int bank = defaultLobbyBank,
  int smallBlind = defaultSmallBlindValue,
  String? dealerId,
}) =>
    LobbyStateModel(
      players: players,
      banks: {for (var player in players) player.uid: bank},
      smallBlindValue: smallBlind,
      defaultBank: bank,
      dealerId: dealerId,
    );

Future<void> pumpLobbyApp({
  required WidgetTester tester,
  required MockAppRepository repository,
  required LobbyStateModel lobbyState,
  required List<PlayerModel> savedPlayers,
}) async {
  final mock = repository as dynamic;

  when(mock.getConfig()).thenAnswer((_) async => defaultConfig());
  when(mock.isProVersion()).thenAnswer((_) async => true);
  when(mock.getSavedPlayers()).thenAnswer(
    (_) async => List<PlayerModel>.from(savedPlayers),
  );
  when(mock.updateLobbyState(any)).thenAnswer((_) async {});
  when(mock.updateGameSessionState(any)).thenAnswer((_) async {});
  when(mock.changeProVersion(any)).thenAnswer((_) async {});
  when(mock.getGameSessionState()).thenAnswer((_) async => null);

  when(mock.addPlayer(any)).thenAnswer((invocation) async {
    final player = invocation.positionalArguments.first as PlayerModel;
    savedPlayers.add(player);
  });
  when(mock.removePlayer(any)).thenAnswer((invocation) async {
    final uid = invocation.positionalArguments.first as String;
    savedPlayers.removeWhere((player) => player.uid == uid);
  });
  when(mock.updatePlayer(any)).thenAnswer(
    (invocation) async {
      final player = invocation.positionalArguments.first as PlayerModel;
      final index = savedPlayers.indexWhere((p) => p.uid == player.uid);
      if (index != -1) {
        savedPlayers[index] = player;
      }
    },
  );

  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.success);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        lobbyStateHolderProvider.overrideWith(
          () => MockLobbyStateHolder(initialState: lobbyState),
        ),
        proVersionRepositoryProvider.overrideWithValue(mockPurchasesRepository),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();
}
