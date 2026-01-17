import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
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

  PurchasesManager get _purchasesManager => ref.read(purchasesManagerProvider);

  @override
  FutureOr<DonationViewState> build() async {
    void listener() {
      ref.invalidateSelf();
    }

    final manager = _purchasesManager;

    manager.addListener(listener);

    ref.onDispose(() {
      manager.removeListener(listener);
    });

    final availableItems = <PurchaseItemState>[];

    // TODO remove mock for video ad
    availableItems.add(
      PurchaseItemState(
        id: Constants.videoAdItemKey,
        lead: DonationLeadItem.videoAd(),
        name: _strings.support_video,
        priceText: _strings.support_free,
        action: DonationItemAction.watchAd,
      ),
    );

    availableItems.addAll(
      manager.products
          .map(
            (p) => PurchaseItemState(
              id: p.id,
              lead: _getLeadById(p.id),
              name: _strings.getProductNameById(p.id),
              priceText: p.price,
              action: DonationItemAction.purchase,
            ),
          )
          .toSet()
          .toList(),
    );

    return DonationViewState(availableItems: availableItems);
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
}
