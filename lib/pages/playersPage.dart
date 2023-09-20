// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../ui/transitions.dart';
import '../widgets/lobbySettings.dart';
import '../ui/ui_widgets.dart';
import '../data/storage.dart';
import '../data/uiValues.dart';
import '../data/lobby.dart';
import 'gamePage.dart';

/*
void addNewPlayer(Player newPlayer)async{
  if ((!thisLobby.lobbyPlayers.contains(newPlayer)) && (thisLobby.lobbyPlayers.length < maxPlayerCount)) {
    //newPlayer.changeBank(thisLobby.lobbyBank);
    thisLobby.add(newPlayer);
          logs.writeLog('New player\t ${newPlayer.show()}'); 
          await Future.delayed(const Duration(milliseconds: 300));
                          
                            if (scrollController.hasClients) {
                              scrollController.animateTo(scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 750), curve: Curves.ease);
                            }    
    } else {
        showToast("Player must be unique!");
        logs.writeLog('${newPlayer.show()}\talready exist');
      }
    }*/

void addPlayer(Player newPlayer, bool saved, bool isNew) async{
      newPlayer = newPlayer.copy();
      if (saved) {
        if(!savedPlayers.contains(newPlayer)){
            savedPlayers.add(newPlayer);
            logs.writeLog('Saving:\t${newPlayer.show()}');
            showToast('${newPlayer.name} '+'toast.saved'.tr());
            // запись в json, чтобы все сохранилось  
            savedStorage.writePlayers(savedPlayers);
        } else{
          logs.writeLog('${newPlayer.show()}\talready saved');
          //showToast('${newPlayer.name} already saved!');
        }
      } else {
        if ((!thisLobby.lobbyPlayers.contains(newPlayer)) && (thisLobby.lobbyPlayers.length < maxPlayerCount)) {
          newPlayer.isActive = !thisLobby.lobbyIsActive||thisLobby.lobbyState==5;
          if(!isNew){
            newPlayer.changeBank(thisLobby.lobbyBank);
          } 
          thisLobby.add(newPlayer);
          logs.writeLog((isNew?'New player':'Added from saved')+'\t ${newPlayer.show()}'); 
          //if(!isNew) showToast('${newPlayer.name} added from storage');
          await Future.delayed(const Duration(milliseconds: 300));
          if (scrollController.hasClients) {
            scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 750), curve: Curves.ease);
          }  
        }
        else{
          logs.writeLog('${newPlayer.show()}\talready in Lobby or MAX PLAYERS');
          if(thisLobby.lobbyPlayers.length==maxPlayerCount) {
            showToast('toast.maxpl'.tr());
          } else {
            showToast('${newPlayer.name} '+'toast.alred'.tr());
          }
          
        }
      }

}    

void bankUpdate(int newBank)async {
      print('Внимание на минимальный банк!');
      /*
      if (newBank < thisLobby.lobbySmallBlind * 2 + thisLobby.lobbyAnte) {
        if (thisLobby.lobbyAnteBool) {
          logs.writeLog("Ante changed to:\t ${thisLobby.lobbyAnte}");
          thisLobby.lobbyAnte = newBank ~/ 2;
        }
        thisLobby.lobbySmallBlind = (newBank - thisLobby.lobbyAnte) ~/ 2;
        logs.writeLog("Small blind changed to:\t ${thisLobby.lobbySmallBlind}");
        showToast("Small blind changed");
      }*/
      
      thisLobby.lobbyBank = newBank;

      for (final player in thisLobby.lobbyPlayers) {
        player.changeBank(thisLobby.lobbyBank);
      }

      logs.writeLog("Initial stack changed to:\t $newBank");
      
  }


ScrollController scrollController = ScrollController();

