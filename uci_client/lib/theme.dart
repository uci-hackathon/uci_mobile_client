import 'package:flutter/material.dart';

final _primaryColor = Color.fromARGB(255, 5, 0, 255);
final _secondaryColor = Color.fromARGB(255, 77, 190, 80);

final uciTheme = ThemeData(
  splashColor: _primaryColor,
  canvasColor: Colors.white,
  brightness: Brightness.light,
  highlightColor: _primaryColor,
  accentColor: _primaryColor,
//  textTheme: TextTheme(
//    overline: smallTextStyle,
//    display1: titleStyle,
//    title: clickableTextStyle,
//    body1: textStyle,
//    body2: clickableTextStyle,
//  ),
  fontFamily: 'Favorit',
  textSelectionColor: _primaryColor,
  textSelectionHandleColor: _primaryColor,
  primarySwatch: MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  ),
  buttonColor: _secondaryColor,
  primaryIconTheme: IconThemeData(color: Colors.black),
  cardColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
);
