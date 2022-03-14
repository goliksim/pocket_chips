import 'package:flutter/material.dart';

const double stdHeight = 50;
const double stdHorizontalOffset = 10;
const double stdEdgeOffset = 15;
const double stdFontSize = stdHeight * 0.4;
const double newPlayerHeight = 135 * stdHeight / 50;
const double stdIconSize = stdHeight / 2;

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
      Player('Billy Herrington', 'assets/faces/pokerfaces8.jpg', standartBank),
      Player('Billy Herrington', 'assets/faces/pokerfaces8.jpg', standartBank),
      Player('Billy Herrington', 'assets/faces/pokerfaces8.jpg', standartBank),
    ]);
    savedPlayers.addAll([
      //Player('Van DarkHole1', 'assets/faces/pokerfaces1.jpg', 0),
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
        savedPlayers.add(newPlayer);
      } else {
        newPlayer.changeBank(standartBank);
        thisPlayers.add(newPlayer);
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
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontSize: stdFontSize),
        elevation: 0,
        title: const Text('Player Menu'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 25.0),
            icon: const Icon(
              Icons.person_add,
              color: Colors.black,
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
      backgroundColor: Colors.white,
      body: Container(
        // главный контейнер с отступом
        margin: const EdgeInsets.all(stdEdgeOffset),
        child: Column(
          // колонка чтобы можно было разделить экран на верхнюю часть и нижние статичные кнопки
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  // колонка с верхним банком,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BankWindow(
                        bank: standartBank, update: bankUpdate), //окно с банком
                    //отступ
                    const SizedBox(
                      height: stdHorizontalOffset,
                    ),
                    //отступ
                    Flexible(
                      child: SizedBox(
                        child: PlayerList(
                            players: thisPlayers,
                            addPlayer: addPlayer,
                            saved: false,
                            callbackFunction: callback),
                      ),
                    ),
                    //отступ
                    const SizedBox(
                      height: stdHorizontalOffset / 2,
                    ),
                    
                    const SizedBox(
                      height: stdHorizontalOffset,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _lowerButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lowerButton() => SizedBox(
        height: stdHeight * 2 + stdHorizontalOffset,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              //Game Settings
              height: stdHeight,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 177, 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Game Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 9, 117, 0),
                    fontSize: stdFontSize,
                  ),
                ),
              ),
            ),
            Container(
              //Start Game
              height: stdHeight,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 162, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Start Game",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 0, 77, 128),
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
  String name = '';
  String assetUrl = '';
  int bank = 0;
  Player(this.name, this.assetUrl, this.bank);

  void changeBank(int newbank) {
    bank = newbank;
  }
}

//Ячейка банка
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
                const Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 147, 147, 147),
                  size: stdIconSize,
                ),
                Row(
                  children: [
                    const Text(
                      'Bank:  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: stdFontSize,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$bank',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: stdFontSize,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: stdIconSize,
                ),
              ]),
        ),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width-360)/2),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
                    padding: const EdgeInsets.all(
                      stdHorizontalOffset,
                    ),
                    height: newPlayerHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text('Enter new bank:',
                              style: TextStyle(
                                  fontSize: stdFontSize,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: stdHorizontalOffset / 2,
                        ),
                        Flexible(
                          //fit: FlexFit.loose,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 236, 236, 236),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                    fontSize: stdFontSize * 0.85,
                                    color: Color.fromARGB(255, 194, 194, 194)),
                                hintText: "$bank",
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.center,

                              style:
                                  const TextStyle(fontSize: stdFontSize * 0.85),
                              //initialValue: "$bank",
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                tmpBank = int.parse(value);
                              },
                            ),
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
                              child: const Text('Enter',
                                  style:
                                      TextStyle(fontSize: stdFontSize * 0.75))),
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
        color: const Color.fromARGB(255, 147, 147, 147),
        borderRadius: BorderRadius.circular(20),
        //border:Border.all(
        //  width:1,
        //  color:Colors.black,
        //)
      ),
    );
  }
}

//кнопка добавления игрока
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
  bool firstwindow = true;

  void firstWindow(bool newWindow) {
    setState(() {
      firstwindow = newWindow;
    });
  }

  void changeLogo(String newLogo) {
    setState(() {
      standartLogo = newLogo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: stdEdgeOffset),
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
        height: newPlayerHeight,
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
                    const SizedBox(
                      height: stdFontSize * 0.75,
                      child: Text(
                        'Name:',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: stdFontSize * 0.75,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          //side: const BorderSide(color: Color.fromARGB(255, 33, 63, 34))
                        ))),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.addPlayer!(
                              Player(newName, standartLogo, widget.bank),
                              false);
                        },
                        child: const Text('Add',
                            style: TextStyle(fontSize: stdFontSize * 0.75)),
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