// Основной класс окна с игроками
class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key})
      : super(key: key); 

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {

  @override  
  void initState() {
    // загрузка игроков с прошлого раза
    super.initState();  

    //readSaved();
  }
  
  callback() {
    setState(() {
      lobbyStorage.writeLobby(thisLobby);
    });
    //print("callback is ended");
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: thisTheme.bgrColor,
            child:PatternContainer(
              padding: EdgeInsets.only(top: stdCutoutWidth*0.75,bottom: stdCutoutWidthDown*0.75),
 
      child:Scaffold(
      resizeToAvoidBottomInset: false,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: stdButtonHeight*0.75,
        leading: ModalRoute.of(context)?.canPop == true
          ? IconButton(
            onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                size: stdIconSize,
                
              ),
            )
          : null,
        iconTheme: IconThemeData(
          color: thisTheme.onBackground, //change your color here
        ),
        backgroundColor: const Color(0x00000000),
        titleTextStyle:
          appBarStyle().copyWith(fontSize: stdFontSize/20*24),
        elevation: 0,
        title: Text('playp.tittle'.tr()),
        centerTitle: true,
        actions: <Widget>[
          AspectRatio (aspectRatio: 1, 
              child: IconButton(
                splashColor: thisTheme.bankColor,
                highlightColor: Colors.transparent,       
                icon: Icon(
                  Icons.folder_shared,      
                  size: stdIconSize,
                ),
                tooltip: 'tooltip.stor'.tr(),
                onPressed: () async {
                  await transitionDialog(
                    duration: const Duration(milliseconds: 400),
                    type: "SlideUp", 
                    context: context,
                    child: PlayerList(saved: true, callbackFunction: callback),
                    builder: (BuildContext context) {
                    return PlayerList(saved: true, callbackFunction: callback);
                    }
                  );
                },
              ),
            ),
          ]
              
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            width: stdButtonWidth,
            // главный контейнер с отступом
            
            margin: EdgeInsets.only(
                bottom: adaptiveOffset,
                    left: adaptiveOffset,//  windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width),
                    right: adaptiveOffset),
            child: Column(
              // колонка чтобы можно было разделить экран на верхнюю часть и нижние статичные кнопки
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _topBotton(),
                SizedBox(
                        height: stdHorizontalOffset,
                        width: double.infinity,
                      ),
                Expanded(
                    child: Column(
                  children: [
                    //PlayerList
                    Flexible(
                        child: thisLobby.lobbyPlayers.isNotEmpty
                            ? PlayerList(            
                                saved: false,
                               
                                callbackFunction: callback
                                )
                            : const SizedBox()),
                    //AddBottom
                    if (thisLobby.lobbyPlayers.length > standartPlayerCount)SizedBox(
                        height: stdHorizontalOffset/2,
                        width: double.infinity,
                      ),
                    ((thisLobby.lobbyPlayers.length != maxPlayerCount) && thisLobby.lobbyState==5)
                            ? AttentionAdd(callBackFunction: callback,)
                            : const SizedBox(),
                    //FreeSpace
                    
                  ],
                )),
                SizedBox(
                        height: (thisLobby.lobbyPlayers.length != maxPlayerCount)?stdHorizontalOffset:0,
                        width: double.infinity,
                      ),
                _lowerButton(),
              ],
            ),
          ),
      ),
      ),
      ),
    );
  }

  Widget _topBotton() => MyButton(
            side: (thisLobby.lobbyIsActive)?BorderSide(width: 2.5, color: thisTheme.subsubmainColor):null,
            height: stdButtonHeight,
            buttonColor: (thisLobby.lobbyIsActive)? thisTheme.playerColor: thisTheme.bankColor,
            //padding:  EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
            action: () async {
              if(thisLobby.lobbyIsActive){
                
                await transitionDialog(
                type: "SlideUp",
                context: context,
                duration: const Duration(milliseconds: 400),
                child: ConfirmationWindow(type: "conf.rest.tittle".tr(), button: "conf.rest.butt".tr(),message: "conf.rest.text".tr(), action: () async {thisLobby.reset(); callback();}),//setState(() {});
                builder: (BuildContext thiscontext) {
                  return ConfirmationWindow(type:"conf.rest.tittle".tr(), button: "conf.rest.butt".tr(),message:"conf.rest.text".tr(), action: () async {thisLobby.reset();callback();});
                });
              }
              else{
                await transitionDialog(
                type: "SlideUp",
                context: context,
                duration: const Duration(milliseconds: 400),
                child: BankWindow(
                    bank: thisLobby.lobbyBank,
                    update: bankUpdate,),
                builder: (BuildContext context) {
                  return BankWindow(
                      bank: thisLobby.lobbyBank,
                      update: bankUpdate,);
                });
                setState(() {});
                lobbyStorage.writeLobby(thisLobby);
                SystemChrome.restoreSystemUIOverlays();
              }
          },
            child: (thisLobby.lobbyIsActive)?Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AspectRatio(aspectRatio:1, child: Icon(
                    MdiIcons.pokerChip,
                    color: thisTheme.onPrimary.withOpacity(0),
                    size: stdIconSize,
                  ),),

                  Text('playp.rest'.tr(), style: TextStyle(fontSize: stdFontSize,color: thisTheme.onBackground)),
                  AspectRatio(aspectRatio:1, child: Icon(
                    Icons.sync_sharp,
                    color: thisTheme.subsubmainColor,
                    size: stdIconSize,
                  )
                )
                ]):Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'playp.init'.tr()+'  ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: stdFontSize,
                            color: thisTheme.onBackground,
                          ),
                        ),
                        Text(
                          '${thisLobby.lobbyBank}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: stdFontSize,
                            color: thisTheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                
          );
  
  Widget _lowerButton() => SizedBox(
        height: stdButtonHeight * 2 + stdHorizontalOffset ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            MyButton(
              height: stdButtonHeight, 

               buttonColor: thisTheme.primaryColor,
              action: () async{
                  if (thisLobby.lobbyPlayers.length <2) {
                    showToast("toast.moreplay2".tr());
                  } else{
                    logs.writeLog('Switch to PlayerPage');
                    Navigator.push(
                      context,
                      simpleSlidePageRoute(const GamePage()
                          )).then((_) {
                                logs.writeLog('Returned to PlayerPage');
                                callback();
                          } );//setState(() {}); !!!!!!!! МБ МОЖНО ВЕРНУТЬ
                  }
                },
                textString: thisLobby.lobbyIsActive ? "home.cont".tr() : "playp.start".tr(),
                
                
              ),
              // Settings
            MyButton(
              height: stdButtonHeight, 
               buttonColor: thisTheme.secondaryColor,
              action: () async {
                  await transitionDialog(
                    duration: const Duration(milliseconds: 400),
                      type: "SlideDown",
                      context: context,
                      child: AddSettings(
                        thisLobby: thisLobby,
                        bankUpdate: bankUpdate,
                      ),
                      builder: (BuildContext context) {
                        return AddSettings(
                            thisLobby: thisLobby, bankUpdate: bankUpdate);
                      });
                      callback();
                      SystemChrome.restoreSystemUIOverlays();
                },
                
                textString: "playp.set".tr(),
                
              ),
          ],
        ),
      );

      //Widget _savedPlayers( dynamic context) => ;
}

