import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';






class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
void initState(){
  super.initState();

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).systemGestureInsets.top > 24? MediaQueryData.fromWindow(window).systemGestureInsets.top: 0 ),
        child: Scaffold(
          appBar: AppBar(
            title: Text("${MediaQueryData.fromWindow(window).systemGestureInsets.top}"),
          ),
          body:Center(
            child: Container(height: 50,
            child: Text("${MediaQuery.of(context).padding.top}"),)
          )
        ),
      ),
    );
  }
}