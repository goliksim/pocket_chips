import 'package:firstapp/ui/transitions.dart';
import 'package:flutter/material.dart';
import '../internal/application.dart';
import 'package:numberpicker/numberpicker.dart';

// Конфиг UI. Отступы, стандартные размеры и т.д.
const double stdHeight = 50;
const double stdHorizontalOffset = stdHeight / 5;
const double stdEdgeOffset = 15;
const double stdFontSize = stdHeight * 0.4;
const double stdDialogHeight = 135 * stdHeight / 50;
const double stdIconSize = stdHeight / 2;

const int standartPlayerCount = 5 + (50 - stdHeight) ~/ 10;
const int maxPlayerCount = 8 + (50 - stdHeight) ~/ 10;

// Основной класс окна с игроками
class PlayersPage extends StatefulWidget {
  const PlayersPage({
    Key? key,
  }) : super(key: key); // принимает значение title при обращении

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  String newName = '';
  int standartBank = 2500;
  List thisPlayers = [];
  List savedPlayers = [];

  @override
  void initState() {
    // загрузка игроков с прошлого раза
    super.initState();
    thisPlayers.addAll([
      Player('Billy Herrington', 'assets/faces/pokerfaces8.jpg', standartBank),
      Player('Van DarkHolme', 'assets/faces/pokerfaces7.jpg', standartBank),
      Player('Boyyy', 'assets/faces/pokerfaces6.jpg', standartBank),
    ]);
    savedPlayers.addAll([
      Player('Saved1', 'assets/faces/pokerfaces1.jpg', standartBank),
      Player('Saved2', 'assets/faces/pokerfaces2.jpg', standartBank),
      Player('Saved3', 'assets/faces/pokerfaces3.jpg', standartBank),
      Player('Saved4', 'assets/faces/pokerfaces4.jpg', standartBank),
      Player('Saved5', 'assets/faces/pokerfaces5.jpg', standartBank),
      Player('Saved6', 'assets/faces/pokerfaces6.jpg', standartBank),
      Player('Saved7', 'assets/faces/pokerfaces7.jpg', standartBank),
      Player('Saved8', 'assets/faces/pokerfaces8.jpg', standartBank),
      Player('Saved9', 'assets/faces/pokerfaces1.jpg', standartBank),
      Player('Saved10', 'assets/faces/pokerfaces2.jpg', standartBank),
      Player('Saved11', 'assets/faces/pokerfaces3.jpg', standartBank),
      Player('Saved12', 'assets/faces/pokerfaces4.jpg', standartBank),
      Player('Saved13', 'assets/faces/pokerfaces5.jpg', standartBank),
      Player('Saved14', 'assets/faces/pokerfaces6.jpg', standartBank),
      Player('Saved15', 'assets/faces/pokerfaces7.jpg', standartBank),
      Player('Saved16', 'assets/faces/pokerfaces8.jpg', standartBank),
      Player('Saved17', 'assets/faces/pokerfaces5.jpg', standartBank),
      Player('Saved18', 'assets/faces/pokerfaces6.jpg', standartBank),
    ]);
  }

  void bankUpdate(int newBank) {
    setState(() {
      standartBank = newBank;
      for (final player in thisPlayers) {
        player.changeBank(standartBank);
      }
    });
  }