class AttentionAdd extends StatefulWidget {
  const AttentionAdd({
    Key? key,
    this.duration = const Duration(seconds: 1),
    this.maxSize = 0.05,
    this.curve = Curves.easeInOut,
    required this.callBackFunction
    
  }) : super(key: key);

  final Duration duration;
  final double maxSize;
  final Curve curve;
  final Function() callBackFunction;

  @override
  _AttentionAddState createState() => _AttentionAddState();
}

class _AttentionAddState extends State<AttentionAdd>
    with SingleTickerProviderStateMixin {
  late AnimationController controller ;
  late dynamic f;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    f = (status) async{
        if (status == AnimationStatus.completed ) {
          if(thisLobby.lobbyPlayers.isEmpty) controller.reverse();
          
        } else if (status == AnimationStatus.dismissed) {
          await Future.delayed(const Duration(seconds: 5));
            if(thisLobby.lobbyPlayers.isEmpty){        
              controller.forward();
            }
            else{
              controller.stop();
              controller.removeStatusListener(f);
            }
        }
      };
  
    
    listener();
      
  }

  void listener() async{
     if(thisLobby.lobbyPlayers.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      controller.forward();
     }
                              
    controller.addStatusListener(f);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double value) {
    return widget.curve.transform(value);
  }
      

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.scale(
        scale: 1.0 - widget.maxSize * shake(controller.value),
        child: child,
      ),
      child: MyButton(
      height: stdButtonHeight, 
      width: double.infinity,
      buttonColor: thisTheme.playerColor,
      child: thisLobby.lobbyPlayers.isEmpty?
                    Text("playp.add".tr(),
                            style: TextStyle(
                                color: thisTheme.primaryColor,
                                fontSize: stdFontSize * 0.75)):Icon(
              Icons.add_sharp,
              color: thisTheme.primaryColor,
              size: stdIconSize,
            ),
      action: () async {
              //controller.animateTo(0, duration: const Duration(milliseconds: 500)).then(controller.stop());
              //await Future.delayed(Duration(milliseconds: 500));
             
              controller.stop();
              controller.removeStatusListener(f);
              controller.animateTo(0, duration: const Duration(milliseconds: 500));
              
              
              await transitionDialog(
                duration: const Duration(milliseconds: 400),
                type: "Scale1",
                //barrierColor: null,
                context: context,
                child: AddWindow(callBackFunction: widget.callBackFunction,isNew: true),
                builder: (BuildContext context) {
                  return AddWindow( callBackFunction: widget.callBackFunction,isNew: true);
                },
              );
             SystemChrome.restoreSystemUIOverlays();
             listener();
              
            
            },),
    );
  }
}




