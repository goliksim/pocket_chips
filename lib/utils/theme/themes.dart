//КЛАСС С ТЕМАМИ ПРИЛОЖЕНИЯ
import 'package:flutter/material.dart';

import 'ui_values.dart';

class Themes {
  String name;
  Color bgrColor;
  Color bankColor;
  Color hintColor;
  Color playerColor;
  Color additionButtonColor;
  MaterialColor primaryColor;
  Color secondaryColor;
  Color alertColor;
  Color onBackground;
  Color onPrimary = Colors.white;
  Color successColor = Color.fromARGB(255, 94, 169, 117);

  Themes.light()
      : name = 'light',
        bgrColor = const Color.fromARGB(255, 245, 243, 249),
        bankColor = const Color.fromARGB(255, 215, 213, 245),
        hintColor = const Color.fromARGB(255, 185, 183, 212),
        playerColor = const Color.fromARGB(255, 255, 255, 255),
        additionButtonColor = const Color.fromARGB(255, 54, 60, 87),
        primaryColor = MaterialColor(0xff7064df, colorLight),
        secondaryColor = const Color.fromARGB(255, 91, 112, 200),
        alertColor = const Color.fromARGB(255, 229, 115, 115),
        onBackground = const Color.fromARGB(255, 54, 60, 87);

  Themes.dark()
      : name = 'dark',
        bgrColor = const Color.fromARGB(253, 25, 25, 32),
        bankColor = const Color.fromARGB(255, 48, 48, 62),
        hintColor = const Color.fromARGB(255, 93, 93, 115),
        playerColor = const Color.fromARGB(255, 36, 35, 45),
        additionButtonColor = const Color.fromARGB(255, 64, 69, 110),
        primaryColor = MaterialColor(0xff746ce5, colorLight),
        secondaryColor = const Color.fromARGB(255, 102, 126, 231),
        alertColor = const Color.fromARGB(255, 238, 98, 98),
        onBackground = const Color.fromARGB(255, 241, 241, 251);

  static const Map<int, Color> colorLight = {
    50: Color.fromRGBO(76, 175, 80, .1),
    100: Color.fromRGBO(76, 175, 80, .2),
    200: Color.fromRGBO(76, 175, 80, .3),
    300: Color.fromRGBO(76, 175, 80, .4),
    400: Color.fromRGBO(76, 175, 80, .5),
    500: Color.fromRGBO(76, 175, 80, .6),
    600: Color.fromRGBO(76, 175, 80, .7),
    700: Color.fromRGBO(76, 175, 80, .8),
    800: Color.fromRGBO(76, 175, 80, .9),
    900: Color.fromRGBO(76, 175, 80, 1),
  };

  TextStyle get appBarStyle => TextStyle(
        fontFamily: 'Ubuntu',
        color: onBackground,
        fontWeight: FontWeight.w500,
        fontSize: stdFontSize,
      );

  TextStyle get stdTextStyle => TextStyle(
        fontFamily: 'Ubuntu',
        color: onPrimary,
        fontWeight: FontWeight.w500,
      );

  @override
  //Override `hashCode` if overriding `==`.
  bool operator ==(covariant Themes other) => ((name == other.name));

  @override
  int get hashCode => name.length * bgrColor.toString().length;
}
