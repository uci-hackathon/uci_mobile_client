import 'package:flutter/material.dart';

final _uciColor = Color.fromARGB(255, 5, 0, 255);

final uciTheme = ThemeData(
  splashColor: _uciColor,
  canvasColor: Colors.white,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  accentColor: _uciColor,
//  textTheme: TextTheme(
//    overline: smallTextStyle,
//    display1: titleStyle,
//    title: clickableTextStyle,
//    body1: textStyle,
//    body2: clickableTextStyle,
//  ),
  textSelectionColor: _uciColor,
  textSelectionHandleColor: _uciColor,
  primarySwatch: Colors.grey,
  buttonColor: _uciColor,
  primaryIconTheme: IconThemeData(color: Colors.black),
  cardColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
);
