import 'package:auto_route/auto_route_annotations.dart';

import 'home.dart';

@MaterialAutoRouter()
class $VoteRouter {
  @initial
  VotePage votePage;

  UciAccountDetails uciAccountDetails;
}
