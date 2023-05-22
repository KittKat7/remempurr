// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoListAdapter extends TypeAdapter<ToDoList> {
  @override
  final int typeId = 0;

  @override
  ToDoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoList(
      name: fields[0] as String,
      desc: fields[1] as String?,
      todoItems: (fields[2] as List).cast<ToDo>(),
      tags: (fields[3] as Map?)?.cast<String, String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ToDoList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.desc)
      ..writeByte(2)
      ..write(obj.todoItems)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 1;

  @override
  ToDo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDo(
      desc: fields[0] as String,
      listName: fields[1] as String,
      tags: (fields[2] as Map?)?.cast<String, String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ToDo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.desc)
      ..writeByte(1)
      ..write(obj.listName)
      ..writeByte(2)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