  void addPlayer(Player newPlayer, bool saved) {
    setState(() {
      if (saved) {
        !savedPlayers.contains(newPlayer)
            ? savedPlayers.add(newPlayer)
            : DoNothingAction();
      } else {
        if ((!thisPlayers.contains(newPlayer)) &&
            (thisPlayers.length < maxPlayerCount)) {
          newPlayer.changeBank(standartBank);
          thisPlayers.add(newPlayer);
        }
      }
    });
  }

  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)); // форма закругления

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: thisTheme.stdIconColor, //change your color here
        ),
        backgroundColor: const Color(0x00000000),
        titleTextStyle:
            TextStyle(color: thisTheme.textColor, fontSize: stdFontSize),
        elevation: 0,
        title: const Text('Player Menu'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: stdEdgeOffset),
            icon: const Icon(
              Icons.person_add,
              //color: thisTheme.stdIconColor,
              size: stdIconSize,
            ),
            tooltip: 'Add From List',
            onPressed: () async {
              await transitionDialog(
                  context: context,
                  type: "SlideUp",
                  child: SavedPlayer(savedplayers: savedPlayers,addPlayer: addPlayer,),
                   builder: (BuildContext context){
                      return SavedPlayer(savedplayers: savedPlayers,addPlayer: addPlayer,);
                    }
                  );
            },
          ),
        ],
      ),
      backgroundColor: thisTheme.bgrColor,
      body: Container(
        // главный контейнер с отступом
        margin: EdgeInsets.symmetric(
            vertical: stdEdgeOffset,
            horizontal: (MediaQuery.of(context).size.width - 360) / 2),
        child: Column(
          // колонка чтобы можно было разделить экран на верхнюю часть и нижние статичные кнопки
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _bankBotton(),
            thisPlayers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(stdHorizontalOffset / 2),
                    child: Text("Press + to add new players",
                        style: TextStyle(
                            color: thisTheme.textColor,
                            fontSize: stdFontSize * 0.75)),
                  )
                : const SizedBox(
                    height: stdHorizontalOffset,
                    width: double.infinity,
                  ),
            Expanded(
                child: Column(
              children: [
                //PlayerList
                Flexible(
                    flex: thisPlayers.length,
                    child: thisPlayers.isNotEmpty
                        ? PlayerList(
                            players: thisPlayers,
                            addPlayer: addPlayer,
                            saved: false,
                            callbackFunction: callback)
                        : const SizedBox()),
                //AddBottom
                Flexible(
                    flex: thisPlayers.length != maxPlayerCount ? 1 : 0,
                    child: thisPlayers.length != maxPlayerCount
                        ? _addBotton()
                        : const SizedBox()),
                //FreeSpace
                Flexible(
                    flex: thisPlayers.length < standartPlayerCount
                        ? standartPlayerCount - thisPlayers.length
                        : 0,
                    child: const SizedBox()),
              ],
            )),
            _lowerButton(),
          ],
        ),
      ),
    );
  }

  Widget _bankBotton() => SizedBox(
      height: stdHeight,
      child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: thisTheme.bankColor,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: stdIconSize,
                  height: stdIconSize,
                ),
                Row(
                  children: [
                    Text(
                      'Bank:  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: stdFontSize,
                        color: thisTheme.textColor,
                      ),
                    ),
                    Text(
                      '$standartBank',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: stdFontSize,
                        color: thisTheme.textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.edit,
                  color: thisTheme.bgrColor,
                  size: stdIconSize,
                ),
              ]),
          onPressed: () async {
            await transitionDialog(
              type: "SlideUp",
              context: context,
              duration: const Duration(milliseconds: 500),
              child: BankWindow(bank: standartBank, update: bankUpdate),
               builder: (BuildContext context){
                      return BankWindow(bank: standartBank, update: bankUpdate);
                    }
            );
          }));
  Widget _addBotton() => SizedBox(
        height: stdHeight,
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: thisTheme.bankColor,
          ),
          child: Icon(
            Icons.add,
            color: thisTheme.stdIconColor,
            size: stdIconSize,
          ),
          //tooltip: 'Add From List',
          onPressed: () async {
            await showGeneralDialog(
                    transitionDuration: Duration(milliseconds: 400),
                    //barrierColor: null,
                    context: context,
                    //child: PickIcon(changeLogo: changeLogo),
                    pageBuilder: (context, a1, a2){return AddWindow(addPlayer: addPlayer, bank: standartBank);},
                    transitionBuilder: dialogScale1,
                    );
          },
          //confirmPress:
        ),
      );
  Widget _lowerButton() => Container(
        padding: const EdgeInsets.only(top: stdHorizontalOffset / 2),
        height: stdHeight * 2 + stdHorizontalOffset * 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: stdHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: thisTheme.mainColor,
                ),
                onPressed: () async {
                  await transitionDialog(
                    type: "SlideDown",
                    context: context,
                    child: AddSettings(bank: standartBank, bankUpdate: bankUpdate),
                    builder: (BuildContext context){
                      return AddSettings(bank: standartBank, bankUpdate: bankUpdate);
                    }
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: thisTheme.bgrColor,
                      fontSize: stdFontSize,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: stdHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: thisTheme.submainColor,
                ),
                onPressed: () {},
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Start Game",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: thisTheme.bgrColor,
                      fontSize: stdFontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

// Класс игрока
class Player {
  Player(this.name, this.assetUrl, this.bank);

  final String name; // Имя
  final String assetUrl; // Логотип
  int bank = 0; // Банк

  //Функция обновления денег
  void changeBank(int newbank) {
    bank = newbank;
  }

  @override
  //перегруженный оператор == для недобавления существующих игроков
  bool operator ==(covariant Player other) =>
      ((name == other.name) && (assetUrl == other.assetUrl));
  // Ругается, что я не проверяю хешкод (ссылку на объект). Но нам не важно, один это объект или нет, главное чтобы они были разные по значению.
}

// Ячейка банка
class BankWindow extends StatefulWidget {
  const BankWindow({Key? key, required this.bank, required this.update})
      : super(key: key);
  final int bank;
  final ValueChanged<int> update;

  @override
  State<BankWindow> createState() => _BankWindowState();
}

class _BankWindowState extends State<BankWindow> {
  int tmpBank = 0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - 360) / 2),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: _bankWindow(),
    );
  }

  Widget _bankWindow() => Container(
        padding: const EdgeInsets.symmetric(
          vertical: stdHorizontalOffset,
          horizontal: stdEdgeOffset,
        ),
        height: stdDialogHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text('Enter new bank:',
                  style: TextStyle(
                      color: thisTheme.textColor,
                      fontSize: stdFontSize,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: thisTheme.playerColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: thisTheme.textColor,
                      fontSize: stdFontSize * 0.85,
                    ),
                    maxLength: 10,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: stdFontSize * 0.85,
                          color: thisTheme.bgrColor,
                        ),
                        hintText: "${widget.bank}",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(color: thisTheme.playerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                              color: (tmpBank > 0)
                                  ? thisTheme.mainColor
                                  : thisTheme.playerColor),
                        ),
                        counterText: ''),
                    //initialValue: newName,
                    onChanged: (String value) {
                      tmpBank = value != '' ? int.parse(value) : 0;
                      setState(() {});
                    }),
              ),
            ),
            const SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            Container(
              height: stdHeight * 0.75,
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        (tmpBank > 0)
                            ? thisTheme.mainColor
                            : thisTheme.playerColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: const BorderSide(color: Color.fromARGB(255, 33, 63, 34))
                    ))),
                onPressed: () {
                  // проверка чтобы челикс не ввел пустой символ
                  if (tmpBank != 0) {
                    Navigator.of(context).pop();
                    widget.update(tmpBank);
                  }
                },
                child: Text('Enter',
                    style: TextStyle(
                        color: thisTheme.bgrColor,
                        fontSize: stdFontSize * 0.75)),
              ),
            ),
          ],
        ),
      );
}

