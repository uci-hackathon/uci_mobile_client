import 'dart:convert';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class UciAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: false,
      title: Container(
        padding: EdgeInsets.only(left: 5),
        height: kToolbarHeight - 5,
        child: Image.asset(
          'assets/app_bar.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}

class UciCard extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  UciCard({
    this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: Container(
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
  final double radius;

  UciAvatar({this.image, this.username, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          image != null ? Colors.white : Theme.of(context).accentColor,
      child: image != null
          ? null
          : Text(
              username.substring(0, 2).toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .apply(color: Colors.white),
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
      height: 40,
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

enum LoaderType {
  fullScreen,
  embed,
}

class LoadingPlaceholder extends StatefulWidget {
  final Widget child;
  final Key key;
  final LoaderType type;

  LoadingPlaceholder({
    this.child,
    this.key,
    this.type = LoaderType.fullScreen,
  }) : super(key: key);

  @override
  LoadingPlaceholderState createState() => LoadingPlaceholderState();
}

class LoadingPlaceholderState extends State<LoadingPlaceholder> {
  var _isLoading = false;

  int get _index => _isLoading ? 1 : 0;

  void load(
    Function loader, {
    String successMessage,
    String errorMessage,
  }) async {
    try {
      setState(() => _isLoading = true);
      await loader();
      if (successMessage != null) {
        FlushbarHelper.createSuccess(message: successMessage)..show(context);
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print(e.toString());
      if (e is Error) {
        print(e.stackTrace.toString());
      }

      // eosdart throws Strings
      if (e is String) {
        final data = jsonDecode(e.toString()) as Map<String, dynamic>;
        var message = data['error']['details'][0]['message'] as String;
        message = message.split(':').last;

        FlushbarHelper.createError(message: errorMessage ?? message)
          ..show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _index,
      children: <Widget>[
        widget.child,
        widget.type == LoaderType.fullScreen
            ? Column(
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
              )
            : LinearProgressIndicator(),
      ],
    );
  }
}
