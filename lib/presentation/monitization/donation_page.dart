import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/dialog_widget.dart';
import '../common/widgets/ui_widgets.dart';
import 'view_state/purchase_item_state.dart';
import 'widgets/purchase_item_widget.dart';

class DonateWindow extends ConsumerStatefulWidget {
  final bool onWillPop;

  const DonateWindow({
    this.onWillPop = false,
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
        List.generate(10, (_) => PurchaseItemState.loading());
    var storeProducts = <PurchaseItemState>[];

    viewState.maybeWhen(
      data: (data) {
        storeProducts = data.availableItems;
      },
      orElse: () {
        storeProducts = placeholderProducts;
      },
      skipLoadingOnReload: true,
    );

    return DialogWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                context.strings.support_tittle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize,
                ),
              ),
            ],
          ),
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
          SizedBox(height: stdHorizontalOffset),
          MyButton(
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
            textString: context.strings.purchases_restore_button,
            action: () => viewModel.restorePurchases(),
          ),
        ],
      ),
    );
  }
}
