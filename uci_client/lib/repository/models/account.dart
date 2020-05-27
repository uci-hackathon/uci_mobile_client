import 'package:eosdart_ecc/eosdart_ecc.dart';

enum AccountType { create, vote, nominate }

class UciAccount {
  UciAccount({this.username});

  String firstName;
  String lastName;
  String username;
  DateTime birthDate;
  String email;
  List<String> links;

  UciAccount.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];

    if (json['birth_date'] != null) {
      birthDate = DateTime.tryParse(json['birth_date']);
    }

    email = json['email'];
    links = json['links'];
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'birth_date': birthDate?.toIso8601String(),
      'email': email,
      'links': links,
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
