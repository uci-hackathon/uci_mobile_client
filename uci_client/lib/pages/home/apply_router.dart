import 'package:auto_route/auto_route_annotations.dart';

import 'apply_grant.dart';
import 'home.dart';

@MaterialAutoRouter()
class $ApplyRouter {
  @initial
  ApplyPage applyPage;

  @MaterialRoute()
  ApplyForGrantPage applyForGrantPage;
}
