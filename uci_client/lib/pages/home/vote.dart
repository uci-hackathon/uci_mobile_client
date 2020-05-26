import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../widgets.dart';
import 'vote_router.gr.dart';

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () => ExtendedNavigator.of(context).pushNamed(
            Routes.custodianDetailsPage,
          ),
          child: Text('LOL'),
        ),
      ),
    );
  }
}
