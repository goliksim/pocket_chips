import 'package:flutter/material.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
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

          return Dialog(
            elevation: 0,
            backgroundColor: thisTheme.bgrColor,
            insetPadding: EdgeInsets.symmetric(
              horizontal: adaptiveOffset,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
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
                  stdHorizontalOffset,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: stdButtonHeight * 0.5,
                    child: Center(
                      child: Text(
                        title ?? context.strings.game_win3,
                        style: TextStyle(
                          color: thisTheme.onBackground,
                          fontSize: stdFontSize,
                        ),
                      ),
                    ),
                  ),
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
                                  height: stdButtonHeight * 0.75 +
                                      stdHorizontalOffset / 2,
                                  buttonColor: thisTheme.bankColor,
                                  action: () => viewModel.onItemTap(winner.uid),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: stdHorizontalOffset,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: stdButtonHeight * 0.75 * 0.8,
                                          height: stdButtonHeight * 0.75 * 0.8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              filterQuality: FilterQuality.high,
                                              image: AssetImage(
                                                winner.assetUrl,
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
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
                                                  style: TextStyle(
                                                    color:
                                                        thisTheme.onBackground,
                                                    fontSize:
                                                        stdFontSize * 0.75,
                                                  ),
                                                ),
                                                Text(
                                                  '${context.strings.game_bet}: ${winner.bid}',
                                                  style: TextStyle(
                                                    color:
                                                        thisTheme.onBackground,
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
                                          child: Checkbox(
                                            activeColor: thisTheme.primaryColor,
                                            value: markedState[winner.uid],
                                            onChanged: (bool? value) =>
                                                viewModel.onItemTap(winner.uid),
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
                    height: stdButtonHeight * 0.75 * 0.75,
                    child: Row(
                      children: [
                        MyButton(
                          height: stdButtonHeight * 0.75 * 0.75,
                          width: stdButtonHeight * 0.75 * 0.75,
                          buttonColor: thisTheme.secondaryColor,
                          child: Icon(
                            Icons.help_outline,
                            color: thisTheme.onPrimary,
                          ),
                          action: () => viewModel.showWinnerSolver(),
                        ),
                        SizedBox(width: stdHorizontalOffset),
                        Expanded(
                          child: MyButton(
                            height: stdButtonHeight * 0.75 * 0.75,
                            width: double.infinity,
                            buttonColor: thisTheme.primaryColor,
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
          );
        },
      );
}
