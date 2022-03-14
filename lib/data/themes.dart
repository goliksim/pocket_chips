import 'package:flutter/material.dart';

class Themes {
  String name;
  Color bgrColor;
  Color bankColor;
  Color playerColor;
  Color mainplayerColor;
  MaterialColor mainColor;
  Color submainColor;
  Color textColor;
  Color stdIconColor;

  Themes(
      this.name,
      this.bgrColor,
      this.bankColor,
      this.playerColor,
      this.mainplayerColor,
      this.mainColor,
      this.submainColor,
      this.textColor,
      this.stdIconColor);
}

Themes light = Themes(
  "Light",
  Colors.white, // bgrColor
  const Color.fromARGB(255, 99, 99, 99), // bankColor
  Colors.grey, // playerColor
  Colors.grey, // mainplayerColor
  Colors.green, // mainColor
  Colors.blue, // submainColor
  Colors.black, // textColor
  Colors.black, // stdIconColor
);

Themes dark = Themes(
  "dark",
  const Color.fromARGB(255, 42, 42, 42), // bgrColor
  const Color.fromARGB(255, 68, 68, 68), // bankColor
  const Color.fromARGB(255, 93, 93, 93), // playerColor
  const Color.fromARGB(255, 126, 126, 126), // mainplayerColor
  Colors.amber, // submainColor
  const Color.fromARGB(255, 240, 174, 251), //mainColor
  Colors.white, // textColor
  Colors.white, // stdIconColor
);
