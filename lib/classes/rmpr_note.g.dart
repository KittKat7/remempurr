// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rmpr_note.dart';

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
      toDoItems: (fields[2] as List).cast<ToDo>(),
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
      ..write(obj.toDoItems)
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

class ToDoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 2;

  @override
  ToDo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDo(
      desc: fields[0] as String,
      noteName: fields[1] as String,
      tags: (fields[2] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ToDo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.desc)
      ..writeByte(1)
      ..write(obj.noteName)
      ..writeByte(2)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
