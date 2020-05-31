import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../widgets.dart';
import 'account_router.gr.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          UciCard(
            onPressed: () =>
                ExtendedNavigator.of(context).pushNamed(Routes.editProfilePage),
            child: Text(
              'Manage profile',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          UciCard(
            onPressed: () => ExtendedNavigator.of(context)
                .pushNamed(Routes.manageGrantsPage),
            child: Text(
              'Manage grants',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
