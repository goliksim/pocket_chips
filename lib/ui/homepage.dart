import 'package:firstapp/internal/application.dart'; //для доступа к теме
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart'; // библиотека для ссылок
import 'package:firstapp/ui/playersv4.dart' as players;
import 'transitions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.changeTheme})
      : super(key: key); // принимает значение title при обращении
  final String title;
  final Function() changeTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)); // форма закругления

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //убрать стрелочку, так как это стартовая страница
        backgroundColor: thisTheme.mainColor,
        title: Text(
          widget.title,
          style: TextStyle(color: thisTheme.bgrColor),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 25.0),
            icon: Icon(
              Icons.settings,
              color: thisTheme.bgrColor,
              size: 35,
            ),
            tooltip: 'Add From List',
            onPressed: () {
              widget.changeTheme(); // смена темы
              setState(() {});
            },
            //confirmPress:
          ),
        ],
      ),
      backgroundColor: thisTheme.bgrColor,
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: (MediaQuery.of(context).size.width - 360) / 2),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //кнопочки
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            //width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                
                Navigator.push(context, SlidePageRoute(direction: AxisDirection.left, child: const players.PlayersPage(), childCurrent: widget));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10.0),
                //padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                shape: shape,
                //minimumSize: const Size(240,40),
                onPrimary: thisTheme.bgrColor,
                primary: thisTheme.mainColor,
                //side: const BorderSide(width: 2,color: Colors.blue) // - рамка
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('New Game'),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: shape,
                  padding: const EdgeInsets.all(10.0),
                  onPrimary: thisTheme.bgrColor,
                  primary: thisTheme.mainColor,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Continue'),
                onPressed: () {}),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: shape,
                  padding: const EdgeInsets.all(10.0),
                  onPrimary: thisTheme.bgrColor,
                  primary: thisTheme.submainColor,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Our Contacts'),
                onPressed: () async {
                  const url = 'https://vk.com/goliksim';
                  if (!await launch(url)) throw 'Could not launch $url';
                }),
          )
          // кнопка с ссылкой
        ])),
      ),
    );
  }
}
