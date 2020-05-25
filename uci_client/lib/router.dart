import 'package:auto_route/auto_route_annotations.dart';

import 'pages/pages.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomePage homePage;

  @MaterialRoute(fullscreenDialog: true)
  OnboardingExplanation onboardingExplanationPage;
}
