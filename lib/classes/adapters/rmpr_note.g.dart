// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rmpr_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RmprNoteAdapter extends TypeAdapter<RmprNote> {
  @override
  final int typeId = 1;

  @override
  RmprNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RmprNote(
      name: fields[0] as String,
      note: fields[1] as String,
      data: (fields[2] as Map).cast<String, dynamic>(),
      tags: (fields[3] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RmprNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RmprNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
