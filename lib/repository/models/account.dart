import 'dart:convert';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'account.g.dart';

enum AccountType { create, vote, nominate }

class UciBalance {
  UciBalance.fromJson(Map<String, dynamic> json) {
    liquid = _parseSymbol(json['liquid']);
  }

  double _parseSymbol(String symbol) {
    return double.tryParse(symbol.split(' ').first);
  }

  double liquid;
}

@HiveType(typeId: 0)
class UciAccount extends HiveObject {
  UciAccount({this.username});

  @HiveField(0)
  String name;

  @HiveField(1)
  String username;

  @HiveField(2)
  DateTime birthDate;

  @HiveField(3)
  String email;

  @HiveField(4)
  List<String> links;

  @HiveField(5)
  String avatar;

  @HiveField(6)
  String bio;

  MemoryImage _cachedImage;

  ImageProvider get image {
    if (_cachedImage != null) {
      return _cachedImage;
    }

    _cachedImage = avatar != null ? MemoryImage(base64Decode(avatar)) : null;
    return _cachedImage;
  }

  UciAccount.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    bio = json['bio'];

    final bd = json['birth_date'];
    if (bd != null) {
      birthDate = bd is DateTime ? bd : DateTime.tryParse(json['birth_date']);
    }

    email = json['email'];
    links = (json['links'] ?? []).cast<String>();

    if (json['avatar'] != null) {
      avatar = json['avatar'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'birth_date': birthDate?.toIso8601String(),
      'email': email,
      'links': links,
      'avatar': avatar,
      'bio': bio,
    };
  }

  @override
  String toString() {
    return 'UciAccount: {name: $name, username: $username, birthDate: $birthDate, email: $email, avatar: $avatar}';
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
