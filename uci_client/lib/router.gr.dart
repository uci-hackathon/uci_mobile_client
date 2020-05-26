// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uci_client/pages/root.dart';
import 'package:uci_client/pages/home/home.dart';
import 'package:uci_client/pages/onboarding/explain_role.dart';
import 'package:uci_client/pages/onboarding/sign_up.dart';

abstract class Routes {
  static const rootPage = '/';
  static const homePage = '/home-page';
  static const explainRolePage = '/explain-role-page';
  static const signUpPage = '/sign-up-page';
  static const all = {
    rootPage,
    homePage,
    explainRolePage,
    signUpPage,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.rootPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => RootPage(),
          settings: settings,
        );
      case Routes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomePage(),
          settings: settings,
        );
      case Routes.explainRolePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ExplainRolePage(),
          settings: settings,
        );
      case Routes.signUpPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