// Ячейка банка
class BankWindow extends StatefulWidget {
  const BankWindow(
      {Key? key,
      required this.bank,
      required this.update})
      : super(key: key);
  final int bank;
  final void Function(int) update;

  @override
  State<BankWindow> createState() => _BankWindowState();
}

class _BankWindowState extends State<BankWindow> {
  final TextEditingController _bankController = TextEditingController();
  int tmpBank = thisLobby.lobbyBank;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset ),//windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: _bankWindow(),
    );
  }

  Widget _bankWindow() => Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: stdButtonHeight * 0.75 * 2.7 + stdHorizontalOffset*3.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('playp.bank.title'.tr(),
                      style: TextStyle(
                          color: thisTheme.onBackground,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(
              height: stdHorizontalOffset/2 ,
            ),
            
              Container(
                height: stdButtonHeight * 0.75,
                decoration: BoxDecoration(
                  color: thisTheme.bankColor,
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                ),
                child: TextFormField(
                    controller: _bankController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: thisTheme.onBackground,
                      fontSize: stdFontSize ,
                    ),
                    maxLength: 10,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: stdFontSize ,
                          color: thisTheme.bgrColor,
                        ),
                        hintText: "${widget.bank}",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(stdBorderRadius),
                          borderSide: BorderSide(color: thisTheme.bankColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(stdBorderRadius),
                          borderSide: BorderSide(
                              color: thisTheme.bankColor),
                        ),
                        counterText: ''),
                    //initialValue: newName,
                    onChanged: (String value) {
                              value = value.replaceAll(RegExp(r'[^0-9]'),'');
                              if (value !="") {
                                tmpBank = int.parse(value);
                              } else {tmpBank = thisLobby.lobbyBank;
                              }
                              _bankController.value =
                                  _bankController.value.copyWith(
                                text: value,
                              );    
                      setState(() {});
                    }),
              ),
            SizedBox(
              height: stdHorizontalOffset ,
            ),
              MyButton(
                height: stdButtonHeight * 0.75,
                width: double.infinity, 
                buttonColor: (tmpBank>=1)? thisTheme.primaryColor: thisTheme.bankColor,
                action: () {
                    
                    // проверка чтобы челикс не ввел пустой символ
                    if (tmpBank >=1) {
                      print('Внимание на минимальный банк!');
                      Navigator.of(context).pop();
                      widget.update(tmpBank.abs());
                    }
                  },
                  textString: "playp.bank.conf".tr()
              ),
            
          ],
        ),
      );


}

// Класс отрисовки списка игроков. Принимает массив (this/saved), метод добавления, bool значение this или saved и функцию отрисовки.
// В дальнейшем думал сделать перемещение игроков местами но пока не получилось.
class PlayerList extends StatefulWidget {
  const PlayerList(
      {Key? key,
      required this.saved,
      required this.callbackFunction})
      : super(key: key);

  final Function() callbackFunction;
  final bool saved;
  
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  
   final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.saved? 
    Dialog(
        elevation: 0,
        backgroundColor: thisTheme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
            horizontal: adaptiveOffset ),//windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
            padding: EdgeInsets.all(
                stdHorizontalOffset),
            width: stdButtonWidth,
            height: stdHorizontalOffset*2 + stdButtonHeight * 0.75 * 0.5 + (stdButtonHeight * 0.75+stdHorizontalOffset/2) *
                    (savedPlayers.length> standartPlayerCount? standartPlayerCount:savedPlayers.length ) ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: stdButtonHeight * 0.75 * 0.5,     
                      child:  Center(
                            child: savedPlayers.isNotEmpty
                          ?Text(
                                "playp.sp.title1".tr(),
                                style: TextStyle(
                                  color: thisTheme.onBackground,
                                  fontWeight: FontWeight.bold,
                                 fontSize: stdFontSize
                                ),
                              ): Text(
                                "playp.sp.title2".tr(),
                                style: TextStyle(
                                  color: thisTheme.onBackground,
                                  fontWeight: FontWeight.w500,
                                 fontSize: stdFontSize
                                ),
                              )
                          ),
                    ),
                if(savedPlayers.isNotEmpty) SizedBox(height: stdHorizontalOffset/2),
                Flexible(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(stdBorderRadius),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: (stdButtonHeight*0.75 + stdHorizontalOffset/2) *
                              savedPlayers.length,
                          child: Column(
                        children: <Widget>[
                          for (int index = 0; index < savedPlayers.length; index++)
                            Column(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(stdBorderRadius),child: _playerDissmisible(savedPlayers, index)),
                                SizedBox(height: stdHorizontalOffset/2,)
                              ],
                            ),      
                        ],
                      )
                        )),
                  ),
                ),
              ],
            ))):ClipRRect(
                borderRadius: BorderRadius.circular(stdBorderRadius),
            
                    child: SingleChildScrollView(
                      controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: (stdButtonHeight + stdHorizontalOffset) *
                              thisLobby.lobbyPlayers.length,
                          child: Column(
                        children: <Widget>[
                          for (int index = 0; index < thisLobby.lobbyPlayers.length; index++)                   
                              Column(
                                    children: [
                                      ClipRRect(
                                  borderRadius: BorderRadius.circular(stdBorderRadius),
                                      child: _playerDissmisible(thisLobby.lobbyPlayers, index)),
                                      SizedBox(height: stdHorizontalOffset)
                                    ],
                                  )  
                        ],
                      )
                        )),
                  );
  }

