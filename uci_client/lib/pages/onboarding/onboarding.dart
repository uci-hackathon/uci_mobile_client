import 'package:flutter/material.dart';

import '../../widgets.dart';
import 'pick_role.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: IndexedStack(
        index: _pageIndex,
        children: <Widget>[
//          WalkthroughPage(onDone: () => setState(() => _pageIndex = 1)),
          PickRolePage(onDone: (role) => setState(() => _pageIndex = 0)),
        ],
      ),
    );
  }
}
