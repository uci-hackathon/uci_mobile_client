import 'package:flutter/material.dart';
import 'package:uci_client/repository/models/account.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets.dart';

class UciAccountDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UciAccount uciAccount = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: UciAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          SizedBox(height: 20),
          _profileHeader(context, uciAccount),
          SizedBox(height: 20),
          Text(
            uciAccount.bio ?? '',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          ..._buildLinks(context, uciAccount)
        ],
      ),
    );
  }

  Widget _profileHeader(BuildContext context, UciAccount uciAccount) {
    return Row(
      children: <Widget>[
        UciAvatar(
          radius: 40,
          image: uciAccount.image,
          username: uciAccount.username,
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              uciAccount.name ?? '',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '@${uciAccount.username}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ],
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
