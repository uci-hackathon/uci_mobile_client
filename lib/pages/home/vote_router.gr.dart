// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uci_client/pages/home/nominates.dart';
import 'package:uci_client/pages/home/uci_account_detail.dart';

abstract class Routes {
  static const nominatesPage = '/';
  static const uciAccountDetails = '/uci-account-details';
  static const all = {
    nominatesPage,
    uciAccountDetails,
  };
}

class VoteRouter extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<VoteRouter>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.nominatesPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => NominatesPage(),
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
