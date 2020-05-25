import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../repository/models/models.dart';
import '../../router.gr.dart';
import 'walkthrough.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        //leading: Image.asset('assets/uci.png'),
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
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: <Widget>[
          WalkthroughPage(onDone: () => setState(() => _pageIndex = 1)),
          Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: false,
              //leading: Image.asset('assets/uci.png'),
              title: Row(
                children: <Widget>[
                  Image.asset('assets/uci.png'),
                  Text('Universal Creator\nincome'),
                ],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Who are you?',
                  style: Theme.of(context).textTheme.headline4,
                ),
                _buildButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
        children: AccountType.values
            .map((e) => RaisedButton(
                  onPressed: () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.homePage,
                    arguments: e,
                  ),
                  child: Text(
                    e.toString().split('.').last.toUpperCase(),
                  ),
                ))
            .toList());
  }
}
