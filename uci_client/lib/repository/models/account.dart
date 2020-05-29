import 'dart:convert';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:hive/hive.dart';

part 'account.g.dart';

enum AccountType { create, vote, nominate }

class UciBalance {
  UciBalance({this.liquid, this.staked});

  String liquid;
  String staked;
}

@HiveType(typeId: 0)
class UciAccount extends HiveObject {
  UciAccount({this.username});

  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String username;

  @HiveField(3)
  DateTime birthDate;

  @HiveField(4)
  String email;

  @HiveField(5)
  List<String> links;

  @HiveField(6)
  List<int> avatar;

  UciAccount.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];

    final bd = json['birth_date'];
    if (bd != null) {
      birthDate = bd is DateTime ? bd : DateTime.tryParse(json['birth_date']);
    }

    email = json['email'];
    links = (json['links'] ?? []).cast<String>();

    if (json['avatar'] != null) {
      avatar = base64Decode(json['avatar']).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'birth_date': birthDate?.toIso8601String(),
      'email': email,
      'links': links,
      'avatar': avatar != null ? base64Encode(avatar) : null,
    };
  }
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

  @override
  String toString() {
    var s = 'public owner: ${owner.toEOSPublicKey().toString()}';
    s += '\nprivate owner: ${owner.toString()}';

    if (active != null) {
      s += '\npublic active: ${active.toEOSPublicKey().toString()}';
      s += '\nprivate active: ${active.toString()}';
    }

    return s;
  }

  EOSPrivateKey active;
  EOSPrivateKey owner;
}
