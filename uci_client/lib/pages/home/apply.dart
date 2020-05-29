import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uci_client/widgets.dart';

import 'apply_router.gr.dart';

class ApplyPage extends StatefulWidget {
  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          UciCard(
            onPressed: () => ExtendedNavigator.of(context)
                .pushNamed(Routes.applyForGrantPage),
            child: Text(
              'Apply for a grant',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          UciCard(
            onPressed: () => print('lol'),
            child: Text(
              'Nominate custodian',
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
