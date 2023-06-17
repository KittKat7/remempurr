// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rmpr_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RmprFileAdapter extends TypeAdapter<RmprFile> {
  @override
  final int typeId = 0;

  @override
  RmprFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RmprFile(
      name: fields[0] as String,
      path: fields[1] as String,
      notes: (fields[2] as Map).cast<String, RmprNote>(),
      tags: (fields[3] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RmprFile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RmprFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
