import 'package:flutter/material.dart'; // подключаем библиотеку material

import 'package:firstapp/homepage.dart' as homepage; // файлик с функцией стартовой страницы

void main() {
  runApp( const MyApp() );
}

class MyApp extends StatelessWidget 
{
  const MyApp({Key? key}) : super(key: key); // ничего не принимаем по началу

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Your Poker Kit', 
      theme: ThemeData(primarySwatch: Colors.green,),
      debugShowCheckedModeBanner: false,                  // скрываем надпись debug
      home: const homepage.HomePage(title: 'Your Poker Kit')  // вызов стартовой страницы
    );
  }
}
