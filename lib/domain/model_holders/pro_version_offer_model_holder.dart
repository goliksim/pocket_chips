import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../services/monitization/purchases/models/pro_version_offer_model.dart';
import '../../utils/logs.dart';

class ProVersionOfferModelHolder extends AsyncNotifier<ProVersionOfferModel> {
  @override
  Future<ProVersionOfferModel> build() async {
    final repository = ref.read(appRepositoryProvider);
    final isProCached = await repository.isProVersion();

    return ref.watch(proVersionManagerProvider).maybeWhen(
          data: (data) {
            logs.writeLog(
              'ProVersionModelHolder: build remotely with ${data.isPurchased}',
            );
            if (isProCached && data.forceDisable) {
              changePro(false);

              return ProVersionOfferModel(
                isPurchased: false,
                availableProduct: data.availableProduct,
              );
            }
            if (!isProCached && data.isPurchased) {
              changePro(true);
            }

            return ProVersionOfferModel(
              isPurchased: isProCached || data.isPurchased,
              availableProduct: data.availableProduct,
            );
          },
          orElse: () => ProVersionOfferModel(
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
