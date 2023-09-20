//КЛАСС С ТЕМАМИ ПРИЛОЖЕНИЯ
import 'package:flutter/material.dart';



class Themes {
  String name;
  Color bgrColor;
  Color bankColor;
  Color playerColor;
  Color additionButtonColor;
  MaterialColor primaryColor;
  Color secondaryColor;
  Color subsubmainColor;
  Color onBackground;
  Color onPrimary;

  Themes(
      this.name,
      this.bgrColor,
      this.bankColor,
      this.playerColor,
      this.additionButtonColor,
      this.primaryColor,
      this.secondaryColor,
      this.subsubmainColor,
      this.onBackground,
      this.onPrimary);
      
      @override
      //Override `hashCode` if overriding `==`.
      bool operator ==(covariant Themes other) =>
      ((name == other.name));
      
}

Themes light = Themes(
  "light",
  const Color.fromARGB(255, 248, 247, 250), // bgrColor
  const Color.fromARGB(255, 215, 213, 245), // bankColor
  const Color.fromARGB(255, 255, 255, 255), // playerColor
  const Color.fromARGB(255, 54, 60, 87),    //additionButtonColor               
  MaterialColor(0xff7064df, colorLight), // primaryColor
  const Color.fromARGB(255, 91, 112, 200),    // secondaryColor
  const Color.fromARGB(255, 229, 115, 115),   //subsubmainColor
  const Color.fromARGB(255, 54, 60, 87),      // onBackground
  Colors.white,                         // onPrimary
);

Themes dark = Themes(
  "dark",
  const Color.fromARGB(255, 29, 29, 34), // bgrColor
  const Color.fromARGB(255, 40, 40, 50),      // bankColor
  const Color.fromARGB(255,36, 35, 45),      // playerColor
  const Color.fromARGB(255,70, 78, 109), //additionButtonColor
  MaterialColor(0xff8882e6, colorLight),       // primaryColor
  const Color.fromARGB(255, 111, 130, 213),         // secondaryColor
  const Color.fromARGB(255, 230, 130, 130), // subsubmainColor
  const Color.fromARGB(255,241, 241, 251) ,                       // onBackground
  Colors.white,   // onPrimary
);

Map<int, Color> colorLight =
{
50:const Color.fromRGBO(76,175,80, .1),
100:const Color.fromRGBO(76,175,80, .2),
200:const Color.fromRGBO(76,175,80, .3),
300:const Color.fromRGBO(76,175,80, .4),
400:const Color.fromRGBO(76,175,80, .5),
500:const Color.fromRGBO(76,175,80, .6),
600:const Color.fromRGBO(76,175,80, .7),
700:const Color.fromRGBO(76,175,80,.8),
800:const Color.fromRGBO(76,175,80, .9),
900:const Color.fromRGBO(76,175,80, 1),
};