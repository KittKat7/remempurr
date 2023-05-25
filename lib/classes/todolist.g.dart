// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoListAdapter extends TypeAdapter<ToDoList> {
  @override
  final int typeId = 0;

  @override
  ToDoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

		// edited:
		// tags used to be <String, String?>, this handles the String? and converts it to String
		final tags = (fields[3] as Map).cast<String, dynamic>();
    final convertedTags = <String, String>{};

    tags.forEach((key, value) {
      if (value is String) {
        convertedTags[key] = value;
      } else if (value is String?) {
        convertedTags[key] = value ?? ''; // Assign empty string if value is null
      }
    });
		// end edited

    return ToDoList(
      name: fields[0] as String,
      desc: fields[1] == null? "" : fields[1] as String, // edited: from `fields[1] as String`, to handle nulls
      todoItems: (fields[2] as List).cast<ToDo>(),
      tags: convertedTags, // edited: changed from `tags: (fields[3] as Map).cast<String, String>()`
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
      other is ToDoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToDoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 1;

  @override
  ToDo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

		// edited:
		// tags used to be <String, String?>, this handles the String? and converts it to String
		final tags = (fields[2] as Map).cast<String, dynamic>();
    final convertedTags = <String, String>{};

    tags.forEach((key, value) {
      if (value is String) {
        convertedTags[key] = value;
      } else if (value is String?) {
        convertedTags[key] = value ?? ''; // Assign empty string if value is null
      }
    });
		// end edited

    return ToDo(
      desc: fields[0] as String,
      listName: fields[1] as String,
      tags: convertedTags, // changed from `tags: (fields[2] as Map).cast<String, String>()`
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
      other is ToDoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
