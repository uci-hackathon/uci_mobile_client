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

class UciCard extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  UciCard({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: Container(
          width: double.infinity,
          height: h * 0.3,
          padding: EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
