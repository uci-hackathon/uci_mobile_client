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

class UciAvatar extends StatelessWidget {
  final ImageProvider image;
  final String username;

  UciAvatar({this.image, this.username});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      child: Text(
        username.substring(0, 2).toUpperCase(),
        style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
      ),
      backgroundImage: image,
    );
  }
}

class UciButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  UciButton({this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class LoadingPlaceholder extends StatefulWidget {
  final Widget child;
  final Key key;

  LoadingPlaceholder({this.child, this.key}) : super(key: key);

  @override
  LoadingPlaceholderState createState() => LoadingPlaceholderState();
}

class LoadingPlaceholderState extends State<LoadingPlaceholder> {
  var _isLoading = false;
  int get _index => _isLoading ? 1 : 0;

  void load(Function loader) async {
    try {
      setState(() => _isLoading = true);
      await loader();
      setState(() => _isLoading = false);
    } catch (e) {
      print(e.toString());
      if (e is Error) {
        print(e.stackTrace.toString());
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _index,
      children: <Widget>[
        widget.child,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text(
              'Transaction in progress...',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            LinearProgressIndicator(),
          ],
        ),
      ],
    );
  }
}
