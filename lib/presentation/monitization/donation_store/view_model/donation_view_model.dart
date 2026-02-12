import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../di/domain_managers.dart';
import '../../../../di/model_holders.dart';
import '../../../../domain/models/purchases/purchasable_product.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/localization_extension.dart';
import '../../../../services/monitization/purchases/purchases_manager.dart';
import '../../../../services/monitization/video_ads/google_ads_manager.dart';
import '../../../../services/monitization/video_ads/models/iterstitial_ad_state.dart';
import '../../../../services/toast_manager.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/logs.dart';
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

  GoogleAdsManager get _googleAdsManager =>
      ref.read(googleAdsManagerProvider.notifier);

  @override
  FutureOr<DonationViewState> build() async {
    final videoAdState = ref.read(googleAdsManagerProvider);
    logs.writeLog('DonationVM: build $videoAdState');
    final videoAdItem = _getAdItemState(videoAdState);

    final manager = ref.read(purchasesManagerProvider);

    //Refreshing
    if (videoAdState == IterstitialAdState.unavailable) {
      _googleAdsManager.reload();
    }

    _listenPurchases(ref);
    _listenVideoAd(ref);

    return DonationViewState(
      videoAdItem: videoAdItem,
      availableItems: _getItemsFromAsync(manager),
    );
  }

  Future<void> onItemAction(PurchaseItemState product) => product.map(
        (item) async {
          switch (item.action) {
            case DonationItemAction.purchase:
              return _purchaseItem(item.id);
            case DonationItemAction.watchAd:
              return _watchVideoAd();
          }
        },
        loading: (_) async {},
      );

  Future<void> restorePurchases() async {
    try {
      await _purchasesManager.restorePurchases();
    } on Exception catch (e) {
      // TODO configure error reporting
      _toastManager.showToast(_strings.toast_unav);
      logs.writeLog(e.toString());
    }
  }

  void retry() async {
    _googleAdsManager.reload();
    _purchasesManager.runBuild();
  }

  void pop() => _navigationManager.pop();

  Future<void> _purchaseItem(String itemKey) async {
    try {
      await _purchasesManager.buyProduct(itemKey);
    } on Exception catch (e) {
      // TODO configure error reporting
      _toastManager.showToast(_strings.toast_unav);
      logs.writeLog(e.toString());
    }
  }

  Future<void> _watchVideoAd() => _googleAdsManager.showInterstitialAd(
        onAdDismissed: () {
          _toastManager.showToast(_strings.toast_video_ad_success);
        },
      );

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
        return ref
                .watch(proVersionOfferModelHolderProvider)
                .value
                ?.isPurchased ??
            false;
      default:
        return false;
    }
  }

  LoadedPurchaseItemState _buildItem(PurchasableProduct product) =>
      LoadedPurchaseItemState(
        id: product.id,
        lead: _getLeadById(product.id),
        name: _strings.getProductNameById(product.id),
        priceText: product.price,
        action: DonationItemAction.purchase,
        alreadyPurchased: _checkPurchased(product.id),
      );

  void _listenPurchases(Ref ref) => ref.listen(
        purchasesManagerProvider,
        (prev, next) {
          state = AsyncValue.data(
            DonationViewState(
              availableItems: _getItemsFromAsync(next),
              videoAdItem: state.value?.videoAdItem,
            ),
          );
        },
      );

  List<PurchaseItemState> _getItemsFromAsync(
          AsyncValue<List<PurchasableProduct>> asyncList) =>
      asyncList.when(
        data: (products) => products.map(_buildItem).toList(),
        loading: () => List<PurchaseItemState>.generate(
          5,
          (_) => PurchaseItemState.loading(),
        ),
        error: (_, __) => [],
      );

  void _listenVideoAd(Ref ref) => ref.listen(
        googleAdsManagerProvider,
        (prev, next) {
          final newVideoItem = _getAdItemState(next);

          state = AsyncValue.data(
            DonationViewState(
              availableItems: state.value?.availableItems ?? [],
              videoAdItem: newVideoItem,
            ),
          );
        },
      );

  PurchaseItemState? _getAdItemState(IterstitialAdState adState) {
    switch (adState) {
      case IterstitialAdState.loading:
        return PurchaseItemState.loading(
          id: Constants.videoAdItemKey,
        );
      case IterstitialAdState.ready:
        return LoadedPurchaseItemState(
          id: Constants.videoAdItemKey,
          lead: DonationLeadItem.videoAd(),
          name: _strings.support_video,
          priceText: _strings.support_free,
          action: DonationItemAction.watchAd,
        );
      default:
        return null;
    }
  }
}
