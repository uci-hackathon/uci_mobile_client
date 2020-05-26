import 'models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyStorageApi {
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future saveKeys(AccountKeys accountKeys) async {
    await storage.write(key: 'ownerKey', value: accountKeys.owner.toString());
    if (accountKeys.active != null)
      await storage.write(key: 'activeKey', value: accountKeys.active.toString());
  }

  Future<AccountKeys> getKeys() async {
    final ownerKey = await storage.read(key: 'ownerKey');
    final activeKey = await storage.read(key: 'activeKey');

    AccountKeys ak = AccountKeys.fromPrivate(ownerKey, activeKey);

    return ak;
  }
}
