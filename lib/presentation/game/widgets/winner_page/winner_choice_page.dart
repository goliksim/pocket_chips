import 'package:flutter/material.dart';

import '../../../../app/keys/keys.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/empty_asset_filter.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/player_avatar.dart';
import '../../../common/widgets/ui_widgets.dart';
import '../../../monitization/pro_version/widgets/pro_version_wrapper.dart';
import 'view_state/possible_winner_item.dart';
import 'winner_choice_view_model.dart';

class WinnerChoiceWindow extends StatelessWidget {
  final WinnerChoiceViewModel viewModel;

  const WinnerChoiceWindow({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: viewModel,
        builder: (_, __) {
          final possibleWinners = viewModel.possibleWinners;
          final markedState = viewModel.markedState;

          final potSubtitle = viewModel.isSidePot
              ? '${context.strings.game_pot_side}: ${viewModel.potValue.toSeparatedBank}'
              : '${context.strings.game_pot_main}: ${viewModel.potValue.toSeparatedBank}';
          final anteSubtitle = viewModel.anteValue > 0
              ? context.strings.game_pot_including_ante(
                  viewModel.anteValue.toSeparatedBank,
                )
              : null;
          final foldedSubtitle = viewModel.foldedValue > 0
              ? context.strings.game_pot_including_folded(
                  viewModel.foldedValue.toSeparatedBank,
                )
              : null;

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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: stdButtonWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.strings.game_win3,
                      style: TextStyle(
                        color: context.theme.onBackground,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.w500,
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
                                  child: _WinnerChoiceCard(
                                    winner: winner,
                                    onTap: viewModel.onItemTap,
                                    stateGetter: (uid) =>
                                        markedState[uid] ?? false,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset / 2),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              potSubtitle,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: context.theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: stdFontSize * 0.9,
                                height: 0,
                              ),
                            ),
                          ),
                          if (anteSubtitle != null)
                            SizedBox(
                              width: double.maxFinite,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: stdHorizontalOffset / 4,
                                ),
                                child: Text(
                                  anteSubtitle,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: context.theme.hintColor,
                                    fontSize: stdFontSize * 0.65,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          if (foldedSubtitle != null)
                            SizedBox(
                              width: double.maxFinite,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: stdHorizontalOffset / 4,
                                ),
                                child: Text(
                                  foldedSubtitle,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: context.theme.hintColor,
                                    fontSize: stdFontSize * 0.65,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: stdHorizontalOffset / 2),
                    SizedBox(
                      height: stdButtonHeight * 0.7,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: ProVersionWrapper(
                              offset: -5,
                              child: MyButton(
                                key: WinnerKeys.winnerChoiceSolverButton,
                                height: stdButtonHeight * 0.7,
                                buttonColor: context.theme.secondaryColor,
                                textString: context.strings.home_win_check,
                                action: () => viewModel.showWinnerSolver(),
                              ),
                            ),
                          ),
                          SizedBox(width: stdHorizontalOffset / 2),
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

class _WinnerChoiceCard extends StatelessWidget {
  final void Function(String uid) onTap;
  final bool Function(String uid) stateGetter;
  final PossibleWinnerItem winner;

  const _WinnerChoiceCard({
    required this.onTap,
    required this.stateGetter,
    required this.winner,
  });

  @override
  Widget build(BuildContext context) {
    final needToShowTotalBet = winner.totalBet != null && winner.totalBet! > 0;
    final needToShowAnte = winner.totalAnte != null && winner.totalAnte! > 0;

    return MyButton(
      height: stdButtonHeight,
      key: WinnerKeys.winnerChoiceItem(winner.uid),
      buttonColor: context.theme.bankColor,
      action: () => onTap(winner.uid),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: stdHorizontalOffset,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerAvatar(
              assetUrl: winner.assetUrl,
              radius: stdButtonHeight * 0.3,
              colorFilter: (winner.assetUrl == AssetsProvider.emptyPlayerAsset)
                  ? EmptyAssetFilter.filter(
                      winner.uid,
                    )
                  : null,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: stdHorizontalOffset,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'asdasdsdssdsdsdssdsds',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.theme.onBackground,
                        fontSize: stdFontSize * 0.8,
                        height: 0,
                      ),
                    ),
                    Divider(
                      height: stdHorizontalOffset,
                      color: context.theme.hintColor,
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              winner.bid.toCompactBank,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: context.theme.primaryColor,
                                fontSize: stdFontSize,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(width: stdHorizontalOffset * 2),
                          Expanded(
                            child: FittedBox(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (needToShowTotalBet)
                                    Text(
                                      '${context.strings.game_total_bet}: ${winner.totalBet!.toCompactBank}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.theme.onBackground
                                            .withAlpha(128),
                                        fontSize: stdFontSize * 0.75,
                                        fontWeight: FontWeight.w300,
                                        height: 0,
                                      ),
                                    ),
                                  if (needToShowAnte)
                                    Text(
                                      '${context.strings.sett_level_ante}: ${winner.totalAnte!.toCompactBank}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.theme.onBackground
                                            .withAlpha(128),
                                        fontSize: stdFontSize * 0.75,
                                        fontWeight: FontWeight.w300,
                                        height: 0,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.scale(
              scale: 1.25,
              child: Checkbox(
                key: WinnerKeys.winnerChoiceCheckbox(
                  winner.uid,
                ),
                activeColor: context.theme.primaryColor,
                value: stateGetter(winner.uid),
                onChanged: (bool? value) => onTap(winner.uid),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
