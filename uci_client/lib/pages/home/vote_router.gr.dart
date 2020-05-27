// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uci_client/pages/home/vote.dart';
import 'package:uci_client/pages/home/custodian_detail.dart';

abstract class Routes {
  static const votePage = '/';
  static const custodianDetailsPage = '/custodian-details-page';
  static const all = {
    votePage,
    custodianDetailsPage,
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
      case Routes.votePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => VotePage(),
          settings: settings,
        );
      case Routes.custodianDetailsPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => CustodianDetailsPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}