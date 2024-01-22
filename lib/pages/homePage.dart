// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_chips/data/config_model.dart';
import 'package:pocket_chips/data/logs.dart';
import 'package:pocket_chips/data/storage.dart';
import 'package:pocket_chips/internal/localization.dart';
import 'package:pocket_chips/widgets/onboading/dialogs/about.dart';
import 'package:pocket_chips/widgets/onboading/dialogs/update.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_chips/widgets/winner_check/winner_check.dart';
import '../pages/playersPage.dart' as players;
import '../data/lobby.dart';
import '../ui/transitions.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isDark}) //
      : super(key: key); // принимает значение title при обращении

  final bool isDark;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'POCKET CHIPS';

  Future<void> newGame(BuildContext context) async {
    thisLobby = Lobby(
      lobbyPlayers: [],
    );
    logs.writeLog('Switch to PlayerPage(NewGame)');
    Navigator.push(context, simpleSlidePageRoute(const players.PlayersPage()))
        .then((_) {
      logs.writeLog('Returned to HomePage');
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () async {
      final currentVersion = await thisConfig.getVersion();
      if (thisConfig.firstTime) {
        firstTime();
        thisConfig.version = currentVersion;
        configStorage.write(thisConfig);
        //TODO NULL VARIABLE
      } else if (thisConfig.version.compareTo(currentVersion) < 0) {
        updateInfo();
        thisConfig.version = currentVersion;
        configStorage.write(thisConfig);
      }
    });
  }

  void firstTime() async {
    showHelp(context, callBack, onWillpop: false);
  }

  void updateInfo() async {
    //showToast('updateInfo');
    showUpdate(context);
  }

  void callBack() {
    // print('homepage callback');
    setState(() {});
  }

  Widget homePageButtons(BuildContext context) => SizedBox(
        height: stdButtonHeight * 2 +
            stdHorizontalOffset * 2 +
            ((thisLobby.lobbyPlayers.isNotEmpty) ? (stdButtonHeight) : 0),
        child: Column(
          children: [
            if ((thisLobby.lobbyPlayers.isNotEmpty))
              //Continue
              MyButton(
                height: stdButtonHeight,
                width: double.infinity,
                borderRadius: BorderRadius.circular(stdBorderRadius),
                buttonColor: thisTheme.primaryColor,
                textString: context.locale.home_cont,
                action: () {
                  logs.writeLog('Switch to PlayerPage(Continue)');
                  Navigator.push(
                    context,
                    simpleSlidePageRoute(const players.PlayersPage()),
                  ).then((_) {
                    logs.writeLog('Returned to HomePage');
                    setState(() {});
                  }); //SlidePageRoute(direction: AxisDirection.left, child:  players.PlayersPage(), childCurrent: widget));
                },
              ),
            SizedBox(height: stdHorizontalOffset),
            //New Game
            MyButton(
              height: stdButtonHeight,
              width: double.infinity,
              borderRadius: BorderRadius.circular(stdBorderRadius),
              buttonColor: (thisLobby.lobbyPlayers.isNotEmpty)
                  ? thisTheme.secondaryColor
                  : thisTheme.primaryColor,
              textString: context.locale.home_new,
              action: () async {
                if (thisLobby.lobbyPlayers.isNotEmpty) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext thisContext) {
                      return ConfirmationWindow(
                        type: context.locale.home_new,
                        button: context.locale.home_new,
                        message:
                            '${context.locale.conf_new_text1}\n${context.locale.conf_new_text2}',
                        action: () => newGame(context),
                      );
                    },
                  );
                } else {
                  newGame(context);
                }
              },
            ),
            SizedBox(height: stdHorizontalOffset),

            Row(
              children: [
                Expanded(
                  child: MyButton(
                    height: stdButtonHeight,
                    borderRadius: BorderRadius.circular(stdBorderRadius),
                    buttonColor: thisTheme.additionButtonColor,
                    textString: context.locale.home_abo,
                    action: () async {
                      showHelp(context, callBack, onWillpop: true);
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: stdHorizontalOffset),
                    child: MyButton(
                      height: stdButtonHeight,
                      borderRadius: BorderRadius.circular(stdBorderRadius),
                      buttonColor: thisTheme.additionButtonColor,
                      textString: context.locale.home_win_check,
                      action: () async {
                        showWinChecker(context);

                        //const url = 'https://github.com/goliksim';
                        //if (!await launch(url)) throw 'Could not launch $url';
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    LocaleManager.initialize(AppLocalizations.of(context));
    return PatternContainer(
      padding: EdgeInsets.only(
        top: stdCutoutWidth * 0.75,
        bottom: stdCutoutWidthDown * 0.75,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          /*
            IconButton(
              onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyApp())),
                icon: Icon(
                  Icons.info_outline,
                  size: stdIconSize,
                ),
                tooltip: 'Help',
              ),*/

          toolbarHeight: stdButtonHeight * 0.75,
          automaticallyImplyLeading:
              false, //убрать стрелочку, так как это стартовая страница
          backgroundColor: const Color(0x00000000),
          iconTheme: IconThemeData(
            color: thisTheme.onBackground, //change your color here
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: appBarStyle().copyWith(
              fontWeight: FontWeight.w700,
              fontSize: stdFontSize / 20 * 28,
            ), // aGoogleFonts.josefinSans(color: thisTheme.onBackground, fontWeight: FontWeight.w700,fontSize: 1.2* windowTextFix(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
          ),

          actions: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: IconButton(
                //padding: EdgeInsets.only(right: 25.w),
                icon: Icon(
                  (thisTheme == themeList[0])
                      ? Icons.mode_night_outlined
                      : Icons.nightlight_round,
                  size: stdIconSize,
                ),
                tooltip: context.locale.tooltip_theme,
                onPressed: () async {
                  changeTheme();
                  Navigator.pushReplacement(
                    context,
                    simpleThemePageRoute(
                      HomePage(isDark: !widget.isDark),
                    ),
                  );
                  //setState({});
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: stdButtonWidth,
            margin: EdgeInsets.only(
              //vertical: stdEdgeOffset,
              bottom: adaptiveOffset,
              left:
                  adaptiveOffset, //  windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width),
              right: adaptiveOffset,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: chipImage(context)),
                  //кнопочки
                  homePageButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget chipImage(context) => Container(
      margin: EdgeInsets.all(stdHorizontalOffset),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            thisTheme.bgrColor.withOpacity(0.95),
            BlendMode.dstIn,
          ),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          image: const AssetImage(
            'assets/init_logo.png',
          ),
        ),
      ),
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
    );