// Класс окна с сохраненными игроками. Принимает массив сохраненных игроков и метод добавления addPlayer.
class SavedPlayer extends StatefulWidget {
  const SavedPlayer({
    Key? key,
    required this.savedplayers,
    required this.addPlayer,
  }) : super(key: key);
  final List savedplayers;
  final void Function(Player, bool) addPlayer;
  //int tmpBank = 0 ;
  @override
  _SavedPlayerState createState() => _SavedPlayerState();
}

class _SavedPlayerState extends State<SavedPlayer> {
  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: thisTheme.bgrColor,
        insetPadding: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        //contentPadding: EdgeInsets.zero,
        //title:const Center(child: Text('Add Player')),
        child: Container(
            padding: const EdgeInsets.only(
                top: stdEdgeOffset,
                bottom: stdEdgeOffset,
                left: stdEdgeOffset,
                right: stdEdgeOffset),

            //color: Colors.red,
            height: (stdHeight + stdHorizontalOffset / 2) *
                    (widget.savedplayers.length < 8
                        ? widget.savedplayers.length
                        : 8) +
                stdFontSize * 1 +
                stdEdgeOffset * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: stdFontSize * 1,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: widget.savedplayers.isNotEmpty
                          ? Text(
                              "Saved Players",
                              style: TextStyle(
                                color: thisTheme.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text("Saved Players list is empty",
                              style: TextStyle(
                                color: thisTheme.textColor,
                              )),
                    )),
                widget.savedplayers.isNotEmpty
                    ? const SizedBox(height: stdHorizontalOffset / 2)
                    : Container(),
                Flexible(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        height: (stdHeight + stdHorizontalOffset / 2) *
                            widget.savedplayers.length,
                        child: PlayerList(
                            players: widget.savedplayers,
                            addPlayer: widget.addPlayer,
                            saved: true,
                            callbackFunction: callback),
                      )),
                ),
              ],
            )));
  }
}

