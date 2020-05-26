import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router.gr.dart';
import '../../widgets.dart';
import 'pick_role.dart';
import 'walkthrough.dart';

export 'explain_role.dart';
export 'pick_role.dart';
export 'sign_up.dart';
export 'walkthrough.dart';

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
          WalkthroughPage(onDone: () => setState(() => _pageIndex = 1)),
          PickRolePage(
            onDone: (role) => ExtendedNavigator.rootNavigator.pushNamed(
              Routes.explainRolePage,
              arguments: role,
            ),
          ),
        ],
      ),
    );
  }
}
