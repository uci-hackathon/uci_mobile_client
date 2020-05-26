import 'package:flutter/material.dart';

Widget uciAppBar() {
  return AppBar(
    elevation: 0.0,
    centerTitle: false,
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/uci.png',
          width: 50,
        ),
        SizedBox(width: 10),
        Text('Universal Creator\nincome'),
      ],
    ),
  );
}
