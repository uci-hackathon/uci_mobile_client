import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class Prefs {
  static const _kOwnerKey = 'owner_key';
  static const _kActiveKey = 'active_key';
  static const _kAccountName = 'account_name';

  final _storage = FlutterSecureStorage();

  Future<AccountKeys> keys() async {
    final ownerKey = await _storage.read(key: _kOwnerKey);
    final activeKey = await _storage.read(key: _kActiveKey);

    return AccountKeys.fromPrivate(ownerKey, activeKey);
  }

  Future<AccountKeys> setKeys(AccountKeys keys) async {
    await _storage.write(key: _kOwnerKey, value: keys.owner.toString());

    if (keys.active != null) {
      await _storage.write(key: _kActiveKey, value: keys.active.toString());
    }

    return keys;
  }

  Future<String> accountName() async {
    return _storage.read(key: _kAccountName);
  }

  Future<String> setAccountName(String accountName) async {
    await _storage.write(key: _kAccountName, value: accountName);
    return accountName;
  }
}
