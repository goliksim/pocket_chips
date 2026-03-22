import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/keys/keys.dart';
import '../../../di/view_models.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/dialog_widget.dart';
import '../../common/widgets/ui_widgets.dart';
import 'view_state/purchase_item_state.dart';
import 'widgets/purchase_item_widget.dart';

class DonateWindow extends ConsumerStatefulWidget {
  final bool isTriggered;

  const DonateWindow({
    this.isTriggered = false,
    super.key,
  });

  @override
  ConsumerState<DonateWindow> createState() => _DonateWindowState();
}

class _DonateWindowState extends ConsumerState<DonateWindow> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(donationViewModelProvider.notifier);
    final viewState = ref.watch(donationViewModelProvider);

    // Placeholder loading items
    final placeholderProducts =
        List.generate(6, (_) => PurchaseItemState.loading());
    var storeProducts = <PurchaseItemState>[];

    viewState.when(
      data: (data) {
        storeProducts = [
          if (data.videoAdItem != null) data.videoAdItem!,
          ...data.availableItems
        ];
      },
      loading: () {
        storeProducts = placeholderProducts;
      },
      error: (_, __) {
        storeProducts = [];
      },
      skipLoadingOnReload: true,
    );

    return DialogWidget(
      key: DonationKeys.dialog,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                widget.isTriggered
                    ? context.strings.support_tittle_triggered
                    : context.strings.support_tittle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize,
                ),
              ),
            ],
          ),
          if (storeProducts.isEmpty)
            Center(
              key: DonationKeys.itemsUnavailable,
              child: Column(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: context.theme.alertColor,
                    size: stdIconSize * 3,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    context.strings.support_methods_unavailable,
                    style: TextStyle(
                      color: context.theme.onBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: stdFontSize,
                    ),
                  ),
                  SizedBox(height: stdHorizontalOffset),
                  MyButton(
                    key: DonationKeys.retryButton,
                    height: stdButtonHeight * 0.5,
                    width: stdButtonWidth / 2,
                    buttonColor: context.theme.secondaryColor,
                    textString:
                        context.strings.support_methods_unavailable_retry,
                    action: () => viewModel.retry(),
                  )
                ],
              ),
            )
          else
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(vertical: stdHorizontalOffset),
                crossAxisCount: 2,
                crossAxisSpacing: stdHorizontalOffset,
                mainAxisSpacing: stdHorizontalOffset,
                childAspectRatio: 1,
                children: [
                  ...storeProducts.map(
                    (product) => PurchaseItemWidget(
                      itemState: product,
                      action: () => viewModel.onItemAction(product),
                    ),
                  ),
                ],
              ),
            ),
          MyButton(
            key: DonationKeys.restoreButton,
            side: BorderSide(
              width: 1.5,
              color: context.theme.secondaryColor.withAlpha(150),
            ),
            height: stdButtonHeight * 0.5,
            width: double.infinity,
            borderRadius: BorderRadius.circular(stdBorderRadius),
            textStyle: context.theme.stdTextStyle.copyWith(
              color: context.theme.secondaryColor.withAlpha(150),
              fontSize: stdFontSize * 0.8,
            ),
            buttonColor: context.theme.bgrColor,
            textString: widget.isTriggered
                ? context.strings.support_close
                : context.strings.purchases_restore_button,
            action: widget.isTriggered
                ? () => viewModel.pop()
                : () => viewModel.restorePurchases(),
          ),
        ],
      ),
    );
  }
}
