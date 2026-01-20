import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../services/monitization/purchases/models/pro_version_model.dart';
import '../../utils/logs.dart';

//TODO Сделать новую доменную модельку (без forceDisable)
class ProVersionModelHolder extends AsyncNotifier<ProVersionModel> {
  @override
  Future<ProVersionModel> build() async {
    final repository = ref.read(appRepositoryProvider);
    final isProCached = await repository.isProVersion();

    final isProRemote = ref.watch(proVersionManagerProvider);

    return isProRemote.maybeWhen(
      data: (data) {
        logs.writeLog(
            'ProVersionModelHolder: build remotely with ${data.isPurchased}');
        if (isProCached && data.forceDisable) {
          changePro(false);

          return ProVersionModel(
            isPurchased: false,
            availableProduct: data.availableProduct,
          );
        }
        if (!isProCached && data.isPurchased) {
          changePro(true);
        }

        return ProVersionModel(
          isPurchased: isProCached || data.isPurchased,
          availableProduct: data.availableProduct,
        );
      },
      orElse: () => ProVersionModel(
        isPurchased: isProCached,
      ),
    );
  }

  Future<void> changePro(bool isPro) async {
    logs.writeLog('ProVersionModelHolder: changePro to $isPro');

    final repository = ref.read(appRepositoryProvider);

    return repository.changeProVersion(isPro);
  }
}