// Карточка игрока. Принимает индекс. Массив берет из родительского класса.
  Widget _playerDissmisible(List<Player> players,int index) => Dismissible(
    
      key: Key(players[index].name),
      child:  playerCard(players[index], index, widget.saved? stdButtonHeight*0.75:stdButtonHeight, widget.saved, context, widget.callbackFunction),
      direction: (thisLobby.lobbyState==5 )?DismissDirection.horizontal:DismissDirection.none,
      onDismissed: (direction) {
        /*if (direction == DismissDirection.endToStart) {
                              widget.players.removeAt(index);
                              widget.callbackFunction();
                          }*/
      },
      background: Container(
        color:  thisTheme.bgrColor,      
                  child:  Row(
            children: [
              AspectRatio(aspectRatio:1,
                child: Icon(widget.saved ? Icons.add : Icons.save,
                      color: thisTheme.onBackground, size: stdIconSize),
              ),
              
              Text(widget.saved ? ' '+'playp.playr.diss1'.tr() : ' '+'playp.playr.diss2'.tr(),
                  style: TextStyle(
                      color: thisTheme.onBackground,
                      fontSize: stdFontSize * 0.75)),
            ],
          ),
      ),
      
      secondaryBackground:  Container(
                    color: thisTheme.bgrColor,
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               
              Text(widget.saved ? ' '+'playp.playr.diss3'.tr() : ' '+'playp.playr.diss4'.tr(),
                  style:
                       TextStyle(color: thisTheme.subsubmainColor, fontSize: stdFontSize * 0.75)),
                       AspectRatio(aspectRatio:1,child: Icon(Icons.delete, color: thisTheme.subsubmainColor,size: stdIconSize)),
            ],
          ),
      ),
      
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          addPlayer(players[index], !widget.saved, false);
          setState(()  {});
          if(widget.saved) widget.callbackFunction();
          return false;
        }
        else{
          //_quickDelete(index);
          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationWindow(type: "conf.del.tittle".tr(),button: 'conf.del.butt'.tr(), message: "conf.del.text".tr(),action: () => _quickDelete(index));
                            },
                          );
        }
        
        /*
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return _deleteConfirm(index, context);
            },
          );
          */
      });
  
// Карточка подтверждения удаления. Принимает индекс...
  // ignore: unused_element
  
// Функция быстрого удаления. Альтернатива карточке подтверждения.
  Future<void> _quickDelete(int index) async {
    
    //сохраняем изменения сразу в json, чтобы при краше все сохранилось
    if (widget.saved) {
      logs.writeLog('${savedPlayers[index].show()}\tdeleted from saved');
      savedPlayers.removeAt(index);
      savedStorage.writePlayers(savedPlayers);
    }
    else {
      logs.writeLog('${thisLobby.lobbyPlayers[index].show()}\tdeleted from Lobby');
      thisLobby.lobbyPlayers.removeAt(index);
      if (thisLobby.dealerIndex>=thisLobby.lobbyPlayers.length && thisLobby.lobbyPlayers.isNotEmpty){
        thisLobby.dealerIndex=thisLobby.dealerIndex%thisLobby.lobbyPlayers.length;
        logs.writeLog('New dealerIndex\t ${thisLobby.dealerIndex}');
      } 
    }
    //widget.callbackFunction();
    setState(() {});
    if (!widget.saved) widget.callbackFunction();
  }

  
}

// Кнопка добавления игрока
class AddWindow extends StatefulWidget {
 
  final Function() callBackFunction;
  late Player? player;
  late int? playerIndex;
  late bool isNew;
  late bool settingsBool;
  
  AddWindow({Key? key, this.player, required this.callBackFunction,this.settingsBool = false, this.isNew = false, this.playerIndex = 0})//this.playerIndex = 0})
      : super(key: key);

