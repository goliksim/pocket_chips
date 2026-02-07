import 'package:flutter/material.dart';

import '../../../../app/keys/keys.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/empty_asset_filter.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/player_avatar.dart';
import '../../../common/widgets/ui_widgets.dart';
import 'view_state/possible_winner_item.dart';
import 'winner_choice_view_model.dart';

class WinnerChoiceWindow extends StatelessWidget {
  final WinnerChoiceViewModel viewModel;
  final String? title;

  const WinnerChoiceWindow({
    required this.viewModel,
    this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: viewModel,
        builder: (_, __) {
          final possibleWinners = viewModel.possibleWinners;
          final markedState = viewModel.markedState;

          return PopScope(
            canPop: false,
            child: Dialog(
              key: WinnerKeys.winnerChoiceDialog,
              elevation: 0,
              backgroundColor: context.theme.bgrColor,
              insetPadding: EdgeInsets.symmetric(
                horizontal: adaptiveOffset,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(stdBorderRadius)),
              ),
              child: Container(
                padding: EdgeInsets.all(
                  stdHorizontalOffset,
                ),
                width: stdButtonWidth,
                height: (stdButtonHeight * 0.75 + stdHorizontalOffset / 2) *
                        (((possibleWinners.length > standartPlayerCount)
                            ? standartPlayerCount
                            : possibleWinners.length)) +
                    stdButtonHeight * 1.5 +
                    stdHorizontalOffset * 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: stdButtonHeight * 0.5,
                      child: FittedBox(
                        child: Text(
                          title ?? context.strings.game_win3,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontSize: stdFontSize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: stdHorizontalOffset / 2),
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(stdBorderRadius),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              for (PossibleWinnerItem winner in possibleWinners)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: stdHorizontalOffset / 2,
                                  ),
                                  child: MyButton(
                                    key:
                                        WinnerKeys.winnerChoiceItem(winner.uid),
                                    height: stdButtonHeight * 0.75 +
                                        stdHorizontalOffset / 2,
                                    buttonColor: context.theme.bankColor,
                                    action: () =>
                                        viewModel.onItemTap(winner.uid),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: stdHorizontalOffset,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PlayerAvatar(
                                            assetUrl: winner.assetUrl,
                                            radius: stdButtonHeight * 0.3,
                                            colorFilter: (winner.assetUrl ==
                                                    AssetsProvider
                                                        .emptyPlayerAsset)
                                                ? EmptyAssetFilter(winner.uid)
                                                : null,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    winner.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: context
                                                          .theme.onBackground,
                                                      fontSize:
                                                          stdFontSize * 0.75,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${context.strings.game_bet}: ${winner.bid.toSeparatedBank}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: context
                                                          .theme.onBackground,
                                                      fontSize:
                                                          stdFontSize * 0.75,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Transform.scale(
                                              scale: 1.25,
                                              child: Checkbox(
                                                key: WinnerKeys
                                                    .winnerChoiceCheckbox(
                                                  winner.uid,
                                                ),
                                                activeColor:
                                                    context.theme.primaryColor,
                                                value: markedState[winner.uid],
                                                onChanged: (bool? value) =>
                                                    viewModel
                                                        .onItemTap(winner.uid),
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
                        ),
                      ),
                    ),
                    SizedBox(height: stdHorizontalOffset),
                    SizedBox(
                      height: stdButtonHeight * 0.7,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: MyButton(
                              key: WinnerKeys.winnerChoiceSolverButton,
                              height: stdButtonHeight * 0.7,
                              buttonColor: context.theme.secondaryColor,
                              textString: context.strings.home_win_check,
                              action: () => viewModel.showWinnerSolver(),
                            ),
                          ),
                          SizedBox(width: stdHorizontalOffset),
                          Expanded(
                            flex: 5,
                            child: MyButton(
                              key: WinnerKeys.winnerChoiceConfirmButton,
                              height: stdButtonHeight * 0.7,
                              width: double.infinity,
                              buttonColor: context.theme.primaryColor,
                              textString: context.strings.game_win_conf,
                              action: () => viewModel.confirmChoice(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
