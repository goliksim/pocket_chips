import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../services/monitization/purchases/models/purchasable_product.dart';
import '../../../services/monitization/purchases/purchases_manager.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/constants.dart';
import '../../../utils/logs.dart';
import '../view_state/donation_item_action.dart';
import '../view_state/donation_lead_item.dart';
import '../view_state/donation_view_state.dart';
import '../view_state/purchase_item_state.dart';

class DonationViewModel extends AsyncNotifier<DonationViewState> {
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  PurchasesManager get _purchasesManager =>
      ref.read(purchasesManagerProvider.notifier);

  @override
  FutureOr<DonationViewState> build() async {
    logs.writeLog('DonationVM: build');

    final videoMock = PurchaseItemState(
      id: Constants.videoAdItemKey,
      lead: DonationLeadItem.videoAd(),
      name: _strings.support_video,
      priceText: _strings.support_free,
      action: DonationItemAction.watchAd,
    );

    final manager = ref.read(purchasesManagerProvider);

    if (manager.value != null) {
      ref.read(purchasesManagerProvider.notifier).build();
    }

    ref.listen(
      purchasesManagerProvider,
      (prev, next) {
        next.maybeWhen(
          data: (products) {
            state = AsyncValue.data(
              DonationViewState(
                availableItems: [
                  ...state.value?.availableItems ?? [],
                  ...products.map(_buildItem).toSet(),
                ],
              ),
            );
          },
          orElse: () {},
        );
      },
    );

    return DonationViewState(
      availableItems: [
        videoMock,
        ...?manager.value?.map(_buildItem).toSet(),
      ],
    );
  }

  Future<void> onItemAction(PurchaseItemState product) => product.map(
        (item) async {
          switch (item.action) {
            case DonationItemAction.purchase:
              return purchaseItem(item.id);
            case DonationItemAction.watchAd:
              return watchVideoAd();
          }
        },
        loading: (_) async {},
      );

  Future<void> purchaseItem(String itemKey) async {
    try {
      await _purchasesManager.buyProduct(itemKey);
    } on Exception catch (e) {
      // TODO настроить репорт ошибок
      _toastManager.showToast(_strings.toast_unav);
      logs.writeLog(e.toString());
    }
  }

  void watchVideoAd() {
    // TODO implement watch ad logic
    _toastManager.showToast(_strings.toast_unav);
  }

  Future<void> restorePurchases() async {
    try {
      await _purchasesManager.restorePurchases();
    } on Exception catch (e) {
      // TODO настроить репорт ошибок
      _toastManager.showToast(_strings.toast_unav);
      logs.writeLog(e.toString());
    }
  }

  void pop() => _navigationManager.pop();

  DonationLeadItem _getLeadById(String id) {
    switch (id) {
      case 'pocket_chips_pro':
        return DonationLeadItem.pro();
      case 'huge_donat':
        return DonationLeadItem.chips(chipsValue: 5000);
      case 'nice_donat':
        return DonationLeadItem.chips(chipsValue: 500);
      case 'modest_donat':
        return DonationLeadItem.chips(chipsValue: 50);

      default:
        return DonationLeadItem.loading();
    }
  }

  bool _checkPurchased(String id) {
    switch (id) {
      case Constants.pocketChipsPROItemKey:
        return ref.watch(proVersionModelHolderProvider).value ?? false;
      default:
        return false;
    }
  }

  PurchaseItemState _buildItem(PurchasableProduct product) => PurchaseItemState(
        id: product.id,
        lead: _getLeadById(product.id),
        name: _strings.getProductNameById(product.id),
        priceText: product.price,
        action: DonationItemAction.purchase,
        alreadyPurchased: _checkPurchased(product.id),
      );
}
