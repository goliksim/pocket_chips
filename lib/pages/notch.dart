import 'package:flutter/material.dart';
//import 'dart:ui';
//import 'package:flutter/services.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
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
        padding: EdgeInsets.only(
          top: MediaQueryData.fromView(View.of(context))
                      .systemGestureInsets
                      .top >
                  24
              ? MediaQueryData.fromView(View.of(context))
                  .systemGestureInsets
                  .top
              : 0,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '${MediaQueryData.fromView(View.of(context)).systemGestureInsets.top}',
            ),
          ),
          body: Center(
            child: SizedBox(
              height: 50,
              child: Text('${MediaQuery.of(context).padding.top}'),
            ),
          ),
        ),
      ),
    );
  }
}
