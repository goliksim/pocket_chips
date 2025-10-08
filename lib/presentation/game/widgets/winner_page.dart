import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/game_logic.dart';
import '../../../domain/models/lobby.dart';
import '../../../l10n/localization.dart';
import '../../../utils/logs.dart';
import '../../../utils/theme/uiValues.dart';
import '../../common/transitions.dart';
import '../../common/widgets/ui_widgets.dart';
import '../../winner_check/winner_check.dart';

Future<void> showWinner(BuildContext context) async {
  late BuildContext dialogContext;
  showGeneralDialog(
    transitionDuration: const Duration(milliseconds: 500),
    context: context,
    pageBuilder: (context, a1, a2) {
      dialogContext = context;
      return WinnerWindow(
        winner: thisLobby.lobbyPlayers[
            thisLobby.lobbyPlayers.indexWhere((e) => e.isActive == true)],
      );
    },
    transitionBuilder: getTransition('Scale1'),
  );
  await Future.delayed(const Duration(seconds: 3)).then((_) {
    Navigator.pop(dialogContext);
    thisLobby
            .lobbyPlayers[
                thisLobby.lobbyPlayers.indexWhere((e) => e.isActive == true)]
            .bank +=
        thisLobby.lobbyPlayers.map((e) => e.bid).reduce((a, b) => a + b);
    thisGame.newLap(folded: true);
  });
}

class WinnerWindow extends StatefulWidget {
  const WinnerWindow({super.key, required this.winner});

  final Player winner;
  @override
  State<WinnerWindow> createState() => _WinnerWindowState();
}

