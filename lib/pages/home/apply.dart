import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';
import 'package:uci_client/widgets.dart';

import 'apply_router.gr.dart';

class ApplyPage extends StatefulWidget {
  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final _loaderKey = GlobalKey<LoadingPlaceholderState>();

  @override
  Widget build(BuildContext context) {
    return LoadingPlaceholder(
      key: _loaderKey,
      child: Scaffold(
        appBar: UciAppBar(),
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
              onPressed: () => _loaderKey.currentState.load(
                () => Provider.of<UciApi>(context, listen: false)
                    .nominateCustodian(),
                successMessage: 'Application submitted',
                errorMessage: 'Not enough vote tokens',
              ),
              child: Text(
                'Get nominated',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .apply(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
