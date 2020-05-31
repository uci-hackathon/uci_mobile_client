import 'package:flutter/material.dart';
import 'package:uci_client/repository/models/account.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets.dart';

class UciAccountDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UciAccount uciAccount = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: uciAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            uciAccount.username,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text(uciAccount.firstName),
              Text(uciAccount.lastName)
            ],
          ),
          SizedBox(height: 20),
          ..._buildLinks(context, uciAccount)
        ],
      ),
    );
  }

  List<Widget> _buildLinks(BuildContext context, UciAccount acc) {
    return acc.links.map((e) {
      return Transform.translate(
        offset: Offset(-15, 0),
        child: Container(
          alignment: Alignment.centerLeft,
          child: FlatButton(
            onPressed: () {
              final uri = Uri.parse(e);
              launch(Uri.https(uri.authority, uri.path).toString());
            },
            child: Text(
              e,
              style:
                  Theme.of(context).textTheme.button.apply(color: Colors.blue),
            ),
          ),
        ),
      );
    }).toList();
  }
}