// Класс отрисовки списка игроков. Принимает массив (this/saved), метод добавления, bool значение this или saved и функцию отрисовки.
// В дальнейшем думал сделать перемещение игроков местами но пока не получилось.
class PlayerList extends StatefulWidget {
  const PlayerList(
      {Key? key,
      required this.players,
      required this.addPlayer,
      required this.saved,
      required this.callbackFunction})
      : super(key: key);
  final List players;
  final Function callbackFunction;
  final void Function(Player, bool)? addPlayer;
  final bool saved;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  Widget build(BuildContext contextt) {
    return Column(
      children: <Widget>[
        for (int index = 0; index < widget.players.length; index++)
          Expanded(
              //key: ValueKey(index),
              child: _playerCards(index)),
      ],
      /*onReorder:(int oldIndex, int newIndex){
    setState((){
    if (oldIndex < newIndex) {
    newIndex -=1;
    }
    final int item = widget.players.removeAt(oldIndex);
    widget.players.insert(newIndex,item);
    });
    widget.callbackFunction();
    }
    */
    );
  }

// Карточка игрока. Принимает индекс. Массив берет из родительского класса.
  Widget _playerCards(int index) => Dismissible(
      key: Key(widget.players[index].name),
      child: Padding(
        padding: const EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Container(
          padding: const EdgeInsets.only(right: stdEdgeOffset * 0.7),
          decoration: BoxDecoration(
            color: thisTheme.playerColor,
            borderRadius: BorderRadius.circular(20),
            //border:Border.all(
            //  width:1,
            //  color:Colors.black,
            //)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.1 * stdHeight),
                    child: Container(
                      width: stdHeight * 0.8,
                      height: stdHeight * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                              '${widget.players[index].assetUrl}',
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.players[index].name,
                          style: TextStyle(
                            color: thisTheme.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: stdFontSize * 0.75,
                          ),
                        ),
                        if (!widget.saved)
                          Text(
                            '${widget.players[index].bank}',
                            style: TextStyle(
                                color: thisTheme.textColor,
                                fontSize: stdFontSize * 0.75),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () async {
                    /*
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _deleteConfirm(index, context);
                          },
                        );*/
                    _quickDelete(index);
                  },
                  icon: Icon(
                    Icons.delete_sweep,
                    color: thisTheme.bgrColor,
                    size: stdIconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        /*if (direction == DismissDirection.endToStart) {
                              widget.players.removeAt(index);
                              widget.callbackFunction();
                          }*/
      },
      background: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(widget.saved ? Icons.add : Icons.save,
                color: thisTheme.playerColor, size: stdIconSize),
            Text(widget.saved ? ' Add Player' : ' Save Player',
                style: TextStyle(
                    color: thisTheme.playerColor,
                    fontSize: stdFontSize * 0.75)),
          ],
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.red, size: stdIconSize),
            Text('Delete Player',
                style:
                    TextStyle(color: Colors.red, fontSize: stdFontSize * 0.75)),
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.addPlayer!(widget.players[index], !widget.saved);
          //widget.callbackFunction();
          return false;
        }
        _quickDelete(index);
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
  Widget _deleteConfirm(int index, dynamic context) => Dialog(
        backgroundColor: thisTheme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
            vertical: stdEdgeOffset,
            horizontal: (MediaQuery.of(context).size.width - 360) / 2),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          padding: const EdgeInsets.all(
            stdHorizontalOffset,
          ),
          height: stdDialogHeight,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Delete Confirmation",
                    style: TextStyle(
                        color: thisTheme.textColor,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.bold)),
                Flexible(
                  fit: FlexFit.loose,
                  //fit: BoxFit.cover,
                  child: Center(
                    child: Text("Are you sure you want to delete this player?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: thisTheme.textColor,
                            fontSize: stdFontSize * 0.75)),
                  ),
                ),
                Flexible(
                  //height: stdFontSize*1.5,
                  fit: FlexFit.loose,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              widget.players.removeAt(index);
                              Navigator.of(context).pop(true);
                              widget.callbackFunction();
                            },
                            child: const Text("Delete",
                                style: TextStyle(
                                    fontSize: stdFontSize * 0.75,
                                    color: Colors.red))),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: stdFontSize * 0.75,
                                color: thisTheme.playerColor,
                              )),
                        ),
                      ]),
                )
              ]),
        ),
      );