class _WinnerWindowState extends State<WinnerWindow> {
  String bgrText = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      bgrText += '${LocaleManager.locale.game_win1}\u00A0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: [
          (MediaQuery.of(context).size.width - stdButtonHeight * 4) / 2,
          adaptiveOffset,
        ].reduce(max),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
      ),
      child: SizedBox(
        height: stdButtonHeight * 4,
        width: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(left: stdHorizontalOffset / 4),
                height: stdButtonHeight * 3,
                width: stdButtonHeight * 4,
                child: Text(
                  bgrText,
                  overflow: TextOverflow.fade,
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: thisTheme.bankColor.withAlpha(128),
                    fontWeight: FontWeight.w700,
                    fontSize: stdFontSize * 2,
                  ),
                ),
              ),
              Positioned(
                top: stdButtonHeight / 8,
                child: Container(
                  height: stdButtonHeight * 3,
                  width: stdButtonHeight * 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      filterQuality: FilterQuality.high,
                      image: AssetImage(
                        widget.winner.assetUrl,
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: stdButtonHeight,
                  width: stdButtonHeight * 4,
                  alignment: Alignment.center,
                  child: Text(
                    '${thisLobby.lobbyPlayers[thisLobby.lobbyPlayers.indexWhere((e) => e.isActive == true)].name} ${context.locale.game_win2}',
                    style: TextStyle(
                      color: thisTheme.primaryColor,
                      fontSize: stdFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WinnerChooseWindow extends StatefulWidget {
  const WinnerChooseWindow({
    required this.thisLobby,
    this.title,
    super.key,
  }); // принимает значение title при обращении
  final Lobby thisLobby;
  final String? title;
  @override
  State<WinnerChooseWindow> createState() => _WinnerChooseWindowState();
}

class _WinnerChooseWindowState extends State<WinnerChooseWindow> {
  List<int> maybewinners = [];
  List<bool> winners = [];
  late final String title;

  @override
  void initState() {
    super.initState();
    title = widget.title ?? LocaleManager.locale.game_win3;
    logs.writeLog('${widget.title} window');
    for (int i = 0; i < thisLobby.lobbyPlayers.length; i++) {
      if (thisLobby.lobbyPlayers[i].isActive) {
        maybewinners.add(i);
      }
      winners.add(false);
    }
    logs.writeLog(
        "Still Active players: ${thisLobby.lobbyPlayers.where((e) => e.isActive == true).map(
              (e) => [e.name, e.bid],
            ).join(' / ')}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
        //vertical: stdHorizontalOffset,
        horizontal: adaptiveOffset,
      ), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
      ),
      child: Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: (stdButtonHeight * 0.75 + stdHorizontalOffset / 2) *
                (((maybewinners.length > standartPlayerCount)
                    ? standartPlayerCount
                    : maybewinners.length)) +
            stdButtonHeight * 1.5 +
            stdHorizontalOffset,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: Text(
                  title,
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
                      for (int i in maybewinners)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: stdHorizontalOffset / 2,
                          ),
                          child: MyButton(
                            height: stdButtonHeight * 0.75 +
                                stdHorizontalOffset / 2,
                            buttonColor: thisTheme.bankColor,
                            action: () {
                              winners[i] = !winners[i];
                              setState(() {});
                            },
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
                                          thisLobby.lobbyPlayers[i].assetUrl,
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
                                            thisLobby.lobbyPlayers[i].name,
                                            style: TextStyle(
                                              color: thisTheme.onBackground,
                                              fontSize: stdFontSize * 0.75,
                                            ),
                                          ),
                                          Text(
                                            '${context.locale.game_bet}: ${thisLobby.lobbyPlayers[i].bid}',
                                            style: TextStyle(
                                              color: thisTheme.onBackground,
                                              fontSize: stdFontSize * 0.75,
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
                                      value: winners[i],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          winners[i] = value!;
                                        });
                                      },
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
                    action: () async {
                      showWinChecker(context);
                    },
                  ),
                  SizedBox(width: stdHorizontalOffset),
                  Expanded(
                    child: MyButton(
                      height: stdButtonHeight * 0.75 * 0.75,
                      width: double.infinity,
                      buttonColor: thisTheme.primaryColor,
                      textString: context.locale.game_win_conf,
                      action: () {
                        if (winners.where((e) => e == true).isNotEmpty) {
                          moneyDistribution(winners, context);
                        } else {
                          showToast(context.locale.toast_winn);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future moneyDistribution(List<bool> winners, BuildContext context) async {
    int deletedWinners = 0;
    //множество ставок
    List<int> bids = thisLobby.lobbyPlayers.map((e) => e.bid).toSet().toList();
    bids.sort();
    if (bids[0] == 0) bids.removeAt(0);
    //проходимся по каждому разному значения ставок
    logs.writeLog('Bids - $bids');

    for (int k = 0; k < bids.length; k++) {
      int bid = bids[k];
      if (bid <= 0) continue;

      logs.writeLog('Winners - $winners');
      //pr("New cycle");
      if ((winners.where((e) => e == true).isEmpty) &&
          (thisLobby.lobbyPlayers.where((e) => e.isActive == true).length >
              1)) {
        //pr("Window");

        await transitionDialog(
          barrierDismissible: false,
          duration: const Duration(milliseconds: 400),
          type: 'Scale1',
          context: context,
          child: WinnerChooseWindow(
            thisLobby: thisLobby,
            title: context.locale.game_win4,
          ),
          builder: (BuildContext context) {
            return WinnerChooseWindow(
              thisLobby: thisLobby,
              title: context.locale.game_win4,
            );
          },
        ).then((_) => Navigator.pop(context));

        return 0;
      }

      //pr("Bid - $bid");
      // та сумма которая будет распределяться по победителям для данной ставки
      int tmpSum = 0;
      //проходимся по ставкам
      for (int i = 0; i < thisLobby.lobbyPlayers.length; i++) {
        //проверяем, ставил ли кто-то из победителей и не из победителей данную ставку
        //если челик такую ставку поставил
        if (thisLobby.lobbyPlayers[i].bid >= bid) {
          //если не победитель, то вносим ее в общий банк
          if (!winners[i]) {
            tmpSum += bid;
          } else {
            thisLobby.lobbyPlayers[i].bank += bid;
          }
        }
      }

      //pr("Сумма для дележки $tmpSum");
      //разделенная добыча делится на победителей, причем тока тех, кто еще в игре
      logs.writeLog('Devide on ${winners.where((e) => e == true).length}');

      //заканчиваем цикл если остаток остался, а челиксы закончились
      if (winners.where((e) => e == true).isEmpty) {
        Navigator.pop(context);
        for (int i = 0; i < winners.length; i++) {
          thisLobby.lobbyPlayers[i].bank += (thisLobby.lobbyPlayers[i].bid > 0)
              ? thisLobby.lobbyPlayers[i].bid
              : 0;
        }
        return 0;
      }

      for (int i = 0; i < winners.length; i++) {
        if ((winners[i]) && (thisLobby.lobbyPlayers[i].bid > 0)) {
          thisLobby.lobbyPlayers[i].bank +=
              tmpSum ~/ (winners.where((e) => e == true).length);
          logs.writeLog(
            'For ${thisLobby.lobbyPlayers[i].name} - ${thisLobby.lobbyPlayers[i].bank}',
          );
        }
      }
      for (int m = 0; m < bids.length; m++) {
        bids[m] -= bid;
      }
      logs.writeLog('Bids - $bids');

      for (int i = 0; i < winners.length; i++) {
        if (thisLobby.lobbyPlayers[i].bid == bid) {
          winners[i] = false;
          thisLobby.lobbyPlayers[i].isActive = false;
        }
        thisLobby.lobbyPlayers[i].bid -= bid;
      }
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    return deletedWinners;
  }
}