class PickIcon extends StatelessWidget {
  const PickIcon({Key? key, required this.changeLogo}) : super(key: key);
  final void Function(String) changeLogo;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
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
                (newPlayerHeight - 2 * stdHeight - stdHorizontalOffset / 2) /
                    2),
        height: newPlayerHeight,
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
      insetPadding: const EdgeInsets.all(15),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //contentPadding: EdgeInsets.zero,
      //title:const Center(child: Text('Add Player')),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: PlayerList(
            players: widget.savedplayers,
            addPlayer: widget.addPlayer,
            saved: true,
            callbackFunction: callback),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.players.length * (stdHeight + stdHorizontalOffset / 2) -
          (widget.players.isNotEmpty
              ? stdHorizontalOffset / 2
              : -stdFontSize * 1.5) +
          (widget.saved ? stdFontSize * 1.5 : 0),
      width: double.infinity,
      //color: Colors.green,
      child: Column(
        children: widget.players.isNotEmpty
            ? <Widget>[
                widget.saved
                    ? const SizedBox(
                        height: stdFontSize * 1.5,
                        child: Text(
                          "Saved Players",
                          style: TextStyle(fontSize: stdFontSize),
                        ))
                    : const SizedBox(height: 0),
                Flexible(
                  child: ListView.builder(
                      physics: widget.saved
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      itemCount: widget.players.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: Key(widget.players[index].name),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: stdEdgeOffset * 0.7),
                                  height: stdHeight,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 228, 228, 228),
                                    borderRadius: BorderRadius.circular(20),
                                    //border:Border.all(
                                    //  width:1,
                                    //  color:Colors.black,
                                    //)
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.1 * stdHeight),
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
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.players[index].name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        stdFontSize * 0.75,
                                                  ),
                                                ),
                                                if (!widget.saved)
                                                  Text(
                                                    '${widget.players[index].bank}',
                                                    style: const TextStyle(
                                                        fontSize:
                                                            stdFontSize * 0.75),
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
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return _deleteConfirm(
                                                    index, context);
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete_sweep,
                                            color: Colors.green,
                                            size: stdIconSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: stdHorizontalOffset / 2,
                                ),
                              ],
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
                                      color: const Color(0x80000000),
                                      size: stdIconSize),
                                  Text(
                                      widget.saved
                                          ? ' Add Player'
                                          : ' Save Player',
                                      style: const TextStyle(
                                          color: Color(0x80000000),
                                          fontSize: stdFontSize * 0.75)),
                                ],
                              ),
                            ),
                            secondaryBackground: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(Icons.delete,
                                      color: Colors.red, size: stdIconSize),
                                  Text('Delete Player',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: stdFontSize * 0.75)),
                                ],
                              ),
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                widget.addPlayer!(
                                    widget.players[index], !widget.saved);
                                //widget.callbackFunction();
                                return false;
                              }

                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _deleteConfirm(index, context);
                                },
                              );
                            });
                      }),
                ),
              ]
            : <Widget>[
                widget.saved
                    ? const Expanded(
                        child: Center(
                            child: Text("Saved Players list is empty",
                                style: TextStyle(fontSize: stdFontSize * 0.8))))
                    : const Expanded(
                        child: Center(
                            child: Text("To add players press add botton",
                                style: TextStyle(fontSize: stdFontSize * 0.8))))
              ],
      ),
    );
  }

  Widget _deleteConfirm(int index, dynamic context) => Dialog(
        insetPadding: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          padding: const EdgeInsets.all(
            stdHorizontalOffset,
          ),
          height: newPlayerHeight,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Delete Confirmation",
                    style: TextStyle(
                        fontSize: stdFontSize, fontWeight: FontWeight.bold)),
                const Flexible(
                  fit: FlexFit.loose,
                  //fit: BoxFit.cover,
                  child: Center(
                    child: Text("Are you sure you want to delete this player?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: stdFontSize * 0.75)),
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
                                    color: Colors.green))),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel",
                              style: TextStyle(
                                  fontSize: stdFontSize * 0.75,
                                  color: Colors.green)),
                        ),
                      ]),
                )
              ]),
        ),
      );
}
