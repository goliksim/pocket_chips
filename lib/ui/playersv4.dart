import 'package:flutter/material.dart';
import '../internal/application.dart';


// Конфиг UI. Отступы, стандартные размеры и т.д.
const double stdHeight = 50;
const double stdHorizontalOffset = stdHeight/5;
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
  int standartBank = 200;
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
        if ((!thisPlayers.contains(newPlayer))&&(thisPlayers.length<maxPlayerCount)) {
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
              await showDialog(
                  context: context,
                  builder: (BuildContext contextFaces) {
                    //окно с сохраненными игроками
                    return SavedPlayer(
                      savedplayers: savedPlayers,
                      addPlayer: addPlayer,
                    );
                  });
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
            BankWindow(bank: standartBank, update: bankUpdate),
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

  Widget _addBotton() => Padding(
        padding: const EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Container(
          // кнопка добавить
          width: double.infinity,
          height: double.infinity,
          child: IconButton(
            //padding: const EdgeInsets.only(right: 25.0),
            icon: Icon(
              Icons.add,
              color: thisTheme.stdIconColor,
              size: stdIconSize,
            ),
            tooltip: 'Add From List',
            onPressed: () async {
              await showDialog(
                  //barrierDismissible: false,
                  context: context,
                  builder: (BuildContext contextFaces) {
                    return AddWindow(addPlayer: addPlayer, bank: standartBank);
                  });
            },
            //confirmPress:
          ),
          decoration: BoxDecoration(
            color: thisTheme.bankColor,
            borderRadius: BorderRadius.circular(20),
            //border:Border.all(
            //  width:1,
            //  color:Colors.black,
            //)
          ),
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
            Container(
              //Game Settings
              height: stdHeight,
              decoration: BoxDecoration(
                color: thisTheme.mainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Game Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: thisTheme.bgrColor,
                    fontSize: stdFontSize,
                  ),
                ),
              ),
            ),
            Container(
              //Start Game
              height: stdHeight,
              decoration: BoxDecoration(
                color: thisTheme.submainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Start Game",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: thisTheme.bgrColor,
                      fontSize: stdFontSize,
                    ),
                  )),
            )
          ],
        ),
      );
}

// Класс игрока
class Player {
  Player(this.name, this.assetUrl, this.bank);

  final String name;      // Имя
  final String assetUrl;  // Логотип
  int bank = 0;           // Банк

  //Функция обновления денег
  void changeBank(int newbank) {
    bank = newbank;
  }

  @override
  //перегруженный оператор == для недобавления существующих игроков
  bool operator ==(covariant Player other) => ((name == other.name) && (assetUrl == other.assetUrl));
  // Ругается, что я не проверяю хешкод (ссылку на объект). Но нам не важно, один это объект или нет, главное чтобы они были разные по значению.
}

// Ячейка банка
class BankWindow extends StatelessWidget {
  const BankWindow({Key? key, required this.bank, required this.update})
      : super(key: key);
  final int bank;
  final ValueChanged<int> update;
  
  //int tmp_bank = 0 ;

  @override
  Widget build(BuildContext context) {
    int tmpBank = bank;
    return Container(
      child: TextButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
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
                      '$bank',
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
        ),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: thisTheme.bgrColor,
                  insetPadding: EdgeInsets.symmetric(
                      horizontal:
                          (MediaQuery.of(context).size.width - 360) / 2),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
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
                            style: TextStyle(color: thisTheme.textColor,fontSize: stdFontSize * 0.85,),
                            maxLength: 10,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: stdFontSize * 0.85,
                                  color: thisTheme.bgrColor,
                                ),
                                hintText: "$bank",
                                enabledBorder: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide:
                                      BorderSide(color: thisTheme.mainColor),
                                ),
                                counterText: ''),
                            //initialValue: newName,
                            onChanged: (String value) {
                              //newName = value;
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          thisTheme.mainColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    //side: const BorderSide(color: Color.fromARGB(255, 33, 63, 34))
                                  ))),
                              onPressed: () {
                                update(tmpBank);
                                Navigator.of(context).pop();
                              },
                              child: Text('Enter',
                                  style: TextStyle(
                                      color: thisTheme.bgrColor,
                                      fontSize: stdFontSize * 0.75))),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      height: stdHeight,
      decoration: BoxDecoration(
        color: thisTheme.bankColor,
        borderRadius: BorderRadius.circular(20),
        //border:Border.all(
        //  width:1,
        //  color:Colors.black,
        //)
      ),
    );
  }
  
}

// Кнопка добавления игрока
class AddWindow extends StatefulWidget {
  const AddWindow({Key? key, required this.addPlayer, required this.bank})
      : super(key: key);

  final void Function(Player, bool)? addPlayer;
  final int bank;
  //int tmp_bank = 0 ;
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

                await showDialog(
                    barrierColor: null,
                    context: context,
                    builder: (BuildContext context) {
                      return PickIcon(changeLogo: changeLogo);
                    });
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
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
                      height: stdFontSize ,
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
                          style: TextStyle(color: thisTheme.textColor,fontSize: stdFontSize * 0.85,),
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
                                borderSide:
                                    BorderSide(color: thisTheme.mainColor),
                              ),
                              counterText: ''),
                          //initialValue: newName,
                          onChanged: (String value) {
                            newName = value;
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
                                thisTheme.mainColor),
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
class PickIcon extends StatelessWidget {
  const PickIcon({Key? key, required this.changeLogo}) : super(key: key);
  final void Function(String) changeLogo;

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
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 4,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  changeLogo('assets/faces/pokerfaces${index + 1}.jpg');
                },
                child: Padding(
                  padding: const EdgeInsets.all(stdHorizontalOffset / 2),
                  child: Container(
                    decoration: BoxDecoration(
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

// Класс окна с сохраненными игроками. Принимает массив сохраненных игроков и метод добавления addPlayer.
class SavedPlayer extends StatefulWidget {
  const SavedPlayer({
    Key? key,
    required this.savedplayers,
    required this.addPlayer,
  }) : super(key: key);
  final List savedplayers;
  final void Function(Player, bool) addPlayer;
  //int tmp_bank = 0 ;
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
          padding: const EdgeInsets.only(top:stdEdgeOffset,bottom:stdEdgeOffset,left:stdEdgeOffset,right:stdEdgeOffset),

            //color: Colors.red,
            height: (stdHeight + stdHorizontalOffset / 2) * (widget.savedplayers.length<8? widget.savedplayers.length: 8)  +
                stdFontSize * 1 + stdEdgeOffset*2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [SizedBox(
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
                widget.savedplayers.isNotEmpty? const SizedBox(height:stdHorizontalOffset/2): Container(),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        height:
            (stdHeight + stdHorizontalOffset / 2) * widget.savedplayers.length,
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
