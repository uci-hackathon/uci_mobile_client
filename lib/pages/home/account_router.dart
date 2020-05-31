import 'package:auto_route/auto_route_annotations.dart';

import '../onboarding/sign_up.dart';
import 'account.dart';
import 'manage_grants.dart';
import 'uci_account_detail.dart';

@MaterialAutoRouter()
class $AccountRouter {
  @initial
  AccountPage accountPage;

  @MaterialRoute()
  ManageGrantsPage manageGrantsPage;

  @MaterialRoute()
  SignUpPage editProfilePage;

  @MaterialRoute()
  GrantVotersPage grantVotersPage;

  @MaterialRoute()
  UciAccountDetails uciAccountDetails;
}