// Функция быстрого удаления. Альтернатива карточке подтверждения.
  void _quickDelete(int index) {
    widget.players.removeAt(index);
    widget.callbackFunction();
  }
}

// Кнопка добавления игрока
class AddWindow extends StatefulWidget {
  const AddWindow({Key? key, required this.addPlayer, required this.bank})
      : super(key: key);

  final void Function(Player, bool)? addPlayer;
  final int bank;
  //int tmpBank = 0 ;
  @override
  _AddWindowState createState() => _AddWindowState();
}

class _AddWindowState extends State<AddWindow> {
  String standartLogo = 'assets/faces/pokerfaces0.jpg';
  String newName = '';

  void changeLogo(String newLogo) {
    setState(() {
      standartLogo = newLogo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          vertical: stdEdgeOffset,
          horizontal: (MediaQuery.of(context).size.width - 360) / 2),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //contentPadding: EdgeInsets.zero,
      //title:const Center(child: Text('Add Player')),
      child: _settingNewPlayer(),
    );
  }

  Widget _settingNewPlayer() => Container(
        //margin: MediaQuery.of(context).viewInsets,
        padding: const EdgeInsets.all(
          stdHorizontalOffset,
        ),
        //padding: ediaQuery.viewInsets,
        height: stdDialogHeight,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await showGeneralDialog(
                  //duration: Duration(microseconds: 0),
                    barrierColor: Colors.transparent,
                    transitionDuration: const Duration(milliseconds: 500),
                    context: context,
                    //child: PickIcon(changeLogo: changeLogo),
                    pageBuilder: (context,a1,a2){return PickIcon(changeLogo: changeLogo);},
                    transitionBuilder: dialogWave1,
                    );
              },
              child: Stack(
                children: [
                  Container(
                    width: stdHeight,
                    height: stdHeight,
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
                    width: stdHeight,
                    height: stdHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color:
                              (standartLogo != 'assets/faces/pokerfaces0.jpg')
                                  ? thisTheme.mainColor
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
              //fit: FlexFit.loose,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: stdFontSize,
                      child: Text(
                        'New Player',
                        style: TextStyle(
                          color: thisTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: stdFontSize,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                          style: TextStyle(
                            color: thisTheme.textColor,
                            fontSize: stdFontSize * 0.85,
                          ),
                          maxLength: 20,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.playerColor,
                              ),
                              hintText: "Name",
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(color: thisTheme.textColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: (newName != "")
                                        ? thisTheme.mainColor
                                        : thisTheme.playerColor),
                              ),
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            newName = value;
                            setState(() {});
                          }),
                    ),
                    const SizedBox(
                      height: stdHorizontalOffset / 2,
                    ),
                    //stdHeight*0.75
                    Container(
                      height: stdHeight * 0.75,
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ((newName != "") &&
                                        (standartLogo !=
                                            'assets/faces/pokerfaces0.jpg'))
                                    ? thisTheme.mainColor
                                    : thisTheme.playerColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: const BorderSide(color: Color.fromARGB(255, 33, 63, 34))
                            ))),
                        onPressed: () {
                          // проверка чтобы челикс не ввел пустой символ
                          if ((newName != "") &&
                              (standartLogo !=
                                  'assets/faces/pokerfaces0.jpg')) {
                            Navigator.of(context).pop();
                            widget.addPlayer!(
                                Player(newName, standartLogo, widget.bank),
                                false);
                          }
                        },
                        child: Text('Add',
                            style: TextStyle(
                                color: thisTheme.bgrColor,
                                fontSize: stdFontSize * 0.75)),
                      ),
                    ),
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
  const PickIcon({Key? key, required this.changeLogo}) : super(key: key);
  final void Function(String) changeLogo;
  
  @override
  State<PickIcon> createState() => _PickIconState();
}

