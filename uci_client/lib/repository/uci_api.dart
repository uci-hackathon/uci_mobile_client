import 'dart:convert';

import 'package:eosdart/eosdart.dart' as eos;
import 'package:http/http.dart' as http;

import 'models/models.dart';
import 'prefs.dart';

class UciApi {
  static const _eosUrl = 'https://api-test.telosfoundation.io';
  static const _apiUrl = 'http://91ca4a99.ngrok.io';

  static const telosDecideContract = 'telos.decide';
  static const uciContract = 'uci';

  final _eos = eos.EOSClient(_eosUrl, 'v1');
  final Prefs prefs;

  UciApi({this.prefs});

  //TODO handle more fallbacks & edge cases
  //1. create eos acc
  //2. write keys to prefs
  //3. create telos decide regvoter
  //4. write user metadata to uci contract
  Future<eos.Account> createAccount(String accountName,
      AccountKeys keys,) async {
    await _createEosAccount(accountName, keys);
    await prefs.setKeys(keys);
  }

  Future<void> _createEosAccount(String accountName,
      AccountKeys keys,) {
    return http.post(
      '$_apiUrl/api/account',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'account_name': accountName,
        'active_key': keys.active.toEOSPublicKey().toString(),
        'owner_key': keys.owner.toEOSPublicKey().toString()
      }),
    );
  }

  List<eos.Action> _createVoterAction(String accountName) {
    List<eos.Authorization> auth = [
      eos.Authorization()
        ..actor = accountName
        ..permission = 'owner'
    ];

    Map data = {
      'voter': accountName,
      'treasury_symbol': '0,UCI'
    };

    return [
      eos.Action()
        ..account = 'telos.decide'
        ..name = 'regvoter'
        ..authorization = auth
        ..data = data
    ];
  }

  Future<void> createVoter() async {
    await _prepareKeys();

    final account = await fetchAccount();

    eos.Transaction transaction = eos.Transaction()
      ..actions = _createVoterAction(account.accountName);

    return _eos.pushTransaction(transaction, broadcast: true);
  }

  List<eos.Action> _createMetadataAction(String accountName, Map<String, String> metadata) {
    List<eos.Authorization> auth = [
      eos.Authorization()
        ..actor = accountName
        ..permission = 'owner'
    ];

    Map data = {
      'account_name': accountName,
      'json': jsonEncode(metadata)
    };

    return [
      eos.Action()
        ..account = uciContract
        ..name = 'upsertmeta'
        ..authorization = auth
        ..data = data
    ];
  }

  Future<void> upsertMetadata(Map<String, String> metadata) async {
    await _prepareKeys();

    final account = await fetchAccount();

    eos.Transaction transaction = eos.Transaction()
      ..actions = _createMetadataAction(account.accountName, metadata);

    return _eos.pushTransaction(transaction, broadcast: true);
  }

  Future<Map<String, dynamic>> fetchMetadata() async {
    final account = await fetchAccount();
    return _eos.getTableRow(telosDecideContract, account.accountName, 'metadata', tableKey: account.accountName);
  }

  Future<eos.Account> fetchAccount() async {
    final keys = await prefs.keys();
    final names = await _eos.getKeyAccounts(keys.owner.toString());
    //TODO only one account is supported rn
    return _eos.getAccount(names.accountNames.first);
  }

  Future<List<eos.Holding>> fetchBalance(eos.Account account) {
    return _eos.getCurrencyBalance('eosio.token', account.accountName);
  }

  Future<eos.Account> fetchAccountByName(String name) {
    return _eos.getAccount(name);
  }

  Future<AccountKeys> _prepareKeys() async {
    final keys = await prefs.keys();

    _eos.keys[keys.owner.toEOSPublicKey().toString()] = keys.owner;
    if (keys.active != null) {
      _eos.keys[keys.active.toEOSPublicKey().toString()] = keys.active;
    }

    return keys;
  }
}
