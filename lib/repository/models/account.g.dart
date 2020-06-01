// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UciAccountAdapter extends TypeAdapter<UciAccount> {
  @override
  final typeId = 0;

  @override
  UciAccount read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UciAccount(
      username: fields[1] as String,
    )
      ..name = fields[0] as String
      ..birthDate = fields[2] as DateTime
      ..email = fields[3] as String
      ..links = (fields[4] as List)?.cast<String>()
      ..avatar = fields[5] as String
      ..bio = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, UciAccount obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.links)
      ..writeByte(5)
      ..write(obj.avatar)
      ..writeByte(6)
      ..write(obj.bio);
  }
}