class _PickIconState extends State<PickIcon> {
  int choosenIcon = -1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          vertical: stdEdgeOffset,
          horizontal: (MediaQuery.of(context).size.width - 360) / 2
          ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //contentPadding: EdgeInsets.zero,
      //title:const Center(child: Text('Add Player')),
      child: _pickIcon(),
    );
  }

  Widget _pickIcon() => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            //horizontal: 70*50/stdHeight,
            vertical:
                (stdDialogHeight - 2 * stdHeight - stdHorizontalOffset / 2) /
                    2),
        height: stdDialogHeight,
        width: double.infinity,
        child: SizedBox(
          width: (stdHeight) * 4 + 3 * stdHorizontalOffset / 2,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  
                  setState(() {
                    choosenIcon = index;
                  });
                  widget.changeLogo('assets/faces/pokerfaces${index + 1}.jpg');
                },
                child: Padding(
                  padding: const EdgeInsets.all(stdHorizontalOffset / 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: (index==choosenIcon)? 1.5 :0,
                          color:
                              (index==choosenIcon)
                                  ? thisTheme.mainColor
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

class AddSettings extends StatefulWidget {
  const AddSettings({Key? key, required this.bank, required this.bankUpdate})
      : super(key: key);
  final int bank;
  final void Function(int) bankUpdate;
  @override
  State<AddSettings> createState() => _AddSettingsState();
}

class _AddSettingsState extends State<AddSettings> {
  int smallBlind = 0;
  int bigBlind = 0;
  bool autoBlind = false;
  int autoIntBlind = 0;
  int tmpBank = 0;
  int autoTime = 0;
  var msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - 360) / 2),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: _settingsWindow(),
    );
  }

  @override
  void initState() {
    // загрузка игроков с прошлого раза
    super.initState();
    tmpBank = widget.bank;
    smallBlind = tmpBank ~/ 100;
    bigBlind = smallBlind * 2;
    autoIntBlind = bigBlind;
    autoTime = 15;
  }

  Widget _settingsWindow() => Container(
        width: double.infinity,
        //margin: EdgeInsets.symmetric(horizontal: stdEdgeOffset*1.5),
        padding: const EdgeInsets.symmetric(
          vertical: stdHorizontalOffset * 1.5,
          horizontal: stdEdgeOffset * 2.5,
        ),
        height: stdDialogHeight + 4 * stdHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text('Game Settings',
                  style: TextStyle(
                      color: thisTheme.textColor,
                      fontSize: stdFontSize,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            SizedBox(

                //color: Colors.red,
                height: stdHeight * 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text('Bank',
                          style: TextStyle(
                              color: thisTheme.textColor,
                              fontSize: stdFontSize * 0.85,
                              fontWeight: FontWeight.normal)),
                    ),
                    const Flexible(flex: 3, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: thisTheme.textColor,
                            fontSize: stdFontSize * 0.85,
                          ),
                          maxLength: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.playerColor,
                              ),
                              hintText: "${widget.bank}",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            tmpBank = (value != '') ? int.parse(value) : 0;
                            smallBlind = tmpBank ~/ 100;
                            msgController.clear();
                            bigBlind = smallBlind * 2;
                            autoIntBlind = bigBlind;
                            setState(() {});
                          }),
                    )
                  ],
                )),
            SizedBox(

                //color: Colors.red,
                height: stdHeight * 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text('Small Blind',
                          style: TextStyle(
                              color: thisTheme.textColor,
                              fontSize: stdFontSize * 0.85,
                              fontWeight: FontWeight.normal)),
                    ),
                    const Flexible(flex: 3, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: TextField(
                          controller: msgController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: thisTheme.textColor,
                            fontSize: stdFontSize * 0.85,
                          ),
                          maxLength: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.playerColor,
                              ),
                              hintText: "$smallBlind",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            smallBlind = value != '' ? int.parse(value) : 0;
                            (smallBlind < tmpBank)
                                ? DoNothingAction()
                                : smallBlind = tmpBank ~/ 100;
                            bigBlind = 2 * smallBlind;
                            autoIntBlind = bigBlind;
                            setState(() {});
                          }),
                    )
                  ],
                )),
            SizedBox(

                //color: Colors.red,
                height: stdHeight * 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text('Big Blind',
                          style: TextStyle(
                              color: thisTheme.playerColor,
                              fontSize: stdFontSize * 0.85,
                              fontWeight: FontWeight.normal)),
                    ),
                    const Flexible(flex: 3, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: Text('$bigBlind',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: thisTheme.playerColor,
                              fontSize: stdFontSize * 0.85,
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                )),
            ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(0),
                elevation: 0,
                expansionCallback: (i, autolind) {
                  setState(() {
                    autoBlind = !autoBlind;
                  });
                },
                children: [
                  ExpansionPanel(
                    hasIcon: false,
                    canTapOnHeader: false,
                    isExpanded: autoBlind,
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
                                  Flexible(
                                    flex: 4,
                                    child: Text('Auto Rise',
                                        style: TextStyle(
                                            color: thisTheme.textColor,
                                            fontSize: stdFontSize * 0.85,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  const Flexible(flex: 3, child: SizedBox()),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: stdHeight * 0.75,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                autoBlind
                                                    ? thisTheme.mainColor
                                                    : thisTheme.playerColor),
                                        value: autoBlind,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            autoBlind = value!;
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
                              width: autoBlind ? 250 : 0,
                              height: 1,
                            ),
                          ),
                        ],
                      );
                    },
                    body: Column(
                      children: [
                        SizedBox(
                            height: stdHeight * 0.75,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Step    ',
                                    style: TextStyle(
                                        color: thisTheme.textColor,
                                        fontSize: stdFontSize * 0.85,
                                        fontWeight: FontWeight.normal)),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: NumberPicker(
                                        haptics: true,
                                        selectedTextStyle: TextStyle(
                                            color: thisTheme.mainColor,
                                            fontSize: stdFontSize,
                                            fontWeight: FontWeight.normal),
                                        textStyle: TextStyle(
                                            color: thisTheme.playerColor,
                                            fontSize: stdFontSize * 0.65,
                                            fontWeight: FontWeight.normal),
                                        itemWidth: stdHeight,
                                        value: autoIntBlind,
                                        axis: Axis.horizontal,
                                        itemCount: 3,
                                        step:
                                            (((tmpBank ~/ 2 - bigBlind) ~/ 5) >
                                                    0)
                                                ? (tmpBank ~/ 2 - bigBlind) ~/ 5
                                                : 1,
                                        minValue: bigBlind,
                                        maxValue: tmpBank ~/ 2,
                                        onChanged: (value) {
                                          autoIntBlind = bigBlind;
                                          setState(() {
                                            autoIntBlind = value;
                                          });
                                        }),
                                  ),
                                ),
                                Text('  min    ',
                                    style: TextStyle(
                                        color: thisTheme.bgrColor,
                                        fontSize: stdFontSize * 0.85,
                                        fontWeight: FontWeight.normal)),
                              ],
                            )),
                        SizedBox(
                            height: stdHeight * 0.75,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Period',
                                    style: TextStyle(
                                        color: thisTheme.textColor,
                                        fontSize: stdFontSize * 0.85,
                                        fontWeight: FontWeight.normal)),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: NumberPicker(
                                        haptics: true,
                                        selectedTextStyle: TextStyle(
                                            color: thisTheme.mainColor,
                                            fontSize: stdFontSize,
                                            fontWeight: FontWeight.normal),
                                        textStyle: TextStyle(
                                            color: thisTheme.playerColor,
                                            fontSize: stdFontSize * 0.65,
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
                                Text('  min    ',
                                    style: TextStyle(
                                        color: thisTheme.textColor,
                                        fontSize: stdFontSize * 0.85,
                                        fontWeight: FontWeight.normal)),
                              ],
                            )),
                      ],
                    ),
                  ),
                ]),
            Container(
              height: stdHeight * 0.75,
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(thisTheme.mainColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: const BorderSide(color: Color.fromARGB(255, 33, 63, 34))
                    ))),
                onPressed: () {
                  // проверка чтобы челикс не ввел пустой символ
                  Navigator.of(context).pop();
                },
                child: Text('Save Changes',
                    style: TextStyle(
                        color: thisTheme.bgrColor,
                        fontSize: stdFontSize * 0.75)),
              ),
            ),
          ],
        ),
      );
}
