import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/*
void main() {
  runApp(const MyApp());
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      designSize: const Size(320, 640),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var physicalScreenSize = window.physicalSize;
  

  void _incrementCounter() {
    setState(() {
      physicalScreenSize = window.physicalSize;
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [],
        ),
        
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(10.0.h),
            child: (constraints.maxWidth > 620.h)
                ? Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widgets(context, physicalScreenSize),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widgets(context, physicalScreenSize),
                    ),
                  ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _incrementCounter();
            
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

List<Widget> widgets(BuildContext context, Size physicalScreenSize) => [
      Column(
        children: [
          MyButton(
            child: Text(
              'MediaQuery size',
              style: TextStyle(fontSize: 20.h),
            ),
          ),
          MyButton(
            color: Colors.green,
            child: Text(
              '${MediaQuery.of(context).size.height},${MediaQuery.of(context).size.width.h}',
              style: TextStyle(fontSize: 20.h),
            ),
          ),
        ],
      ),
      Column(
        children: [
          MyButton(
            child: Text(
              'Physical size',
              style: TextStyle(fontSize: 20.h),
            ),
          ),
          MyButton(
            color: Colors.green,
            child: Text(
              '${physicalScreenSize.height},${physicalScreenSize.width}',
              style: TextStyle(fontSize: 20.h),
            ),
          ),
        ],
      ),
    ];

class MyButton extends StatelessWidget {
  MyButton({Key? key, this.child, this.color = Colors.red}) : super(key: key);
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child:
            Container(color: color, height: 50.h, width: 300.h, child: child),
      );
}
