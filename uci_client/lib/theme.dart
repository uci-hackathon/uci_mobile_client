import 'package:flutter/material.dart';

final _primaryColor = Color.fromARGB(255, 5, 0, 255);
final _secondaryColor = Color.fromARGB(255, 77, 190, 80);

final oldTheme = ThemeData();
final uciTheme = ThemeData(
  cursorColor: _primaryColor,
  splashColor: _primaryColor,
  canvasColor: Colors.white,
  brightness: Brightness.light,
  highlightColor: _primaryColor,
  accentColor: _primaryColor,
  textTheme: TextTheme(
    headline1: oldTheme.textTheme.headline1.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
    ),
    headline2: oldTheme.textTheme.headline2.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
    ),
    headline3: oldTheme.textTheme.headline3.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
    ),
    headline4: oldTheme.textTheme.headline4.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    headline5: oldTheme.textTheme.headline5.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
    ),
    headline6: oldTheme.textTheme.headline6.copyWith(
      fontFamily: 'FavoritStd',
      color: Colors.black,
    ),
    button: oldTheme.textTheme.button.copyWith(
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: oldTheme.textTheme.overline.apply(color: Colors.black),
    enabledBorder: OutlineInputBorder(),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(),
    errorBorder: OutlineInputBorder(),
  ),
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
  iconTheme: IconThemeData(color: Colors.black, opacity: 1.0),
  primaryIconTheme: IconThemeData(color: Colors.black),
  cardColor: Colors.white.withOpacity(0.2),
  scaffoldBackgroundColor: Colors.white,
);
