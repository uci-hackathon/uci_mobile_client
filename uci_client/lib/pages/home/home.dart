import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../onboarding/sign_up.dart';
import 'apply_router.gr.dart';
import 'balance.dart';
import 'vote_router.gr.dart';

export 'apply.dart';
export 'uci_account_detail.dart';
export 'vote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum HomeTabs {
  vote,
  wallet,
  apply,
  account,
}

class _HomePageState extends State<HomePage> {
  var _currentTab = 0;

  @override
  void initState() {
    ExtendedNavigator<VoteRouter>(router: VoteRouter());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text('vote'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('wallet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('apply'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('account'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentTab,
      children: <Widget>[
        ExtendedNavigator<VoteRouter>(
          router: VoteRouter(),
        ),
        BalancePage(),
        ExtendedNavigator<ApplyRouter>(
          router: ApplyRouter(),
        ),
        SignUpPage(),
      ],
    );
  }
}
