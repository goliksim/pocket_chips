import 'package:flutter/material.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/widgets/ui_widgets.dart';
import '../view_state/purchase_item_state.dart';
import 'donation_lead_builder.dart';

class PurchaseItemWidget extends StatelessWidget {
  final PurchaseItemState itemState;
  final VoidCallback action;

  const PurchaseItemWidget({
    required this.itemState,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: stdButtonHeight,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: MyButton(
                buttonColor: context.theme.bankColor,
                action: () => action(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: stdHorizontalOffset),
                      Expanded(
                        child: DonationLeadBuilder(item: itemState.lead),
                      ),
                      itemState.map(
                        (item) => Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontSize: stdFontSize * 0.8,
                          ),
                        ),
                        loading: (_) => SizedBox.shrink(),
                      ),
                      // PRICE BOX
                      itemState.map(
                        (item) => ColoredBox(
                          color: item.alreadyPurchased
                              ? context.theme.successColor
                              : context.theme.primaryColor,
                          child: SizedBox(
                            width: double.infinity,
                            height: stdButtonHeight * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.alreadyPurchased
                                      ? context.strings.purchase_done_text
                                      : item.priceText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: context.theme.onPrimary,
                                    fontSize: stdFontSize * 0.9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        loading: (_) => ColoredBox(
                          color: context.theme.primaryColor,
                          child: SizedBox(
                            width: double.infinity,
                            height: stdButtonHeight * 0.5,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: context.theme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
