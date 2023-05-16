import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/options.dart';

part 'todolist.g.dart';

const String todoAllName = "=ALL=";

@HiveType(typeId: 0)
class TodoList extends HiveObject {
	// name of todo list
	// list<string> of prioreties
	// list<string> of items
	// list<string> completed
	
	@HiveField(0)
	String name;

	@HiveField(1)
	List<Todo> todoItems;

	TodoList({required this.name, required this.todoItems});

	TodoList clone() {
		return TodoList(
			name: name,
			todoItems: List.from(todoItems),
		);
	}

	TodoList prioritize(Todo item) {
		item.tags.add("asap");
		return sortItems();
	}

	TodoList dePrioritize(Todo item) {
		item.tags.remove("asap");
		return sortItems();
	}

	TodoList complete(Todo item) {
		item.setCompleted(DateTime.now());
		return sortItems();
	}

	TodoList uncomplete(Todo item) {
		item.setCompleted(null);
		return sortItems();
	}

	/// Sorts the items in the priority, items, and complete lists.
	TodoList sortItems() {
		List<Todo> tmp = List.from(todoItems);
		List<Todo> priority = [];
		List<Todo> normal = [];
		List<Todo> completed = [];

		for (Todo td in tmp) {
			if (td.isComplete()) {
				completed.add(td);
			} else if (td.isPriority()) {
				priority.add(td);
			} else {
				normal.add(td);
			}
		}

		// Sort the items in the priority list based on their due date.
		priority.sort((a, b) {
			if (a.getDueDate() == null && b.getDueDate() == null) {
				// If both items have no due date, sort them alphabetically.
				return a.item.compareTo(b.item);
			} else if (a.getDueDate() == null) {
				// If the first item has no due date, sort it after the second item.
				return 1;
			} else if (b.getDueDate() == null) {
				// If the second item has no due date, sort it after the first item.
				return -1;
			} else {
				// If both items have a due date, sort them based on their due date.
				if (a.getDueDate()!.compareTo(b.getDueDate()!) == 0) {
					// If both items have the same due date, sort them alphabetically.
					return a.item.compareTo(b.item);
				} else {
					// Sort the items based on their due date.
					return a.getDueDate()!.compareTo(b.getDueDate()!);
				} // end if else
			} // end if elif elif else
		}); // end sort

		// Sort the items in the normal list based on their due date.
		normal.sort((a, b) {
			if (a.getDueDate() == null && b.getDueDate() == null) {
				// If both items have no due date, sort them alphabetically.
				return a.item.compareTo(b.item);
			} else if (a.getDueDate() == null) {
				// If the first item has no due date, sort it after the second item.
				return 1;
			} else if (b.getDueDate() == null) {
				// If the second item has no due date, sort it after the first item.
				return -1;
			} else {
				// If both items have a due date, sort them based on their due date.
				if (a.getDueDate()!.compareTo(b.getDueDate()!) == 0) {
					// If both items have the same due date, sort them alphabetically.
					return a.item.compareTo(b.item);
				} else {
					// Sort the items based on their due date.
					return a.getDueDate()!.compareTo(b.getDueDate()!);
				} // end if else
			} // end if elif elif else
		}); // end sort

		// Sort the items in the complete list based on their completion date.
		completed.sort((a, b) {
			if (a.vars[compDate] == null && b.vars[compDate] == null) {
					// If both items have no completion date, sort them alphabetically.
					return a.item.compareTo(b.item);
				} else if (a.vars[compDate] == null) {
					// If the first item has no completion date, sort it after the second item.
					return 1;
				} else if (b.vars[compDate] == null) {
					// If the second item has no completion date, sort it after the first item.
					return -1;
				} else {
					// If both items have a completion date, sort them based on their completion date.
					if (a.vars[compDate]!.compareTo(b.vars[compDate]!) == 0) {
						// If both items have the same completion date, sort them alphabetically.
						return a.item.compareTo(b.item);
					} else {
						// Sort the items based on their completion date.
						return a.vars[compDate]!.compareTo(b.vars[compDate]!);
					} // end if else
				} // end if elif elif else
		}); // end sort

		todoItems = priority + normal + completed;
		return this;
	} // end sortItems

