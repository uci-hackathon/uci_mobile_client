import 'package:flutter/material.dart';

import '../../repository/models/models.dart';
import '../../widgets.dart';

class PickRolePage extends StatelessWidget {
  final Function onDone;

  PickRolePage({this.onDone});

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(),
          Text(
            'Join the\nmovement',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.start,
          ),
          Image.asset(
            'assets/onboard4.png',
            height: s.height * 0.4,
            width: s.width,
          ),
          _buildButtons(context),
          SizedBox(),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final captions = {
      AccountType.create: 'Apply for a grant',
      AccountType.nominate: 'Nominate custodians',
      AccountType.vote: 'Vote for custodians',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: AccountType.values
          .map((a) => UciButton(
                onPressed: () => onDone(a),
                child: Text(
                  captions[a],
                  style: Theme.of(context).textTheme.button,
                ),
              ))
          .toList(),
    );
  }
}
