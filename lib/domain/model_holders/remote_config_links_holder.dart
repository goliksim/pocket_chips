import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/repositories.dart';
import '../models/remote_config_links.dart';

class RemoteConfigLinksHolder extends AsyncNotifier<RemoteConfigLinks> {
  @override
  FutureOr<RemoteConfigLinks> build() async {
    final repository = ref.read(remoteConfigRepositoryProvider);
    await repository.initialize();
    return repository.fetchLinks();
  }

  Future<void> refresh() async {
    await ref.read(remoteConfigRepositoryProvider).initialize();
    state = const AsyncValue.loading();
    final links = await ref.read(remoteConfigRepositoryProvider).fetchLinks();
    state = AsyncValue.data(links);
  }
}
