import 'package:eosdart_ecc/eosdart_ecc.dart';

enum AccountType { create, vote, nominate }

class Account {
  String fullName;
  String location;
  String avatar;
  Map<String, dynamic> social;
}

class AccountKeys {
  AccountKeys.create([String seed]) {
    if (seed != null) {
      owner = EOSPrivateKey.fromSeed(seed);
      active = EOSPrivateKey.fromSeed(seed);
    } else {
      owner = EOSPrivateKey.fromRandom();
      active = EOSPrivateKey.fromRandom();
    }
  }

  AccountKeys.fromPrivate(String ownerKey, [String activeKey]) {
    owner = EOSPrivateKey.fromString(ownerKey);
    if (activeKey != null) {
      active = EOSPrivateKey.fromString(activeKey);
    }
  }

  EOSPrivateKey active;
  EOSPrivateKey owner;
}
