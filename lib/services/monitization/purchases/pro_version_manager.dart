import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/pro_version_model.dart';
import 'purchases_mixin.dart';

class ProVersionManager extends AsyncNotifier<ProVersionModel>
    with PurchasesMixin {
  @override
  String get logName => 'ProVersionManager';

  @override
  ToastManager get toastManager => ref.read(toastManagerProvider);
  @override
  AppLocalizations get strings => ref.read(stringsProvider);

  @override
  List<String> get kIds => [Constants.pocketChipsPROItemKey];

  @override
  bool isConsumable(String productId) => true;

  bool proConfirmedByRestore = false;

  @override
  FutureOr<ProVersionModel> build() async {
    init();
    ref.onDispose(dispose);

    final product = (await loadPurchases())
        .firstWhere((p) => p.id == Constants.pocketChipsPROItemKey);

    return ProVersionModel(
      availableProduct: product,
      isPurchased: state.value?.isPurchased ?? false,
      forceDisable: state.value?.forceDisable ?? false,
    );
  }

  @override
  Future<void> restorePurchases() async {
    try {
      await super.restorePurchases();
    } on Exception catch (e) {
      toastManager.showToast(e.toString());

      return;
    }

    // Ждем восстановления покупок и отрубаем ПРО, если не подтвердили
    await Future.delayed(const Duration(seconds: 5)).then(
      (_) {
        if (!proConfirmedByRestore) {
          logs.writeLog('ProVersionManager: force disable');
          //Disable PRO
          state = AsyncData(
            ProVersionModel(
              forceDisable: true,
              isPurchased: false,
              availableProduct: state.value?.availableProduct,
            ),
          );
        }
      },
    );
  }

  Future<void> buyPro() async {
    restorePurchases();

    await Future.delayed(const Duration(seconds: 2));

    if (state.value?.isPurchased == true) {
      return;
    }

    final product = state.value?.availableProduct;

    if (product == null) {
      throw Exception('Product not found to buy');
    }

    return buyProduct(product.productDetails);
  }

  //Получаем обновление о покупке, применяет покупку к логике приложения.
  @override
  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Валидируем покупку
      var validPurchase = await verifyPurchase(purchaseDetails);

      if (validPurchase) {
        // Применяем покупку
        //TODO сделать модалку и повесить тесты
        proConfirmedByRestore = true;
        //Enable PRO
        state = AsyncData(
          ProVersionModel(
            isPurchased: true,
            forceDisable: false,
            availableProduct: state.value?.availableProduct,
          ),
        );

        logs.writeLog('Pro version purchased/restored');
      } else {
        //TODO Handle invalid purchase
      }
    }

    // Подтверждаем, что покупка обработана правильно.
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }
  }

  void debugDisablePro() {
    if (kDebugMode) {
      state = AsyncData(
        ProVersionModel(
          isPurchased: false,
          forceDisable: true,
          availableProduct: state.value?.availableProduct,
        ),
      );
    }
  }
}
