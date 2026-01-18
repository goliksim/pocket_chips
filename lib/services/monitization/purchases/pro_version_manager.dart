import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../../toast_manager.dart';
import 'models/purchasable_product.dart';
import 'models/store_status.dart';

class ProVersionManager with ChangeNotifier {
  final ToastManager _toastManager;
  final AppLocalizations _strings;

  StoreState storeState = StoreState.loading;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];

  bool proConfirmedByRestore = false;
  bool? isProEnabled;

  Future<void> restorePurchases() async {
    logs.writeLog('ProVersionManager: restore purchases');

    await InAppPurchase.instance.restorePurchases();

    // Ждем восстановления покупок и отрубаем ПРО, если не подтвердили
    await Future.delayed(const Duration(seconds: 5)).then(
      (_) {
        if (!proConfirmedByRestore) {
          //Disable PRO
          isProEnabled = false;
          notifyListeners();
        }
      },
    );
  }

  ProVersionManager({
    required ToastManager toastManager,
    required AppLocalizations strings,
  })  : _toastManager = toastManager,
        _strings = strings {
    _purchaseListening();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  //Listening to purchase updates
  void _purchaseListening() {
    final purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    //iapRepo.addListener(purchasesUpdate);
  }

  //Получаем обновления о покупках
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == Constants.pocketChipsPROItemKey) {
        await _handlePurchase(purchaseDetails);
      }
    }
    notifyListeners();
  }

  //Получаем обновление о покупке, применяет покупку к логике приложения.
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Валидируем покупку
      var validPurchase = await _verifyPurchase(purchaseDetails);

      if (validPurchase) {
        // Применяем покупку
        //TODO сделать модалку и повесить тесты
        proConfirmedByRestore = true;
        //Enable PRO
        isProEnabled = true;

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

  // TODO verify with backend
  // https://github.com/flutter/codelabs/blob/main/in_app_purchases/complete/app/lib/logic/dash_purchases.dart#L116
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async => true;

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    logs.writeLog('Purchase stream error: $error');
    _toastManager.showToast(_strings.toast_purchases_updating_error);
  }
}
