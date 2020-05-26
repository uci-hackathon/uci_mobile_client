import 'dart:convert';

import 'models/models.dart' as model;
import 'package:eosdart_ecc/eosdart_ecc.dart' as eos;
import 'package:eosdart/eosdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'key_storage_api.dart';
import 'package:http/http.dart' as http;

class UciApi {
  EOSClient client = EOSClient('http://localhost:8888', 'v1');

  Future<Account> createAccount(
      String accountName, model.AccountKeys accountKeys) async {
    try {
      final responce = await http.post('http://91ca4a99.ngrok.io/api/account',
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'account_name': accountName,
            'active_key': accountKeys.active.toEOSPublicKey().toString(),
            'owner_key': accountKeys.owner.toEOSPublicKey().toString()
          }));
      if (responce.statusCode != 200) return null;
    } on Exception {
      return null;
    }

    return await fetchAccountByName(accountName);
  }

  Future<Account> fetchAccount(model.AccountKeys accountKeys) async {
    final AccountNames names =
        await client.getKeyAccounts(accountKeys.owner.toString());
    final Account account = await client.getAccount(names.accountNames[0]);
    return account;
  }

  Future<List<Holding>> fetchBalances(Account account) async {
    final balances =
        await client.getCurrencyBalance('eosio.token', account.accountName);
    return balances;
  }

  Future<Account> fetchAccountByName(String name) async {
    final Account account = await client.getAccount(name);
    return account;
  }
}
