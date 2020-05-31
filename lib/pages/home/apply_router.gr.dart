// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uci_client/pages/home/apply.dart';
import 'package:uci_client/pages/home/apply_grant.dart';

abstract class Routes {
  static const applyPage = '/';
  static const applyForGrantPage = '/apply-for-grant-page';
  static const all = {
    applyPage,
    applyForGrantPage,
  };
}

class ApplyRouter extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<ApplyRouter>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.applyPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ApplyPage(),
          settings: settings,
        );
      case Routes.applyForGrantPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ApplyForGrantPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
