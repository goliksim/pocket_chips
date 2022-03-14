import 'package:flutter/material.dart'; // подключаем библиотеку material
import 'package:firstapp/ui/homepage.dart' as homepage;
//import 'package:firstapp/ui/test.dart' as test; //файл для отработки виджетов (песочница)
import '../data/themes.dart';

// Глобальные переменные темы. Доступны всем файлам приложухи вроде как.
List themeList = [light, dark];
Themes thisTheme = dark;



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key); 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

// Функция смены темы
void changeTheme() {
  if (thisTheme == themeList[0]) {
    thisTheme = themeList[1];
  } else {
    thisTheme = themeList[0];
  }
  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Your Poker Kit',
        theme: ThemeData(primarySwatch: thisTheme.mainColor),
        debugShowCheckedModeBanner: false, // скрываем надпись debug
        home: homepage.HomePage(
            title: 'Your Poker Kit', changeTheme: changeTheme) // вызов стартовой страницы
        );
  }
}
