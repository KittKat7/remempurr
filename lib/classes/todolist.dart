import 'package:hive/hive.dart';

part 'todolist.g.dart';

@HiveType(typeId: 0)
class TodoList extends HiveObject {
	// name of todo list
	// list<string> of prioreties
	// list<string> of items
	// list<string> completed
	
	@HiveField(0)
	String name;

	@HiveField(1)
	List<Todo> priority;

	@HiveField(2)
	List<Todo> items;

	@HiveField(3)
	List<Todo> complete;

	TodoList({required this.name, required this.priority, required this.items, required this.complete});

	TodoList clone() {
		return TodoList(
			name: this.name,
			priority: List.from(this.priority),
			items: List.from(this.items),
			complete: List.from(this.complete),
		);
	}

}

// class TodoListAdapter extends TypeAdapter<TodoList> {
//   @override
//   final int typeId = 0;

//   @override
//   TodoList read(BinaryReader reader) {
//     final name = reader.readString();
//     final priority = reader.read();
//     final items = reader.read();
//     final complete = reader.read();

//     return TodoList(name: name, priority: priority, items: items, complete: complete);
//   }

//   @override
//   void write(BinaryWriter writer, TodoList obj) {
//     writer.writeString(obj.name);
//     writer.write(obj.priority);
//     writer.write(obj.items);
//     writer.write(obj.complete);
//   }
// }

@HiveType(typeId: 1)
class Todo extends HiveObject {
	@HiveField(0)
	String item;

	@HiveField(1)
	DateTime? dueDate;

	@HiveField(2)
	DateTime? completed;

	@HiveField(3)
	String? repeat;

	Todo({required this.item, required this.dueDate, this.completed, this.repeat});
}

// class TodoAdapter extends TypeAdapter<Todo> {
//   @override
//   final int typeId = 1;

//   @override
//   Todo read(BinaryReader reader) {
//     final item = reader.readString();
//     final dueDate = reader.read();
//     final completed = reader.read();
//     final repeat = reader.readString();

//     return Todo(item: item, dueDate: dueDate, completed: completed, repeat: repeat);
//   }

//   @override
//   void write(BinaryWriter writer, Todo obj) {
//     writer.writeString(obj.item);
//     writer.write(obj.dueDate);
//     writer.write(obj.completed);
//     writer.write(obj.repeat);
//   }
// }

Todo defTodo = Todo(item: "Pet a cat!", dueDate: null);

TodoList defTodoList = TodoList(name: "Default", priority: [], items: [defTodo], complete: []);
