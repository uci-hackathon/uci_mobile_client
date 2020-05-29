// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uci_client/pages/home/account.dart';
import 'package:uci_client/pages/home/manage_grants.dart';
import 'package:uci_client/pages/onboarding/sign_up.dart';
import 'package:uci_client/pages/home/uci_account_detail.dart';

abstract class Routes {
  static const accountPage = '/';
  static const manageGrantsPage = '/manage-grants-page';
  static const editProfilePage = '/edit-profile-page';
  static const grantVotersPage = '/grant-voters-page';
  static const uciAccountDetails = '/uci-account-details';
  static const all = {
    accountPage,
    manageGrantsPage,
    editProfilePage,
    grantVotersPage,
    uciAccountDetails,
  };
}

class AccountRouter extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<AccountRouter>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.accountPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AccountPage(),
          settings: settings,
        );
      case Routes.manageGrantsPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ManageGrantsPage(),
          settings: settings,
        );
      case Routes.editProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpPage(),
          settings: settings,
        );
      case Routes.grantVotersPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => GrantVotersPage(),
          settings: settings,
        );
      case Routes.uciAccountDetails:
        return MaterialPageRoute<dynamic>(
          builder: (context) => UciAccountDetails(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
