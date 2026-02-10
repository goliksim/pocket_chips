import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../app/keys/keys.dart';
import '../../../../domain/models/lobby/lobby_state_model.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
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

  double _playerLeftOffset(
    double tableButtonWidth,
    int index,
    int totalAmount,
  ) =>
      adaptiveOffset +
      tableButtonWidth / 3 -
      (stdButtonHeight * 1.7 * _getSin(index, totalAmount, multiply: -0.5));

  double _playerBottomOffset(
    int index,
    int totalAmount,
    double tableHeight,
  ) =>
      tableHeight / 3.8 - 2.9 * stdButtonHeight * _getCos(index, totalAmount);

  double _chipBottomOffset(
    int index,
    int totalAmount,
  ) =>
      -2.9 * stdButtonHeight * _getCos(index, totalAmount) +
      3.1 * stdButtonHeight -
      (_getCos(index, totalAmount) > 0.01
          ? -stdButtonHeight * 0.5
          : stdButtonHeight * 0.5);

  double _chipsLeftOffset(
    double tableButtonWidth,
    int a,
    int addButton,
  ) =>
      adaptiveOffset +
      (tableButtonWidth) / 3.6 -
      (stdButtonHeight * 1.3 * _getSin(a, addButton, multiply: -1));

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
    final playersOffset = showAddButton ? 1 : 0;
    final totalElementCount = players.length + playersOffset;

    final bets = players.map((e) => e.bet).whereType<int>();
    final totalBets = bets.sum;

    double tableButtonWidth =
        MediaQuery.of(context).size.width - adaptiveOffset;
    double tableHeight = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        // Table
        Padding(
          padding: EdgeInsets.only(
            top: stdButtonHeight / 3,
            bottom: stdButtonHeight / 3,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              context.theme.primaryColor.withAlpha(
                context.theme.name == 'light' ? 20 : 0,
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

        // Pre-flop 3 cards
        Positioned(
          bottom: tableHeight * 0.295,
          child: TableCards.firstRow(
            stateEnum: viewState.gameStatus,
          ),
        ),
        // Turn and River cards
        Positioned(
          bottom: tableHeight * 0.220,
          child: TableCards.secondRow(
            stateEnum: viewState.gameStatus,
          ),
        ),
        // Small/Big Blinds
        Positioned(
          bottom: tableHeight * 0.155,
          child: Text(
            key: GameKeys.blinds(tableState.smallBlindValue),
            '${tableState.smallBlindValue.toSeparated} / ${(tableState.smallBlindValue * 2).toSeparated}',
            style: TextStyle(
              color: context.theme.onBackground.withAlpha(200),
              fontSize: stdFontSize * 0.6,
            ),
          ),
        ),
        // Total bets
        Positioned(
          bottom: tableHeight * 0.125,
          child: FittedBox(
            child: Container(
              height: stdHeight / 2.5,
              padding: EdgeInsets.symmetric(
                horizontal: stdHorizontalOffset / 2,
              ),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(
                  stdBorderRadius,
                ),
              ),
              child: Center(
                child: Text(
                  totalBets.toSeparatedBank,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: stdFontSize * 0.75,
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
                (index - playersOffset - tableRotationOffset) % players.length;
            final player = players[finalIndex];

            return [
              // Players cards
              Positioned(
                bottom: _playerBottomOffset(
                  index,
                  totalElementCount,
                  tableHeight,
                ),
                left: _playerLeftOffset(
                  tableButtonWidth,
                  index,
                  totalElementCount,
                ),
                child: ((index == 0) && showAddButton)
                    ? AddPlayerButton(
                        canEditPlayers: viewModel.viewState.canEditPlayer,
                        addPlayerCallback: () =>
                            viewModel.openPlayerEditor(null),
                        openPlayersListCallback: () =>
                            viewModel.showSavedPlayers(),
                      )
                    : PlayerField(
                        player: player,
                        shouldReverse: sin(
                              2 *
                                  pi *
                                  (index / (players.length - playersOffset)),
                            ) <
                            0,
                      ),
              ),
              // Players bets
              if ((player.bet != 0) && (!showAddButton || index != 0))
                Positioned(
                  bottom: _chipBottomOffset(index, totalElementCount),
                  left: _chipsLeftOffset(
                    tableButtonWidth,
                    index,
                    totalElementCount,
                  ),
                  child: _BetWidget(
                    key: GameTableKeys.playerBet(player.name, player.bet),
                    bet: player.bet,
                  ),
                ),
            ];
          },
        )
      ],
    );
  }
}

class _BetWidget extends StatelessWidget {
  final int bet;

  const _BetWidget({
    required this.bet,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FittedBox(
        child: Container(
          width: stdHeight * 3,
          alignment: Alignment.center,
          child: Container(
            height: stdHeight / 2.5,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: context.theme.playerColor,
              borderRadius: BorderRadius.circular(stdBorderRadius),
            ),
            child: Text(
              bet.toSeparatedBank,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.onBackground.withAlpha(200),
                fontSize: stdFontSize * 0.75,
              ),
            ),
          ),
        ),
      );
}
