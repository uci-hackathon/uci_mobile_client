import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../repository/models/models.dart';
import '../router.gr.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: <Widget>[
          _landingScreen(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Who are you?',
                style: Theme.of(context).textTheme.headline4,
              ),
              _buildButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _landingScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'UCI\nUniversal Creator Income',
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: double.infinity,
            child: RaisedButton(
              child: Text('Get started'),
              onPressed: () => setState(() => _pageIndex = 1),
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
