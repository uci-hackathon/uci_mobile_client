import 'package:auto_route/auto_route_annotations.dart';

import 'home.dart';
import 'nominates.dart';

@MaterialAutoRouter()
class $VoteRouter {
  @initial
  NominatesPage nominatesPage;

  UciAccountDetails uciAccountDetails;
}
