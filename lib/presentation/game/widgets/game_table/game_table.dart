import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/keys/keys.dart';
import '../../../../domain/models/lobby/lobby_state_model.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../monitization/pro_version/widgets/pro_version_wrapper.dart';
import '../../view_model/game_page_view_model.dart';
import '../add_player_button.dart';
import 'cards/table_cards.dart';
import 'player_field.dart';

class GameTable extends StatelessWidget {
  final GamePageViewModel viewModel;
  final int tableRotationOffset;

  const GameTable({
    required this.viewModel,
    this.tableRotationOffset = 0,
    super.key,
  });

  double _playerXCoords(
    double height,
    double width,
    int index,
    int totalAmount,
  ) {
    final x0 = width / 2;
    final x = -height / 3.3 * _getSin(index, totalAmount, multiply: -0.1);

    return x0 + x;
  }

  double _playerYCoords(
    double height,
    int index,
    int totalAmount,
  ) {
    final y0 = height / 2;
    final y = height / 2 * _getCos(index, totalAmount);

    return y0 + y * 0.9;
  }

  double _beyXCoords(
    double height,
    double width,
    int index,
    int totalAmount,
  ) {
    final x0 = width / 2;
    final x = -height / 3.3 * _getSin(index, totalAmount, multiply: -0.1);

    return x0 + x;
  }

  double _betYCoords(
    double height,
    int index,
    int totalAmount,
  ) {
    final y0 = height / 2;
    final y = height / 2 * _getCos(index, totalAmount);

    return y0 + y * 0.9;
  }

  double _getCos(int index, int totalAmount) {
    double randomOffset = 0;
    // thisLobby.lobbyRandomOffset[index] / thisLobby.lobbyPlayers.length;
    return cos(2 * pi * (index / totalAmount)) *
        pow((cos(2 * pi * (index / totalAmount) + randomOffset)).abs(), 0.3);
  }

  double _getSin(int index, int totalAmount, {double multiply = 0}) {
    double randomOffset = 0;
    // thisLobby.lobbyRandomOffset[a]/thisLobby.lobbyPlayers.length*2;
    return sin(2 * pi * (index / totalAmount) + randomOffset) *
        pow(
          sin(2 * pi * (index / totalAmount) + 0.01 + randomOffset).abs(),
          multiply,
        );
  }

  @override
  Widget build(BuildContext context) {
    final viewState = viewModel.viewState;
    final tableState = viewState.tableState;
    final players = tableState.players;

    bool showAddButton = (players.length >= maxPlayerCount ? false : true);
    final addButtonOffset = showAddButton ? 1 : 0;
    final totalElementCount = players.length + addButtonOffset;

    final bets = players.map<int>((e) => e.bet).sum;
    final antes = players.map<int>((e) => e.ante).sum;

    return LayoutBuilder(
      builder: (context, contrains) {
        double height = contrains.maxHeight;
        double width = contrains.maxWidth;

        final int tableHeight = (height * 0.9).toInt();
        final int cardsHeight = (height / 4).toInt();
        final double betHeight = height * 0.04;

        final double playerHeight = height * 0.085;
        final double playerWidth = height / 5;

        final borderRadius = betHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Table
            Positioned(
              child: Center(
                child: SizedBox(
                  height: tableHeight.toDouble(),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor.withAlpha(
                        context.theme.name == 'light' ? 20 : 20,
                      ),
                      BlendMode.srcATop,
                    ),
                    child: Image(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      image: AssetsProvider.table(context.theme.isDark),
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: context.theme.secondaryColor.withAlpha(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Pre-flop 3 cards
            Positioned(
              top: height * 0.5 - (cardsHeight) / 2,
              child: SizedBox(
                height: cardsHeight.toDouble(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TableCards.firstRow(
                        stateEnum: viewState.gameStatus,
                      ),
                    ),
                    SizedBox(height: height / 100),
                    Expanded(
                      child: TableCards.secondRow(
                        stateEnum: viewState.gameStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Total bets
            Positioned(
              top: height * 0.7,
              child: SizedBox(
                height: height / 20,
                child: FittedBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: borderRadius / 4),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Center(
                      child: Text(
                        bets.toSeparatedBank,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Ante bets
            if (antes != 0)
              Positioned(
                top: height * 0.7 + height / 20 + stdHorizontalOffset / 2,
                child: SizedBox(
                  height: height / 25,
                  child: FittedBox(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: borderRadius / 4),
                      decoration: BoxDecoration(
                        color: context.theme.playerColor,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: Center(
                        child: Text(
                          antes.toSeparatedBank,
                          style: TextStyle(
                            color: context.theme.onBackground.withAlpha(200),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Iteration throw players
            ...List.generate(totalElementCount, (index) => index).expand(
              (int index) {
                final finalIndex =
                    (index - addButtonOffset - tableRotationOffset) %
                        players.length;
                final player = players[finalIndex];

                final yCoord = _playerYCoords(height, index, totalElementCount);
                final xCoord =
                    _playerXCoords(height, width, index, totalElementCount);

                final xCoordClamp = clampDouble(
                    xCoord - playerWidth / 2, 0, width - playerWidth);

                final reversePlayer = xCoordClamp <= width / 2;

                final yBetCoord = _betYCoords(height, index, totalElementCount);
                final xBetCoord =
                    _beyXCoords(height, width, index, totalElementCount);
                final xBetCoordClamp = clampDouble(
                    xBetCoord - playerWidth / 2, 0, width - playerWidth);

                final reverseBet = yCoord <= height * 0.7;

                return [
                  // Players cards
                  Positioned(
                    top: yCoord - playerHeight / 2,
                    left: xCoordClamp,
                    child: SizedBox(
                      height: playerHeight,
                      width: playerWidth,
                      child: (index == 0) && showAddButton
                          ? viewModel.viewState.canEditPlayer
                              ? Center(
                                  child: ProVersionWrapper(
                                    offset: -5.w,
                                    conditionToEnable:
                                        players.length < noProPlayerCount,
                                    child: AddPlayerButton(
                                      addPlayerCallback: () =>
                                          viewModel.openPlayerEditor(null),
                                      openPlayersListCallback: () =>
                                          viewModel.showSavedPlayers(),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(playerWidth / 2),
                              child: PlayerField(
                                player: player,
                                shouldReverse: reversePlayer,
                                onLongPress: () =>
                                    viewModel.toggleSitOut(player.uid),
                              ),
                            ),
                    ),
                  ),
                  // Players bets
                  if ((player.bet != 0) && (!showAddButton || index != 0))
                    Positioned(
                      top: yBetCoord -
                          betHeight / 2 +
                          playerHeight * (reverseBet ? 0.8 : -0.8),
                      left: xBetCoordClamp,
                      child: SizedBox(
                        height: betHeight,
                        width: playerWidth,
                        child: _BetWidget(
                          key: GameTableKeys.playerBet(player.name, player.bet),
                          borderRadius: borderRadius,
                          bet: player.bet,
                        ),
                      ),
                    ),
                ];
              },
            )
          ],
        );
      },
    );
  }
}

class _BetWidget extends StatelessWidget {
  final double borderRadius;
  final int bet;

  const _BetWidget({
    required this.borderRadius,
    required this.bet,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FittedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: context.theme.playerColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Text(
            bet.toSeparatedBank,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.theme.onBackground.withAlpha(200),
            ),
          ),
        ),
      );
}
