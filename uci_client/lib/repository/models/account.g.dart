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
      username: fields[2] as String,
    )
      ..firstName = fields[0] as String
      ..lastName = fields[1] as String
      ..birthDate = fields[3] as DateTime
      ..email = fields[4] as String
      ..links = (fields[5] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, UciAccount obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.links);
  }
}