  //int tmpBank = 0 ;
  @override
  _AddWindowState createState() => _AddWindowState();
}

class _AddWindowState extends State<AddWindow> {
  final TextEditingController _bankController = TextEditingController();
  String standartLogo = 'assets/faces/pokerfaces0.jpg';
  String newName = '';
  String newBank = thisLobby.lobbyBank.toString();
  late FocusNode focusNodeName = FocusNode();
  late FocusNode focusNodeStack = FocusNode();
  bool dealerBool = false;

  @override
  void initState(){
    super.initState();
    if (!widget.isNew && widget.player!=null) { 
      standartLogo = widget.player!.assetUrl;
      newBank = widget.player!.bank.toString();
      newName = widget.player!.name;
    }
  }
  void changeLogo(String newLogo) {
    setState(() {
      standartLogo = newLogo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: stdElevation,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: _settingNewPlayer(),
    );
  }

  Widget _settingNewPlayer() => Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: stdDialogHeight*1.2 - ((widget.settingsBool || widget.isNew)?0:1*stdButtonHeight*0.75 ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            // Аватарка
            GestureDetector(
              onTap: () async {
                SystemChrome.restoreSystemUIOverlays();
                if (focusNodeName.hasFocus || focusNodeStack.hasFocus) {
                  focusNodeStack.unfocus();
                  focusNodeName.unfocus();
                  await Future.delayed(const Duration(milliseconds: 500));
                }
                await showGeneralDialog(
                  barrierColor: Colors.transparent,
                  transitionDuration: const Duration(milliseconds: 400),
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return PickIcon(changeLogo: changeLogo, settingsBool: widget.settingsBool, isNew: widget.isNew);
                  },
                  transitionBuilder: dialogWave1,
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: stdDialogHeight/2,
                    height: stdDialogHeight/2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          standartLogo,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: stdDialogHeight/2,
                    height: stdDialogHeight/2,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color:
                              (standartLogo != 'assets/faces/pokerfaces0.jpg')
                                  ? thisTheme.primaryColor
                                  : thisTheme.bgrColor),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/faces/edit_frame.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: 
                Container(
                width: MediaQuery.of(context).size.width,
                padding:  EdgeInsets.only(left: stdHorizontalOffset),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text on top
                    SizedBox(
                      height: stdButtonHeight * 0.5,
                      child: Center(
                        child: Text(
                          widget.isNew?'playp.edit.title1'.tr():'playp.edit.title2'.tr(),
                          style: TextStyle(
                            
                            color: thisTheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: stdFontSize,
                          ),
                        ),
                      ),
                    ),
                    // Name field
                    SizedBox(
                      height: stdButtonHeight * 0.6,
                      child: TextFormField(initialValue: widget.isNew?"":newName,
                          focusNode: focusNodeName,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: thisTheme.onBackground,
                            fontSize: stdFontSize * 0.85,
                          ),
                          maxLength: 10,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.bankColor,
                              ),
                              hintText: "playp.edit.win1".tr(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(
                                        color: (newName != "")
                                            ? thisTheme.primaryColor
                                            : thisTheme.bankColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: (newName != "")
                                        ? thisTheme.primaryColor
                                        : thisTheme.bankColor),
                              ),
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            newName = value;
                            setState(() {});
                            
                          }),
                    ),
                    // Bank field
                    if(widget.settingsBool || widget.isNew)SizedBox(
                      height: stdButtonHeight * 0.6,
                      child: TextFormField(//initialValue: widget.isNew?"":newBank,
                        controller: _bankController,
                        keyboardType: TextInputType.number,
                          focusNode: focusNodeStack,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: thisTheme.onBackground,
                            fontSize: stdFontSize * 0.85,
                          ),
                          maxLength: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.bankColor,
                              ),
                              hintText: "playp.edit.win2".tr()+" - $newBank",
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(
                                        color: ( newBank != '' && newBank!="0")
                                            ? thisTheme.primaryColor
                                            : thisTheme.bankColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ( newBank != '' && newBank!="0")
                                        ? thisTheme.primaryColor
                                        : thisTheme.bankColor),
                              ),
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            value = value.replaceAll(RegExp(r'[^0-9]'),'');
                              if (value !="") {
                                newBank = value;
                              } else {
                              newBank =thisLobby.lobbyBank.toString();
                              }
                              _bankController.value =
                                  _bankController.value.copyWith(
                                text: value,
                              );    
                            setState(() {});
                          }),
                    ),
                    // Button field
                    if(widget.settingsBool || widget.isNew)Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Text('playp.edit.win3'.tr(),
                          style: TextStyle(
                              color: thisTheme.onBackground,
                              fontSize: stdFontSize * 0.85,
                              fontWeight: FontWeight.normal,)),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: stdButtonHeight * 0.6,
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(dealerBool
                              ? thisTheme.primaryColor
                              : thisTheme.bankColor),
                          value: dealerBool,
                          onChanged: (bool? value) {
                            setState(() {
                              dealerBool = value!;
                            });
                          },
                        ),
                      ))]),
                    MyButton(
                      height: stdButtonHeight * 0.75,
                      width:double.infinity,
                      buttonColor: (newName != "") && ((( (newBank!="0")) || thisLobby.lobbyState!=5)
                      && (standartLogo != 'assets/faces/pokerfaces0.jpg') 
                      && (!thisLobby.lobbyPlayers.contains(Player(newName,standartLogo,int. parse(newBank),false)) ||(widget.player == Player(newName,standartLogo,int. parse(newBank),false))))
                                    ? thisTheme.primaryColor : thisTheme.bankColor,
                      textString: !widget.isNew?'playp.edit.conf'.tr():'playp.edit.add'.tr(),
                      action: () async {
                          // проверка чтобы челикс не ввел пустой символ
                          SystemChrome.restoreSystemUIOverlays();
                          Player checkplayer = Player(newName,standartLogo,int. parse(newBank),false);
                          // Проверяем, что не ввели данные существующего игрока
                          if (!thisLobby.lobbyPlayers.contains(checkplayer)||(widget.player == checkplayer)){
                            //проверяем, что новый игрок с норм данными
                            if ((newName != "") && (standartLogo != 'assets/faces/pokerfaces0.jpg')){
                              // закрываем клаву, при нажатии кнопки
                              if (focusNodeName.hasFocus || focusNodeStack.hasFocus) {
                                focusNodeStack.unfocus();
                                focusNodeName.unfocus();
                                await Future.delayed(const Duration(milliseconds: 500));
                              }
                              // изменяем диллера, если нужно
                              if(dealerBool&& widget.playerIndex!=null){
                              var newDealer = (widget.isNew)? thisLobby.lobbyPlayers.length: widget.playerIndex;
                              thisLobby.dealerIndex = newDealer!;
                              logs.writeLog('New dealerIndex\t ${thisLobby.dealerIndex}');
                              }
                              //меняем стек, только если он адекватный 
                              if (int. parse(newBank) <= 0 && thisLobby.lobbyState==5) {
                                newBank = "1";
                                _bankController.value =
                                  _bankController.value.copyWith(
                                text: newBank,
                              );    
                                showToast("toast.bank1".tr()+"\n"+"toast.bank2".tr()+" - ${thisLobby.lobbySmallBlind*2}");
                                setState(() {});
                                return null;
                              } 
                              /*if (int. parse(newBank) < thisLobby.lobbySmallBlind * 2 + thisLobby.lobbyAnte) {
                                newBank = (thisLobby.lobbySmallBlind * 2 + thisLobby.lobbyAnte).toString();
                                showToast("Your stack has been changed to the minimum recommended");
                              }*/
                              
                              //Если игрок новый -> добавляем
                              if (widget.isNew && widget.player==null) {
                                //print(int. parse(newBank));
                                addPlayer(Player(newName, standartLogo,int. parse(newBank)), false, true);
                                //addNewPlayer(Player(newName, standartLogo,int. parse(newBank), !thisLobby.lobbyIsActive||thisLobby.lobbyState==5));
                              }
                              // иначе редачим
                              else {
                                
                                widget.player!.name = newName; 
                                widget.player!.assetUrl = standartLogo;
                                widget.player!.bank =  int. parse(newBank);
                                if(thisLobby.lobbyState==5) {
                                  //widget.player!.isActive = int. parse(newBank) >= thisLobby.lobbySmallBlind * 2;
                                  widget.player!.isActive = int. parse(newBank) > 0;
                                }
                                logs.writeLog('${widget.player!.show()} -> $newName: $newBank/${widget.player!.bid}/${widget.player!.isActive}');
                                //(thisLobby.lobbyState==5||widget.player!.isActive)&&(int. parse(newBank) >= thisLobby.lobbySmallBlind * 2);
                              }
                              Navigator.of(context).pop();
                              widget.callBackFunction();  
                            }
                          }
                          else {
                            showToast('toast.alred2'.tr());
                          }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

// Окно с выбором аватарки. Принимает функцию смены аватарки в окне добавления.
class PickIcon extends StatefulWidget {
  const PickIcon({Key? key, required this.changeLogo, required this.settingsBool, required this.isNew}) : super(key: key);
  final void Function(String) changeLogo;

  final bool settingsBool;
  final bool isNew;

  @override
  State<PickIcon> createState() => _PickIconState();
}

class _PickIconState extends State<PickIcon> {
  int choosenIcon = -1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          //vertical: stdHorizontalOffset,
          horizontal: adaptiveOffset ),// windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      //contentPadding: EdgeInsets.zero,
      //title:const Center(child: Text('Add Player')),
      child: _pickIcon(),
    );
  }

  Widget _pickIcon() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(stdHorizontalOffset),
        height: stdDialogHeight*1.2 - ((widget.settingsBool || widget.isNew)?0:1*stdButtonHeight*0.75 ),
        width: stdButtonWidth,
        child: AspectRatio(
          aspectRatio: 5/2,
          child: GridView.builder(
            reverse: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 5,
            ),
            itemCount: maxPlayerCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    choosenIcon = index;
                  });

                  await Future.delayed(const Duration(milliseconds: 500));
                  widget.changeLogo('assets/faces/pokerfaces${index + 1}.jpg');
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding:  EdgeInsets.all(stdHorizontalOffset / 2),
                  child: AnimatedContainer(
                    height: stdButtonHeight,
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: (index == choosenIcon) ? 1.5 : 0,
                          color: (index == choosenIcon)
                              ? thisTheme.primaryColor
                              : thisTheme.bgrColor),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/faces/pokerfaces${index + 1}.jpg'),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

