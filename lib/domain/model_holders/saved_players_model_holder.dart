import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../services/crash_reporting_service.dart';
import '../../utils/logs.dart';
import '../models/player/player_model.dart';

typedef SavedPlayers = List<PlayerModel>;

class SavedPlayersModelHolder extends AsyncNotifier<SavedPlayers> {
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  @override
  FutureOr<SavedPlayers> build() =>
      ref.read(appRepositoryProvider).getSavedPlayers();

  Future<void> addPlayer(PlayerModel newPlayer) async {
    await future;

    try {
      if (state.requireValue.contains(newPlayer)) {
        throw Exception('Already Saved');
      }

      await ref.read(appRepositoryProvider).addPlayer(newPlayer);

      runBuild();
    } catch (error, trace) {
      logs.writeLog('Save player error: $error');
      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'SavedPlayersModelHolder.addPlayer',
        ),
      );

      rethrow;
    }
  }

  Future<void> updatePlayer({required PlayerModel player}) async {
    try {
      await ref.read(appRepositoryProvider).updatePlayer(player);

      runBuild();
    } catch (error, trace) {
      logs.writeLog('Update saved player errro: $error');

      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'SavedPlayersModelHolder.updatePlayer',
        ),
      );
    }
  }

  Future<void> removePlayer(String playerUid) async {
    try {
      await ref.read(appRepositoryProvider).removePlayer(playerUid);

      runBuild();
    } catch (error, trace) {
      logs.writeLog('Delete saved player error: $error');
      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'SavedPlayersModelHolder.removePlayer',
        ),
      );
    }
  }
}
