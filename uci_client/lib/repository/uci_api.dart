import 'dart:convert';

import 'package:eosdart/eosdart.dart' as eos;
import 'package:http/http.dart' as http;

import 'models/models.dart';
import 'prefs.dart';

class UciApi {
  static const _eosUrl = 'https://api-test.telosfoundation.io';
  static const _apiUrl = 'http://91ca4a99.ngrok.io';

  final _eos = eos.EOSClient(_eosUrl, 'v1');
  final Prefs prefs;

  UciApi({this.prefs});

  //TODO handle more fallbacks & edge cases
  //1. create eos acc
  //2. write keys to prefs
  //3. create telos decide regvoter
  //4. write user metadata to uci contract
  Future<AccountKeys> createAccount(
    UciAccount uciAccount,
    AccountKeys keys,
  ) async {
    await _createEosAccount(uciAccount.username, keys);
    await prefs.setKeys(keys);

    await _prepareKeys();
    final transaction = eos.Transaction()
      ..actions = [
        _buildCreateVoterAction(uciAccount.username),
        _buildUpsertMedatataAction(uciAccount),
      ];

    await _eos.pushTransaction(transaction);

    return keys;
  }

  Future<void> _createEosAccount(
    String accountName,
    AccountKeys keys,
  ) {
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

  eos.Action _buildCreateVoterAction(String accountName) {
    return eos.Action()
      ..account = 'telos.decide'
      ..name = 'regvoter'
      ..authorization = [
        eos.Authorization()
          ..actor = accountName
          ..permission = 'active'
      ]
      ..data = {
        'voter': accountName,
        'treasury_symbol': '0,UCI',
        'referrer': accountName,
      };
  }

  eos.Action _buildUpsertMedatataAction(UciAccount uciAccount) {
    return eos.Action()
      ..account = 'uci'
      ..name = 'upsertmeta'
      ..authorization = [
        eos.Authorization()
          ..actor = uciAccount.username
          ..permission = 'owner'
      ]
      ..data = {
        'account_name': uciAccount.username,
        'json': jsonEncode(uciAccount.toJson()),
      };
  }

  Future<UciAccount> fetchMetadata(String accountName) async {
    final row = await _eos.getTableRow(
      'uci',
      accountName,
      'metadata',
      tableKey: accountName,
    );

    final acc = UciAccount.fromJson(row);
    acc.username = accountName;
    return acc;
  }

  Future<List<String>> fetchCustodians() async {
    await Future.delayed(Duration(milliseconds: 3000));
    return [
      'pep',
      'kek',
      'ses',
    ];
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

    print(keys.toString());
    return keys;
  }
}
