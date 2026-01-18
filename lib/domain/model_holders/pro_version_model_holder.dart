import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../utils/logs.dart';

class ProVersionModelHolder extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final repository = ref.read(appRepositoryProvider);
    final isPro = await repository.isProVersion();

    ref.read(proVersionManagerProvider).addListener(
      () {
        logs.writeLog('ProVersionModelHolder: listen to isProEnabled change');
        final next = ref.read(proVersionManagerProvider).isProEnabled;

        if (next != null && next != state.value) {
          changePro(next);
        }
      },
    );

    if (!isPro) {
      ref.read(proVersionManagerProvider).restorePurchases();
    }

    logs.writeLog('ProVersionModelHolder: build with $isPro');
    return isPro;
  }

  Future<void> changePro(bool isPro) async {
    logs.writeLog('ProVersionModelHolder: changePro to $isPro');

    final repository = ref.read(appRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await repository.changeProVersion(isPro);

        return isPro;
      },
    );
  }
}
