import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'account_router.gr.dart' as account;
import 'apply_router.gr.dart' as apply;
import 'balance.dart';
import 'shop.dart';
import 'vote_router.gr.dart';

export 'apply.dart';
export 'nominates.dart';
export 'uci_account_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum HomeTabs {
  vote,
  wallet,
  apply,
  shop,
  account,
}

class _HomePageState extends State<HomePage> {
  var _currentTab = 0;

  List<String> _bottomIcons = [
    'assets/vote.png',
    'assets/wallet.png',
    'assets/add.png',
    'assets/shop.png',
    'assets/account.png',
  ];

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
        items: _bottomIcons
            .map(
              (i) => BottomNavigationBarItem(
                icon: Image.asset(
                  i,
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  '',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Theme.of(context).accentColor,
                        height: 0.2,
                      ),
                ),
              ),
            )
            .toList(),
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
        ExtendedNavigator<apply.ApplyRouter>(
          router: apply.ApplyRouter(),
        ),
        ShopPage(),
        ExtendedNavigator<account.AccountRouter>(
          router: account.AccountRouter(),
        ),
      ],
    );
  }
}