	void removeItem(Todo item) {
		todoItems.remove(item);
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

var dueDate = "dueDate";
var compDate = "completed";

@HiveType(typeId: 1)
class Todo extends HiveObject {
	@HiveField(0)
	String item;

	@HiveField(1)
	String listName;

	@HiveField(2)
	List<String> tags;

	/// ```dart
	/// {dueDate: DateTime, completed: DateTime, repeat: String}
	/// ```
	@HiveField(3)
	Map<String, dynamic> vars;	

	Todo({required this.item, required this.listName, required this.tags, required this.vars});

	Todo clone() {
		return Todo(
			item: item,
			listName: listName,
			tags: tags,
			vars: vars,
		);
	}

	Todo setItem(String item) {
		this.item = item;
		return this;
	}

	Todo setDueDate(DateTime? date) {
		if (date == null) {
			if (vars.containsKey(dueDate)) {
				vars.remove(dueDate);
			}
		} else {
			vars[dueDate] = date;
		}
		return this;
	}

	DateTime? getDueDate() {
		return vars.containsKey(dueDate) ? vars[dueDate] : null;
	}

	Todo setCompleted(DateTime? date) {
		if (date == null) {
			if (vars.containsKey(compDate)) {
				vars.remove(compDate);
			}
		} else {
			vars[compDate] = date;
		}
		return this;
	}

	Todo addTag(String value) {
		tags.add(value);
		return this;
	}

	Todo removeTag(String key) {
		tags.remove(key);
		return this;
	}

	Todo setList(String value) {
		listName = value;
		return this;
	}

	String getList() {
		return listName;
	}

	bool isPriority() {
		return tags.contains("asap");
	}

	bool isComplete() {
		if (vars.containsKey(compDate)) {
			return true;
		}
		return false;
	}
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


/* =========== HELPERS =========== */

Todo defTodoP = Todo(item: "Pet a cat NOW!", listName: "Default", tags: ["asap"], vars: {});
Todo defTodoN = Todo(item: "Pet a cat.", listName: "Default", tags: [], vars: {});
Todo defTodoC = Todo(item: "Make a note, Good Job :)", listName: "Default", tags: [], vars: {});

TodoList defTodoList = TodoList(
	name: "Default",
	todoItems: [defTodoP.clone(), defTodoN.clone(), defTodoC.clone().setCompleted(DateTime.now())]
);


List<String> todoNames = [];
int todoNoteIndex = 0;

/// Initializes Hive and opens a box named 'remempurr'.
Future<void> initHive() async {
	// Initialize Hive
	await Hive.initFlutter();

	Hive.registerAdapter(TodoAdapter());

	Hive.registerAdapter(TodoListAdapter());

	try {
		await Hive.openBox('remempurr');
	} catch (e) {
		thrownError = "InPrivate firefox window";
		hasError = true;
	}

}

/// Loads the todo notes from the Hive box and returns them as a map.
///
/// Returns a map of todo notes where the key is the name of the note list and the value is
/// the TodoList object.
List<String> loadTodoNotes() {
	// Get the Hive box
	var box = Hive.box('remempurr');
	
	// Get the keys
	var keys = box.keys.toList();
	
	// If the box is empty
	if (keys.isEmpty) {
		// Add a default note list
		box.put("Default", defTodoList);
		
		// Update the keys
		keys = box.keys.toList();
	} // end if

	todoNames = ["=ALL=",];
	// Iterate over the keys
	for (String k in keys) {
		// add the key to the list
		todoNames.add(k);
	} // end for
	// sort alphabetically
	todoNames.sort((a, b) => a.compareTo(b));
	// Return the map of todo notes
	return todoNames;
} // end loadTodoNotes


/// Deletes a todo note with the given key from the Hive box named 'remempurr' and from the
/// todoNotes map.
void deleteTodoNote(String key) {
	// Get the Hive box
	var box = Hive.box('remempurr');

	// Delete the note from the box
	box.delete(key);
	
	// Delete the note from the todoNotes map
	todoNames.remove(key);

} // end deleteTodo


void setTodoNote(String key) {
	todoNoteIndex = todoNames.indexOf(key);
} // end setNote

void nextTodoNote() {
	todoNoteIndex ++;
	if (todoNoteIndex >= todoNames.length) {
		todoNoteIndex = 0;
	}
} // end nextTodoNote

void previousTodoNote() {
	todoNoteIndex --;
	if (todoNoteIndex < 0) {
		todoNoteIndex = todoNames.length - 1;
	}
} // end previousTodoNote

String getCurrentTodoName() {
	if (todoNoteIndex == 0) {
		return "=ALL=";
	}
	return todoNames[todoNoteIndex];
} // end getCurrentTodoName

String todoNamesDupCheck(String name) {
	if (todoNames.contains(name)) {
		int count = 1;
		while (todoNames.contains("$name $count")) {
			count ++;
		} // end while
		name = "$name $count";
	} // end if
	return name;
} // end todoNamesDupCheck

void newTodoNote({String? name}) {
	var box = Hive.box('remempurr');
	name ??= "New Todo";

	name = todoNamesDupCheck(name);

	box.put(name, TodoList(name: name, todoItems: []));
	todoNames.add(name);

	todoNames.sort((a, b) => a.compareTo(b));
	todoNoteIndex = todoNames.indexOf(name);
	// return todoNames;
} // end newTodoNote

void renameTodoNote(String key, String newKey) {
	var box = Hive.box('remempurr');
	if (newKey.length <= 1) {
		return;
	}
	newKey = todoNamesDupCheck(newKey);
	final TodoList copy = box.get(key).clone();
	
	deleteTodoNote(key);
	newTodoNote(name: newKey);
	for (Todo k in copy.todoItems) {
		k.listName = newKey;
	}

	box.put(newKey, copy);
} // end renameTodoNote

TodoList getTodoList(String name) {
	var box = Hive.box('remempurr');
	// if requesting all
	if (name == todoAllName) {
		TodoList allTodos = TodoList(name: name, todoItems: []);
		// for every list
		for (String k in box.keys) {
			TodoList tmp = box.get(k);
			
			// for every item
			for (Todo td in tmp.todoItems) {
				allTodos.todoItems.add(td);
			} // end for
		} // end for every list
		return allTodos.sortItems();
	} // end if
	return box.get(name);
} // end getTodoList

void saveTodoNotes({String? name, TodoList? note, Todo? item}) {
	var box = Hive.box('remempurr');

	List<TodoList> lists = [];

	if (name == todoAllName) {
		if (item != null) {
			box.put(item.listName, getTodoList(item.listName));
		}
		return;
	}

	if (name != null && note != null) {
		box.put(name, note);
	} // else {
	// 	for (String n in todoNames) {
	// 		if (n != todoAllName) {
	// 			print(todoNames);
	// 			print(n);
	// 			lists.add(getTodoList(n));
	// 		}
	// 	}
	// 	box.clear();
	// 	for (TodoList tdl in lists) {
	// 		box.put(tdl.name, tdl);
	// 	}
	// }

	// print("+++");
	// print(box.keys);

}

void newTodo(String item) {
	String todoNoteName = getCurrentTodoName();
	var box = Hive.box('remempurr');
	TodoList tdl = box.get(todoNoteName);
	tdl.todoItems.add(Todo(item: item, listName: todoNoteName, tags: [], vars: {}));
	tdl.sortItems();
	saveTodoNotes(name: todoNoteName, note: tdl);
} // end newTodo

void deleteTodo(Todo item) {
	var box = Hive.box('remempurr');

	if (!todoNames.contains(item.listName)) {
		String name = getCurrentTodoName();
		if (name == todoAllName) {
			return;
		}
		TodoList tdl = box.get(name);
		tdl.removeItem(item);
		saveTodoNotes(name: name, note: tdl);
		return;
	}

	String? itemListName = item.getList();
	
	TodoList tdl = box.get(itemListName);
	tdl.removeItem(item);
	saveTodoNotes(name: itemListName, note: tdl);
	
} // end newTodo

TodoList prioritize(Todo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();
	
	TodoList tdl = box.get(itemListName);
	return tdl.prioritize(item);
	
}

TodoList dePrioritize(Todo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	TodoList tdl = box.get(itemListName);
	return tdl.dePrioritize(item);
}

TodoList togglePriority(Todo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();
	
	TodoList tdl = box.get(itemListName);
	return item.isPriority()? tdl.dePrioritize(item) : tdl.prioritize(item);
	
}

TodoList complete(Todo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	TodoList tdl = box.get(itemListName);
	return tdl.complete(item);
}

TodoList uncomplete(Todo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	TodoList tdl = box.get(itemListName);
	return tdl.uncomplete(item);
}

void closeBox() {
	saveTodoNotes();
	Hive.close();
}