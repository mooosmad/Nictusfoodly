// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 0;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      dateCreated: fields[1] as String?,
      email: fields[2] as String?,
      id: fields[0] as int?,
      nom: fields[3] as String?,
      prenom: fields[4] as String?,
      urlPic: fields[5] as String?,
      adresse: fields[6] as String?,
      phone: fields[8] as String?,
      ville: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateCreated)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.nom)
      ..writeByte(4)
      ..write(obj.prenom)
      ..writeByte(5)
      ..write(obj.urlPic)
      ..writeByte(6)
      ..write(obj.adresse)
      ..writeByte(7)
      ..write(obj.ville)
      ..writeByte(8)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
