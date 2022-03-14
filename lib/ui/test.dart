import 'package:firstapp/internal/application.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title, required this.changeTheme})
      : super(key: key); // принимает значение title при обращении
  final String title;
  final Function() changeTheme;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                widget.changeTheme();
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
            child: Column(
              children: [
                Flexible(
                    flex: 1,
                    child: ReorderableListView(
                      children: <Widget>[
                        for (int index = 0; index < 3; index++)
                          FractionallySizedBox(
                            heightFactor: 1/3,
                            widthFactor: 1,
                            key: ValueKey(index),
                            child: Expanded(
                              child: Container(
                                color: Colors.green[100 * index]),
                            ),
                          )
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                      },
                    )),
                Flexible(flex: 1, child: Container(color: Colors.red))
              ],
            )));
  }
}
