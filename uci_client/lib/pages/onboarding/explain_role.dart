import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../repository/models/models.dart';
import '../../router.gr.dart';
import '../../widgets.dart';

class _ExplainRoleViewModel {
  final String title;
  final String description;
  final String buttonTitle;

  _ExplainRoleViewModel({
    this.title,
    this.description,
    this.buttonTitle,
  });

  static _ExplainRoleViewModel resolve(AccountType role) => {
        AccountType.create: _ExplainRoleViewModel(
          title: 'Apply for a\nGrant',
          buttonTitle: 'Apply now',
          description:
              'Support your creative processes with community-allocated grants, accessible globally with a digital Universal Creator’s account.',
        ),
        AccountType.vote: _ExplainRoleViewModel(
          title: 'Vote for\nInfluence',
          buttonTitle: 'Vote for custodians',
          description:
              'Participate with your vote to choose relevant network custodians and see transparent distribution to creators',
        ),
        AccountType.nominate: _ExplainRoleViewModel(
          title: 'Nominate\nInfluencers',
          buttonTitle: 'Nominate',
          description:
              'Share your nominatations of culturally influential organisations, artists or groups to the community.',
        ),
      }[role];
}

class ExplainRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AccountType role = ModalRoute.of(context).settings.arguments;
    final vm = _ExplainRoleViewModel.resolve(role);
    return Scaffold(
      appBar: uciAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(
              vm.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              vm.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: RaisedButton(
                elevation: 0.0,
                hoverElevation: 0.0,
                highlightElevation: 0.0,
                focusElevation: 0.0,
                disabledElevation: 0.0,
                onPressed: () => ExtendedNavigator.rootNavigator.pushNamed(
                  Routes.signUpPage,
                  arguments: role,
                ),
                child: Text(
                  vm.buttonTitle,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
