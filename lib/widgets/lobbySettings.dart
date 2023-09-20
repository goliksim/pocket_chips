// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/lobby.dart';
import '../data/storage.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';

class AddSettings extends StatefulWidget {
  const AddSettings({Key? key, required this.thisLobby, required this.bankUpdate})
      : super(key: key);
  final Lobby thisLobby;
  final void Function(int) bankUpdate;
  @override
  State<AddSettings> createState() => _AddSettingsState();
}

class _AddSettingsState extends State<AddSettings> {
  int tmpBank = 0; // временный банк
  int smallBlind = 0; // малый блайнд
  bool autoBool = false; // галочка автоповышения
  bool anteBool = false; // галочка анте
  bool everyLapBool = false;
  double autoDoubleFactor = 0;
  int anteBlind = 0;
  int firstLap = 0;
  int autoTime = 0;
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _smallBlindController = TextEditingController();
  //final TextEditingController _anteBlindController = TextEditingController();
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  
  final _formKey = GlobalKey<FormState>();

  
  var msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset),//windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: _settingsWindow(),
    );
  }

  @override
  void initState() {
    // загрузка игроков с прошлого раза
    super.initState();
    logs.writeLog('Settings is opened');
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    tmpBank = -1* widget.thisLobby.lobbyBank;
    smallBlind = widget.thisLobby.lobbySmallBlind;

    anteBool = widget.thisLobby.lobbyAnteBool;
    //autoBool = widget.thisLobby.lobbyAutoBool;

    anteBlind =  widget.thisLobby.lobbyAnte;
    //firstLap = widget.thisLobby.lobbyFirstAnte;

    //autoDoubleFactor = widget.thisLobby.lobbyFactor;
    //autoTime = widget.thisLobby.lobbyAutoTime;
    //everyLapBool = widget.thisLobby.lobbyEveryLapBool;
    
  }

  Widget _settingsWindow() => AnimatedContainer(
        width: stdButtonWidth,
        //width: double.infinity,
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        duration: Duration(milliseconds: (autoBool || anteBool)? 100: 200),
        // Не удалять
        height: stdDialogHeight*1.5,//stdDialogHeight + ((autoBool || anteBool) ? 7.5 : 5.5) * stdHeight + 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tittle
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: FittedBox(
                  child: Text('sett.title'.tr(),
                      style: TextStyle(
                          color: thisTheme.onBackground,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            // Offset
            
            // Bank
            if(!thisLobby.lobbyIsActive || thisLobby.lobbyState == 5) Container(
                padding: EdgeInsets.symmetric(
                  horizontal:stdHorizontalOffset,
                ),
                //color: Colors.red,
                height: stdHeight * 0.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      
                        child: Text('sett.win1'.tr(),
                         overflow: TextOverflow.fade,
                        softWrap: false,
                            style: TextStyle(
                                color: thisTheme.onBackground,
                                fontSize: stdFontSize,
                                fontWeight: FontWeight.normal)),
                      ),
                    
                    
                    Container(
                      width: stdButtonHeight,
                      height: stdButtonHeight/2,
                      alignment: Alignment.centerLeft,
                      child: Focus(
                        focusNode: focusNode1,
                        onFocusChange: (hasFocus) async {
                          if (!hasFocus) {
                            if (_bankController.text == "") {
                              _bankController.clear();
                              tmpBank = widget.thisLobby.lobbyBank;
                            } else if (int.parse(_bankController.text) < 1) {
                              _bankController.value =
                                  _bankController.value.copyWith(
                                text: "1",
                              );
                              tmpBank = 1;
                              showToast("toast.bank3".tr());
                            }
                            tmpBank = int.parse(_bankController.text);
                            if (smallBlind > tmpBank ~/ 2) {
                              /*
                              smallBlind = tmpBank ~/ 2;
                              _smallBlindController.value =
                                  _smallBlindController.value.copyWith(
                                text: "$smallBlind",
                              );
                              */
                              showToast(
                                  "toast.bank4".tr());
                            }
                            setState(() {});
                          }
                        },
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                              controller: _bankController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: thisTheme.onBackground,
                                fontSize: stdFontSize ,
                              ),
                              maxLength: 5,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: stdFontSize ,
                                    color: thisTheme.bankColor,
                                  ),
                                  hintText: "${widget.thisLobby.lobbyBank}",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  counterText: ''),
                              //initialValue: newName,
                              onChanged: (String value) {
                                _checkInt(_bankController);
                                //tmpBank = (value != '')? int.parse(_bankController.text): widget.bank;
                              }),
                        ),
                      ),
                    )
                    
                  ],
                )),
            // Small Blind
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal:stdHorizontalOffset,
                ),
                //color: Colors.red,
                height: stdHeight * 0.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      
                      child: Text('sett.win2'.tr(),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                          style: TextStyle(
                              color: thisTheme.onBackground,
                              fontSize: stdFontSize,
                              fontWeight: FontWeight.normal)),
                    ),
                    
                    SizedBox(
                      width: stdButtonHeight,
                      height: stdButtonHeight/2,
                      child: TextFormField(
                          focusNode: focusNode2,
                          controller: _smallBlindController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: thisTheme.onBackground,
                            fontSize: stdFontSize ,
                          ),
                          maxLength: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: stdFontSize ,
                                color: thisTheme.bankColor,
                              ),
                              hintText: "$smallBlind",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) async {
                            _checkInt(_smallBlindController);
                            if (_smallBlindController.text == "") {
                              _smallBlindController.clear();
                              //smallBlind= widget.bank;
                            } else if ((int.parse(_smallBlindController.text)) >
                                (tmpBank.abs() - anteBlind) ~/ 2) {
                                  /*
                              _smallBlindController.value =
                                  _smallBlindController.value.copyWith(
                                text: "${tmpBank.abs() ~/ 2}",
                                selection: TextSelection.fromPosition(
              TextPosition(offset: "${tmpBank.abs() ~/ 2}".length)),
                              );
                              //print("first");
                              smallBlind = tmpBank.abs() ~/ 2;
                              anteBlind = tmpBank.abs() - smallBlind * 2;
                              (anteBlind != 0)
                                  ? _anteBlindController.value =
                                      _anteBlindController.value.copyWith(
                                      text: "${tmpBank.abs() - smallBlind * 2}",
                                    )
                                  : _anteBlindController.clear();
                              
                              */
                                showToast("We recommend a Big Blind value less than Stack");
                              
                               //"Ante + Big Blind <= Bank");
                            }
                            if(_smallBlindController.text=='0'){
                              _smallBlindController.value =
                                  _smallBlindController.value.copyWith(
                                text: "1",
                              );
                              smallBlind = 1;
                              showToast("The Small Blind cannot be zero");
                            }
                            smallBlind = (_smallBlindController.text != '')
                                ? int.parse(_smallBlindController.text)
                                : thisLobby.lobbySmallBlind;
                            setState(() {});
                            //autoIntBlind = smallBlind * 2;
                          }),
                    ),
                  ],
                )),
            // Big Blind
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal:stdHorizontalOffset,
                ),
                //color: Colors.red,
                height: stdHeight * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text('sett.win3'.tr(),
                      overflow: TextOverflow.fade,
                        softWrap: false,
                          style: TextStyle(
                              color: thisTheme.bankColor,
                              fontSize: stdFontSize ,
                              fontWeight: FontWeight.normal)),
                    ),
                    const Flexible(flex: 2, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: Text('${smallBlind * 2}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: thisTheme.bankColor,
                              fontSize: stdFontSize ,
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                )),
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
                              color: thisTheme.textColor,
                              fontSize: stdFontSize * 0.8,
                              fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: stdHeight * 0.8,
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(autoBool
                              ? thisTheme.primaryColor
                              : thisTheme.bankColor),
                          value: autoBool,
                          onChanged: (bool? value) {
                            setState(() {
                              autoBool = value!;
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
                    anteBool = !anteBool;
                  });
                },
                children: [
                  ExpansionPanel(
                    //hasIcon: false,
                    canTapOnHeader: false,
                    isExpanded: anteBool,
                    backgroundColor: thisTheme.bgrColor,
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
                                  if (anteBool)
                                    const Expanded(flex: 3, child: SizedBox()),
                                  Flexible(
                                    flex: anteBool ? 8 : 7,
                                    child: Text('Ante',
                                        style: TextStyle(
                                            color: thisTheme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: anteBool ? 3 : 2,
                                    child: SizedBox(
                                      height: stdHeight * 0.75,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                anteBool
                                                    ? thisTheme.primaryColor
                                                    : thisTheme.bankColor),
                                        value: anteBool,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            anteBlind = !(3*smallBlind>tmpBank)? smallBlind :0;
                                            _anteBlindController.clear();

                                            anteBool = value!;
                                            
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
                              color: thisTheme.textColor,
                              width: anteBool ? 250 : 0,
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
                                            color: thisTheme.textColor,
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
                                          color: thisTheme.textColor,
                                          fontSize: stdFontSize * 0.8,
                                        ),
                                        maxLength: 5,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: stdFontSize * 0.8,
                                              color: thisTheme.bankColor,
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

                                            }
                                            else {
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
                                            color: thisTheme.textColor,
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
                                              color: thisTheme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: thisTheme.bankColor,
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
                expansionCallback: (i, autoBool) {
                  setState(() {
                    autoBool = !autoBool;
                  });
                },
                children: [
                  ExpansionPanel(
                    //hasIcon: false,
                    canTapOnHeader: false,
                    isExpanded: (autoBool || anteBool),
                    backgroundColor: thisTheme.bgrColor,
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
                                      color: thisTheme.textColor,
                                      fontSize: stdFontSize * 0.85,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          SizedBox(
                            //width: double.infinity,
                            height: 1,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds:anteBool? 400: 200),
                              //margin: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
                              color: thisTheme.textColor,
                              width: (autoBool || anteBool) ? 250 : 0,
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
                                            color: thisTheme.textColor,
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
                                              color: thisTheme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: thisTheme.bankColor,
                                              fontSize: stdFontSize * 0.7,
                                              fontWeight: FontWeight.normal),
                                          itemWidth: stdHeight,
                                          //itemHeight: stdFontSize * 0.85,
                                          value: autoDoubleFactor,
                                          axis: Axis.horizontal,
                                          itemCount: 3,
                                          step: 0.5,
                                          minValue: 1.0,
                                          maxValue: 4.0,
                                          onChanged: (value) {
                                            setState(() {
                                              autoDoubleFactor = value; //value;
                                              
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
                                            color: everyLapBool
                                                ? thisTheme.bankColor
                                                : thisTheme.textColor,
                                            fontSize: stdFontSize * 0.8,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: NumberPicker(
                                          scrollable: !everyLapBool,
                                          haptics: true,
                                          selectedTextStyle: TextStyle(
                                              color: everyLapBool
                                                  ? thisTheme.bankColor
                                                  : thisTheme.primaryColor,
                                              fontSize: stdFontSize * 0.8,
                                              fontWeight: FontWeight.normal),
                                          textStyle: TextStyle(
                                              color: thisTheme.bankColor,
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
                                            color: everyLapBool
                                                ? thisTheme.bankColor
                                                : thisTheme.textColor,
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
                                            color: thisTheme.textColor,
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
                                                everyLapBool
                                                    ? thisTheme.primaryColor
                                                    : thisTheme.bankColor),
                                        value: everyLapBool,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            everyLapBool = value!;
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
                buttonColor: thisTheme.primaryColor,
                textString: "sett.conf".tr(),
                action: () async {
                  if ((focusNode1.hasFocus) || (focusNode2.hasFocus)) {            
                    focusNode1.unfocus();
                    focusNode2.unfocus();
                  } else {
                    
                    widget.thisLobby.lobbySmallBlind=smallBlind;
                    
                    //widget.thisLobby.lobbyAutoBool = autoBool;
                    //widget.thisLobby.lobbyAnteBool = anteBool;
                    
                    //widget.thisLobby.lobbyAnte= anteBool? anteBlind: 0;
                    //widget.thisLobby.lobbyFirstAnte = firstLap;

                    //widget.thisLobby.lobbyFactor = autoDoubleFactor;
                    //widget.thisLobby.lobbyAutoTime = autoTime;
                    //widget.thisLobby.lobbyEveryLapBool = everyLapBool;

                    //НЕ УБИРАТЬ ИЗ КОНЦА
                    if(tmpBank!=-1*thisLobby.lobbyBank){
                      widget.bankUpdate(tmpBank);
                    }
                    
                     
                    logs.writeLog('Close settings with:\nlobbyBank: ${thisLobby.lobbyBank}\tsmallBlind: ${thisLobby.lobbySmallBlind}');
                    Navigator.of(context).pop();
                    //widget.thisLobby.show();
                    }
                  }
                )
          ],
        ),
      );

  void _checkInt(TextEditingController _thisEditingController) {
    for (int i = 0; i < _thisEditingController.text.length; i++) {
      try {
        int.parse(_thisEditingController.text[i]);
      } catch (e) {
        _thisEditingController.value = _thisEditingController.value.copyWith(
            text: _thisEditingController.text.substring(0, i) +
                _thisEditingController.text.substring(i + 1),
            selection: TextSelection.fromPosition(
              TextPosition(offset: i),
            ));
        break;
      }
    }
  }
  // вывод предупреждения
  
}


