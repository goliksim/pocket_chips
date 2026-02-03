import 'package:flutter/material.dart';

import '../../app/keys/keys.dart';
import '../../domain/models/game_settings_model.dart';
import '../../services/toast_manager.dart';
import '../../utils/extensions.dart';
import '../../utils/logs.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/ui_widgets.dart';
import 'view_model/game_settings_view_model.dart';

class GameSettingsDialog extends StatefulWidget {
  final GameSettingsViewModel viewModel;

  const GameSettingsDialog({
    required this.viewModel,
    super.key,
  });

  @override
  State<GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<GameSettingsDialog>
    with ToastsMixin {
  int? tmpBank;
  int? smallBlind;
  //bool useAutoIncrease = fulse;
  //bool useAnte = false;
  //bool autoIncreaseEveryLap = false;
  //double autoIncreaseMultiplier = 0;
  int anteBlind = 0;
  //int firstLap = 0;
  //int autoTime = 0;
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _sbController = TextEditingController();
  //final TextEditingController _anteBlindController = TextEditingController();
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;

  final _formKey = GlobalKey<FormState>();

  var msgController = TextEditingController();

  GameSettingsModelArgs get state => widget.viewModel.state;

  @override
  void initState() {
    super.initState();
    logs.writeLog('Settings is opened');
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    //useAnte = widget.thisLobby.lobbyAnteBool;
    //useAutoIncrease = widget.thisLobby.lobbyAutoBool;

    //anteBlind = widget.thisLobby.lobbyAnte;
    //firstLap = widget.thisLobby.lobbyFirstAnte;

    //autoIncreaseMultiplier = widget.thisLobby.lobbyFactor;
    //autoTime = widget.thisLobby.lobbyAutoTime;
    //autoIncreaseEveryLap = widget.thisLobby.lobbyEveryLapBool;
  }

  void _onBankChanged(String value) {
    _checkController(_bankController);
    final text = _bankController.text;
    if (text.isEmpty) {
      tmpBank = null;
    } else {
      int parsedValue = int.parse(text);
      if (parsedValue < 1) {
        _bankController.value = _bankController.value.copyWith(text: '1');
        tmpBank = 1;
        showToast(context.strings.toast_bank3);
      } else {
        tmpBank = parsedValue;
      }
    }
    setState(() {});
  }

  void _smallBlindChanged(String value) {
    _checkController(_sbController);
    if (_sbController.text.isEmpty) {
      _sbController.clear();
      smallBlind = null;
      //smallBlind= widget.bank;
    } else {
      final parsedValue = int.parse(_sbController.text);

      if (parsedValue < 1) {
        _sbController.value = _sbController.value.copyWith(text: '1');
        smallBlind = 1;
        showToast(context.strings.toast_bank5);
      } else {
        smallBlind = parsedValue;
      }

      setState(() {});
      //autoIntBlind = smallBlind * 2;
    }
  }

  void _checkController(TextEditingController controller) {
    final text = controller.text;
    final filteredText = RegExp(r'(\d+)').stringMatch(text) ?? '';
    if (text != filteredText) {
      controller.value = controller.value.copyWith(
        text: filteredText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: filteredText.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
        key: CommonKeys.settingsDialog,
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: AnimatedContainer(
          width: stdButtonWidth,
          padding: EdgeInsets.all(
            stdHorizontalOffset,
          ),
          duration: Duration(milliseconds: 200),
          //Duration(milliseconds: (useAutoIncrease || useAnte) ? 100 : 200),
          height: stdDialogHeight * 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tittle
              SizedBox(
                height: stdButtonHeight * 0.5,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      context.strings.sett_title,
                      style: TextStyle(
                        color: context.theme.onBackground,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Bank
              if (state.canEditStack)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: stdHorizontalOffset,
                  ),
                  height: stdHeight * 0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.strings.sett_win1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          color: context.theme.onBackground,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: stdHorizontalOffset),
                      Expanded(
                        child: Container(
                          height: stdButtonHeight / 2,
                          alignment: Alignment.centerRight,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              focusNode: focusNode1,
                              controller: _bankController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: context.theme.onBackground,
                                fontSize: stdFontSize,
                              ),
                              maxLength: 8,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: stdFontSize,
                                  color: context.theme.hintColor,
                                ),
                                hintText: '${state.startingStack}',
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: _onBankChanged,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Small Blind
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: stdHorizontalOffset,
                ),
                height: stdHeight * 0.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.strings.sett_win2,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        color: context.theme.onBackground,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: stdHorizontalOffset),
                    Expanded(
                      child: SizedBox(
                        height: stdButtonHeight / 2,
                        child: TextFormField(
                          focusNode: focusNode2,
                          controller: _sbController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontSize: stdFontSize,
                          ),
                          maxLength: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: stdFontSize,
                              color: context.theme.hintColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                            hintText: state.smallBlind.toString(),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            counterText: '',
                          ),
                          onChanged: _smallBlindChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Big Blind
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: stdHorizontalOffset,
                ),
                height: stdHeight * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.strings.sett_win3,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        color: context.theme.hintColor,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: stdHorizontalOffset),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${(smallBlind ?? state.smallBlind) * 2}',
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.theme.hintColor,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Auto Rise
              /*SizedBox(

                //color: Colors.red,
                height: stdHeight * 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Text('Auto Rise',
                          style: TextStyle(
                              color: context.theme.textColor,
                              fontSize: stdFontSize * 0.8,
                              fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: stdHeight * 0.8,
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(useAutoIncrease
                              ? context.theme.primaryColor
                              : context.theme.bankColor),
                          value: useAutoIncrease,
                          onChanged: (bool? value) {
                            setState(() {
                              useAutoIncrease = value!;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                )),
            // Ante
            ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(0),
                elevation: 0,
                expansionCallback: (i, autolind) {
                  setState(() {
                    useAnte = !useAnte;
                  });
                },
                children: [
                  ExpansionPanel(
                    //hasIcon: false,
                    canTapOnHeader: false,
                    isExpanded: useAnte,
                    backgroundColor: context.theme.bgrColor,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Column(
                        children: [
                          SizedBox(

                              //color: Colors.red,
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (useAnte)
                                    const Expanded(flex: 3, child: SizedBox()),
                                  Flexible(
                                    flex: useAnte ? 8 : 7,
                                    child: Text('Ante',
                                        style: TextStyle(
                                            color: context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: useAnte ? 3 : 2,
                                    child: SizedBox(
                                      height: stdHeight * 0.75,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                useAnte
                                                    ? context.theme.primaryColor
                                                    : context.theme.bankColor),
                                        value: useAnte,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            anteBlind = !(3*smallBlind>tmpBank)? smallBlind :0;
                                            _anteBlindController.clear();

                                            useAnte = value!;
                                            
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          SizedBox(
                            //width: double.infinity,
                            height: 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              //margin: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
                              color: context.theme.textColor,
                              width: useAnte ? 250 : 0,
                              height: 1,
                            ),
                          ),
                        ],
                      );
                    },
                    body: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: stdEdgeOffset / 3),
                      padding:
                          const EdgeInsets.only(left: stdEdgeOffset),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text('1st value',
                                        style: TextStyle(
                                            color: context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  const Flexible(flex: 3, child: SizedBox()),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                        focusNode: focusNode3,
                                        controller: _anteBlindController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: context.theme.textColor,
                                          fontSize: stdFontSize * 0.8,
                                        ),
                                        maxLength: 5,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: stdFontSize * 0.8,
                                              color: context.theme.bankColor,
                                            ),
                                            hintText: "$anteBlind",
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            counterText: ''),
                                        //initialValue: newName,
                                        onChanged: (String value) async {
                                          _checkInt(_anteBlindController);
                                          if (_anteBlindController.text == "") {
                                            _anteBlindController.clear();
                                            anteBlind = (!(3*smallBlind>tmpBank))? smallBlind :0; 
                                            //smallBlind= widget.bank;
                                          } else {
                                              if ((int.parse(
                                                  _anteBlindController.text)+smallBlind*2 >
                                              tmpBank ~/ 2) && ( int.parse(
                                                  _anteBlindController.text) + 0 > tmpBank~/2))  
                                                  {
                                            _anteBlindController.value =
                                                _anteBlindController.value
                                                    .copyWith(
                                              text: "${(tmpBank-smallBlind*2)}",
                                              selection: TextSelection.fromPosition(
              TextPosition(offset: "${(tmpBank-smallBlind*2)}".length),
            )
                                            );
                                            
                                            //print("first");
                                            anteBlind = (tmpBank-smallBlind*2);

                                            await toastWarning(
                                                "Ante + Big Blind <= Bank");
                                                  } 
                                                  else if (smallBlind * 2 >
                                              (tmpBank -
                                                  int.parse(_anteBlindController
                                                      .text))) {
                                            anteBlind = int.parse(
                                                _anteBlindController.text);
                                            smallBlind =
                                                (tmpBank - anteBlind) ~/ 2;
                                            _smallBlindController.value =
                                                _smallBlindController.value
                                                    .copyWith(
                                              text:
                                                  "${(tmpBank - anteBlind) ~/ 2}",
                                              );

                                            await toastWarning(
                                                "Ante + Big Blind <= Bank");

                                            } else {
                                              anteBlind = int.parse(value);
                                            }
                                      
                                            
                                          }                        
                                          setState(() {});
                                          //autoIntBlind = smallBlind * 2;
                                        }),
                                  ),
                                ],
                              )),
                          Container(
              padding: const EdgeInsets.only(right: stdEdgeOffset),
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text('1st lap',
                                        style: TextStyle(
                                            color: context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: NumberPicker(
                                          haptics: true,
                                          selectedTextStyle: TextStyle(
                                              color: context.theme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: context.theme.bankColor,
                                              fontSize: stdFontSize * 0.7,
                                              fontWeight: FontWeight.normal),
                                          itemWidth: stdHeight,
                                          value: firstLap,
                                          axis: Axis.horizontal,
                                          itemCount: 3,
                                          minValue: 1,
                                          maxValue: 25,
                                          onChanged: (value) {
                                            setState(() {
                                              firstLap = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ]),
            
            // Offset
            const SizedBox(),
            // Time manager
            ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(0),
                elevation: 0,
                expansionCallback: (i, useAutoIncrease) {
                  setState(() {
                    useAutoIncrease = !useAutoIncrease;
                  });
                },
                children: [
                  ExpansionPanel(
                    //hasIcon: false,
                    canTapOnHeader: false,
                    isExpanded: (useAutoIncrease || useAnte),
                    backgroundColor: context.theme.bgrColor,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const SizedBox(height: 0,);
                    },
                    body: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: stdEdgeOffset / 3),
                      padding:
                          const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: stdHeight * 0.5,
                            child: Center(
                              child: Text("Time Manager",
                                  style: TextStyle(
                                      color: context.theme.textColor,
                                      fontSize: stdFontSize * 0.85,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          SizedBox(
                            //width: double.infinity,
                            height: 1,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds:useAnte? 400: 200),
                              //margin: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
                              color: context.theme.textColor,
                              width: (useAutoIncrease || useAnte) ? 250 : 0,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text('Factor',
                                        style: TextStyle(
                                            color: context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: NumberPickerDouble(
                                          dimension: "x",
                                          haptics: true,
                                          //zeroPad: true,
                                          selectedTextStyle: TextStyle(
                                              color: context.theme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: context.theme.bankColor,
                                              fontSize: stdFontSize * 0.7,
                                              fontWeight: FontWeight.normal),
                                          itemWidth: stdHeight,
                                          //itemHeight: stdFontSize * 0.85,
                                          value: autoIncreaseMultiplier,
                                          axis: Axis.horizontal,
                                          itemCount: 3,
                                          step: 0.5,
                                          minValue: 1.0,
                                          maxValue: 4.0,
                                          onChanged: (value) {
                                            setState(() {
                                              autoIncreaseMultiplier = value; //value;
                                              
                                            });
                                          }),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              )),
                          SizedBox(
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text('Period',
                                        style: TextStyle(
                                            color: autoIncreaseEveryLap
                                                ? context.theme.bankColor
                                                : context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: NumberPicker(
                                          scrollable: !autoIncreaseEveryLap,
                                          haptics: true,
                                          selectedTextStyle: TextStyle(
                                              color: autoIncreaseEveryLap
                                                  ? context.theme.bankColor
                                                  : context.theme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: context.theme.bankColor,
                                              fontSize: stdFontSize * 0.7,
                                              fontWeight: FontWeight.normal),
                                          itemWidth: stdHeight,
                                          value: autoTime,
                                          axis: Axis.horizontal,
                                          itemCount: 3,
                                          step: 5,
                                          minValue: 5,
                                          maxValue: 60,
                                          onChanged: (value) {
                                            setState(() {
                                              autoTime = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('min',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: autoIncreaseEveryLap
                                                ? context.theme.bankColor
                                                : context.theme.textColor,
                                            fontSize: stdFontSize * 0.85,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                ],
                              )),
                          SizedBox(

                              //color: Colors.red,
                              height: stdHeight * 0.75,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 7,
                                    child: Text('Every Lap',
                                        style: TextStyle(
                                            color: context.theme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: stdHeight * 0.75,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                autoIncreaseEveryLap
                                                    ? context.theme.primaryColor
                                                    : context.theme.bankColor),
                                        value: autoIncreaseEveryLap,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            autoIncreaseEveryLap = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ]),
                */
              // Save Button
              MyButton(
                height: stdButtonHeight * 0.75,
                width: double.infinity,
                buttonColor: context.theme.primaryColor,
                textString: context.strings.sett_conf,
                action: () async {
                  if ((focusNode1.hasFocus) || (focusNode2.hasFocus)) {
                    focusNode1.unfocus();
                    focusNode2.unfocus();
                  }

                  //widget.thisLobby.lobbyAutoBool = useAutoIncrease;
                  //widget.thisLobby.lobbyAnteBool = useAnte;

                  //widget.thisLobby.lobbyAnte= useAnte? anteBlind: 0;
                  //widget.thisLobby.lobbyFirstAnte = firstLap;

                  //widget.thisLobby.lobbyFactor = autoIncreaseMultiplier;
                  //widget.thisLobby.lobbyAutoTime = autoTime;
                  //widget.thisLobby.lobbyEveryLapBool = autoIncreaseEveryLap;

                  final newSettings = GameSettingsModelResult(
                    startingStack: tmpBank,
                    smallBlind: smallBlind,
                  );

                  logs.writeLog('GameSettings: save $newSettings');
                  widget.viewModel.saveSettings(newSettings);
                },
              ),
            ],
          ),
        ),
      );
}
