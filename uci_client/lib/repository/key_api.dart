import 'models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

class KeyApi {
  FlutterSecureStorage storage = FlutterSecureStorage();

  AccountKeys createKeys() {
    AccountKeys ak = AccountKeys();

    ak.owner = EOSPrivateKey.fromRandom();
    ak.active = EOSPrivateKey.fromRandom();

    return ak;
  }

  Future<AccountKeys> importKeys(String seed) async {
    AccountKeys ak = AccountKeys();

    ak.active = EOSPrivateKey.fromSeed(seed);
    ak.owner = EOSPrivateKey.fromSeed(seed);

    return ak;
  }
}
