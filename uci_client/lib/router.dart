import 'package:auto_route/auto_route_annotations.dart';

import 'pages/pages.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  RootPage rootPage;

  @MaterialRoute()
  HomePage homePage;

  @MaterialRoute()
  ExplainRolePage explainRolePage;

  @MaterialRoute()
  SignUpPage signUpPage;
}
