import 'package:eosdart_ecc/eosdart_ecc.dart';

enum AccountType { creator, backer, organization }

//class Account {
//  String fullName;
//  double latitude;
//  double longitude;
//}

class AccountKeys {
  AccountKeys(){
  }

  AccountKeys.fromPrivate(String ownerKey, [String activeKey]){
    owner = EOSPrivateKey.fromString(ownerKey);
    if (activeKey != null)
      active = EOSPrivateKey.fromString(activeKey);
  }

  EOSPrivateKey active;
  EOSPrivateKey owner;
}