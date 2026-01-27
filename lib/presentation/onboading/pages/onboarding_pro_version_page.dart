import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../di/view_models.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import '../../monitization/pro_version/view_state/pro_version_offer_view_state.dart';
import '../onboarding_dialog.dart';

class OnboardingProVersionPage extends ConsumerWidget {
  final bool isDialog;

  const OnboardingProVersionPage({
    this.isDialog = false,
    super.key,
  });

  @override
  Widget build(context, ref) {
    final viewModel = ref.read(proVersionOfferViewModelProvider.notifier);
    final state = ref.watch(proVersionOfferViewModelProvider);

    return Column(
      children: [
        Expanded(
          child: OnboardingPage(
            title: "POCKET CHIPS PRO",
            children: [
              Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      color: context.theme.primaryColor,
                      size: stdIconSize * 2,
                    ),
                  ),
                  Text(
                    context.strings.pro_version_offer_title,
                    style: TextStyle(
                      height: 1.25,
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: stdFontSize * 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              state.map(
                loading: (_) => SizedBox.shrink(),
                (data) => data.alreadyPurchased
                    ? Padding(
                        padding:
                            EdgeInsets.only(top: stdHorizontalOffset * 3 / 2),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            context.strings.pro_version_offer_options_available,
                            style: TextStyle(
                              height: 0,
                              color: context.theme.onBackground,
                              fontWeight: FontWeight.w500,
                              fontSize: stdFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : data.priceText != null
                        ? Padding(
                            padding:
                                EdgeInsets.all(stdHorizontalOffset * 3 / 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data.priceText!,
                                  style: TextStyle(
                                    height: 0,
                                    color: context.theme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: stdFontSize * 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: stdHorizontalOffset),
                                Text(
                                  context
                                      .strings.pro_version_offer_price_duration,
                                  style: TextStyle(
                                    height: 1.8,
                                    color: context.theme.onBackground,
                                    fontWeight: FontWeight.w500,
                                    fontSize: stdFontSize * 0.7,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
              ),
              Divider(),
              ...[
                context.strings.pro_version_offer_option_2,
                context.strings.pro_version_offer_option_5,
                context.strings.pro_version_offer_option_3,
                context.strings.pro_version_offer_option_1,
                context.strings.pro_version_offer_option_7,
                context.strings.pro_version_offer_option_6,
                context.strings.pro_version_offer_option_4,
              ].map(
                (text) => Padding(
                  padding: EdgeInsets.only(bottom: stdHorizontalOffset / 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "- $text",
                      style: TextStyle(
                        height: 1.5,
                        color: context.theme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: stdFontSize * 0.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: stdHorizontalOffset / 2,
            right: stdHorizontalOffset / 2,
            top: stdHorizontalOffset,
          ),
          child: state.map(
            (data) => data.alreadyPurchased
                ? MyButton(
                    height: stdHeight,
                    buttonColor: context.theme.hintColor,
                    textString:
                        context.strings.pro_version_offer_button_purchased,
                    action: () => ref
                        .read(proVersionManagerProvider.notifier)
                        .debugDisablePro(),
                  )
                : data.isAvailable
                    ? MyButton(
                        height: stdHeight,
                        buttonColor: context.theme.primaryColor,
                        textString: context
                            .strings.pro_version_offer_button_not_purchased,
                        action: () => viewModel.purchasePro(),
                      )
                    : MyButton(
                        height: stdHeight,
                        buttonColor: context.theme.hintColor,
                        textString: context
                            .strings.pro_version_offer_button_not_available,
                      ),
            loading: (_) => SizedBox(
              height: stdButtonHeight,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        if (isDialog) ...[
          SizedBox(height: stdHorizontalOffset),
          MyButton(
            side: BorderSide(
              width: 2.5,
              color: context.theme.hintColor,
            ),
            height: stdHeight,
            buttonColor: context.theme.bgrColor,
            textString: context.strings.support_close,
            textStyle: context.theme.stdTextStyle.copyWith(
              color: context.theme.hintColor,
              fontSize: stdFontSize,
            ),
            action: () => viewModel.pop(),
          )
        ]
      ],
    );
  }
}
