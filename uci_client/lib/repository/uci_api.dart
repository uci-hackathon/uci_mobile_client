import 'dart:convert';
import 'dart:html';

import 'package:eosdart/eosdart.dart' as eos;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'models/models.dart';
import 'prefs.dart';

class UciApi {
  static const _eosUrl = 'https://api-test.telosfoundation.io';
  static const _apiUrl = 'https://uci-hackathon.herokuapp.com';

  final _uciAccountStorage = Hive.openBox<UciAccount>(
    'uci_accounts',
  );

  final _eos = eos.EOSClient(_eosUrl, 'v1');
  final Prefs prefs;

  UciApi({this.prefs});

  Future<bool> isRegistered() async {
    final acc = await currentUciAccount();
    return acc != null;
  }

  //TODO handle more fallbacks & edge cases
  //1. create eos acc
  //2. write keys to prefs
  //3. create telos decide regvoter
  //4. write user metadata to uci contract
  Future<AccountKeys> createAccount(UciAccount uciAccount) async {
    final keys = AccountKeys.create();

    await _createEosAccount(uciAccount.username, keys);
    await prefs.setAccountName(uciAccount.username);
    await prefs.setKeys(keys);

    await _prepareKeys();
    final transaction = eos.Transaction()
      ..actions = [
        _buildCreateVoterAction(uciAccount.username),
        _buildUpsertMedadataAction(uciAccount),
      ];

    await _eos.pushTransaction(transaction);
    await (await _uciAccountStorage).put(uciAccount.username, uciAccount);

    return keys;
  }

  Future<dynamic> updateAccount(UciAccount uciAccount) async {
    final accountName = await prefs.accountName();
    await _prepareKeys();
    uciAccount.username = accountName;
    final transaction = eos.Transaction()
      ..actions = [
        _buildUpsertMedadataAction(uciAccount),
      ];

    final r = await _eos.pushTransaction(transaction);
    await (await _uciAccountStorage).put(uciAccount.username, uciAccount);

    return r;
  }

  Future<void> _createEosAccount(
    String accountName,
    AccountKeys keys,
  ) async {
    final result = await http.post(
      '$_apiUrl/api/account',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'account_name': accountName,
        'active_key': keys.active.toEOSPublicKey().toString(),
        'owner_key': keys.owner.toEOSPublicKey().toString()
      }),
    );

    if (result.statusCode != HttpStatus.ok) {
      throw result;
    }
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

  eos.Action _buildCreateVote(
    String accountName,
    String ballotName,
    List<String> options,
  ) {
    return eos.Action()
      ..account = 'telos.decide'
      ..name = 'castvote'
      ..authorization = [
        eos.Authorization()
          ..actor = accountName
          ..permission = 'owner'
      ]
      ..data = {
        'voter': accountName,
        'ballot_name': ballotName,
        'options': options,
      };
  }

  eos.Action _buildUpsertMedadataAction(UciAccount uciAccount) {
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

  eos.Action _buildNominationAction(String accountName) {
    return eos.Action()
      ..account = 'uci'
      ..name = 'nominate'
      ..authorization = [
        eos.Authorization()
          ..actor = accountName
          ..permission = 'owner'
      ]
      ..data = {'from': accountName, 'to': accountName};
  }

  eos.Action _buildApplyForGrantAction(
    String accountName,
    Grant grant,
  ) {
    print(grant.body());
    print(grant.amount);
    return eos.Action()
      ..account = 'uci'
      ..name = 'submitprop'
      ..authorization = [
        eos.Authorization()
          ..actor = accountName
          ..permission = 'owner'
      ]
      ..data = {
        'proposer': accountName,
        'body': jsonEncode(grant.body()),
        'amount': grant.amount + ' UCI',
      };
  }

//  eos.Action _buildCancelProposalAction(
//      UciAccount uciAccount, Proposal proposal) {
//    return eos.Action()
//      ..account = 'uci'
//      ..name = 'endprop'
//      ..authorization = [
//        eos.Authorization()
//          ..actor = uciAccount.username
//          ..permission = 'owner'
//      ]
//      ..data = {'proposal_id': proposal.proposalId};
//  }

  Future<UciAccount> currentUciAccount() async {
    final accountName = await prefs.accountName();
    if (accountName == null) {
      return null;
    }

    return (await _uciAccountStorage).get(accountName);
  }

  Future<dynamic> submitGrant(Grant grant) async {
    await _prepareKeys();
    final accountName = await prefs.accountName();
    await _eos.pushTransaction(eos.Transaction()
      ..actions = [_buildApplyForGrantAction(accountName, grant)]);
  }

  Future<dynamic> nominateSelfAsCustodian() async {
    await _prepareKeys();
    final accountName = await prefs.accountName();
    return _eos.pushTransaction(eos.Transaction()
      ..actions = [
        _buildNominationAction(accountName),
      ]);
  }

  Future<dynamic> submitVote(List<String> options, [String ballotName]) async {
    await _prepareKeys();
    final accountName = await prefs.accountName();
    ballotName = ballotName ?? await _fetchCurrentBallot();
    return _eos.pushTransaction(eos.Transaction()
      ..actions = [
        _buildCreateVote(accountName, ballotName, options),
      ]);
  }

  Future<String> _fetchCurrentBallot() async {
    final data = await _eos.getTableRow('uci', 'uci', 'config');
    return data['current_election_ballot'];
  }

  Future<UciAccount> fetchMetadata(String accountName) async {
    final data = await _eos.getTableRow(
      'uci',
      'uci',
      'metadata',
      tableKey: accountName,
    );

    final json = jsonDecode(data['json']);
    final acc = UciAccount.fromJson(json);
    acc.username = accountName;
    return acc;
  }

  Future<List<String>> fetchNominates() async {
    final data = await _eos.getTableRow('uci', 'uci', 'nomination');
    return (data['nominations_list'] as List).cast<String>();
  }

  Future<UciBalance> fetchUciBalance() async {
    final accountName = await prefs.accountName();
    print(accountName);
    final data = await _eos.getTableRow('telos.decide', accountName, 'voters');

    print(data);
    return UciBalance(
      liquid: data['liquid'],
      staked: data['staked'],
    );
  }

  Future<List<Map<String, dynamic>>> fetchProposals() async {
    return _eos.getTableRows('uci', 'uci', 'proposals', limit: 80);
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