Widget playerCard(Player player, int? index, double height, bool saved, BuildContext context, callBackFunction) => Container(
    color:  thisTheme.bgrColor,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(stdBorderRadius),
      child: Container(
          height: height,
          color: thisTheme.playerColor,
                      //padding:  EdgeInsets.only(right: stdHorizontalOffset * 0.7),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                            Expanded(child: Row(children:[
                              AspectRatio (aspectRatio: 1/1, 
                              child: Padding(
                                padding:  EdgeInsets.all( 0.20 * stdButtonHeight*0.75),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          player.assetUrl,
                                        ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),),
                              Flexible(child: Container(
                                margin: EdgeInsets.symmetric(horizontal: stdButtonHeight*0.1, vertical: stdButtonHeight*0.15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row( mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                     
                                        Text(
                                          player.name + '  ',//+ ((index == thisLobby.dealerIndex && !widget.saved)?" - dealer":""),
                                          style: TextStyle(
                                            
                                            color: thisTheme.onBackground,
                                            fontWeight: FontWeight.w500,
                                            fontSize: stdFontSize * 0.8,
                                          ),
                                        ),
                                        if (index == thisLobby.dealerIndex && !saved)
                                          Tooltip(
                                            message: 'tooltip.dealer'.tr(), 
                                            verticalOffset: stdButtonHeight/6,
                                            child: Icon(
                                                    MdiIcons.cardsPlaying,
                                                    color: thisTheme.onBackground.withOpacity(1),
                                                    size: stdIconSize/1.5,
                                                  ),
                                          ),
                                      ],
                                    ),
                                    if (!saved)
                                      Text(
                                        '\$ ${player.bank}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: thisTheme.onBackground,
                                            fontSize: stdFontSize * 0.75),
                                      ),
                                  ],
                                ),
                              ),
                                )])),
                                
                          if(!saved) 
                          Align(
                              alignment: Alignment.centerLeft,
                              child: AspectRatio (aspectRatio: 1/1,
                                child: IconButton(
                                  tooltip: 'tooltip.edit'.tr(),
                                  onPressed: () async {
                                   
                                          await transitionDialog(
                                              duration: const Duration(milliseconds: 400),
                                              type: "Scale1",
                                              //barrierColor: null,
                                              context: context,
                                              child: AddWindow(player: player, callBackFunction: callBackFunction, playerIndex: index, settingsBool: (thisLobby.lobbyState==5)),
                                              builder: (BuildContext context) {
                                return AddWindow(player: player, callBackFunction: callBackFunction, playerIndex: index, settingsBool: (thisLobby.lobbyState==5));
                                              },
                                        );
                                  SystemChrome.restoreSystemUIOverlays();
                                    //_quickDelete(index);
                                  },
                                  splashColor: thisTheme.bankColor,
                                  highlightColor: Colors.transparent,
                                  icon: Icon( 
                                    Icons.create,
                                    color: thisTheme.onBackground,
                                    size: stdIconSize*0.75,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ), 
      ),
    ),
  );