import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/options.dart';

part 'todolist.g.dart';

const String allToDoList = "=ALL=";
const String dueDate = "due";
const String compDate = "done";


@HiveType(typeId: 0)
class ToDoList extends HiveObject {
	
	@HiveField(0)
	String name;

	@HiveField(1)
	String? desc;

	@HiveField(2)
	List<ToDo> todoItems;

	@HiveField(3)
	Map<String, String?> tags = {};

	ToDoList({required this.name, this.desc, required this.todoItems,
		Map<String, String?>? tags}) : tags = tags ?? {};

	ToDoList clone() {
		return ToDoList(
			name: name,
			todoItems: List.from(todoItems),
		);
	}

	@override
	String toString() {
		String str = "### $name\n$desc";

		for (String key in tags.keys) {
			str += " ";
			str += "#$key";
			if (tags[key] != null ) str += ":${tags[key].toString()}";
		}
		str += "\n\n";

		List<ToDo> priority = [];
		List<ToDo> normal = [];
		List<ToDo> completed = [];

		for (ToDo td in todoItems) {
			if (td.isComplete()) {
				completed.add(td);
			} else if (td.isPriority()) {
				priority.add(td);
			} else {
				normal.add(td);
			}
		}

		str += "#### Priority\n";
		for (ToDo td in priority) {
			str += "${td.toString()}\n";
		} str += "\n";

		str += "#### Checklist\n";
		for (ToDo td in normal) {
			str += "${td.toString()}\n";
		} str += "\n";

		str += "#### Completed\n";
		for (ToDo td in completed) {
			str += "${td.toString()}\n";
		} str += "\n";

		return str;
	}

	ToDoList prioritize(ToDo item) {
		item.tags["ASAP"] = null;
		return sortItems();
	}

	ToDoList dePrioritize(ToDo item) {
		item.tags.remove("ASAP");
		item.tags.remove("asap");
		return sortItems();
	}

	ToDoList complete(ToDo item) {
		item.setCompleted(DateTime.now());
		return sortItems();
	}

	ToDoList incomplete(ToDo item) {
		item.unsetCompleted();
		return sortItems();
	}

	/// Sorts the items in the priority, items, and complete lists.
	ToDoList sortItems() {
		List<ToDo> tmp = List.from(todoItems);
		List<ToDo> priority = [];
		List<ToDo> normal = [];
		List<ToDo> completed = [];

		for (ToDo td in tmp) {
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
				return a.desc.compareTo(b.desc);
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
					return a.desc.compareTo(b.desc);
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
				return a.desc.compareTo(b.desc);
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
					return a.desc.compareTo(b.desc);
				} else {
					// Sort the items based on their due date.
					return a.getDueDate()!.compareTo(b.getDueDate()!);
				} // end if else
			} // end if elif elif else
		}); // end sort

		// Sort the items in the complete list based on their completion date.
		completed.sort((a, b) {
			if (a.tags[compDate] == null && b.tags[compDate] == null) {
					// If both items have no completion date, sort them alphabetically.
					return a.desc.compareTo(b.desc);
				} else if (a.tags[compDate] == null) {
					// If the first item has no completion date, sort it after the second item.
					return 1;
				} else if (b.tags[compDate] == null) {
					// If the second item has no completion date, sort it after the first item.
					return -1;
				} else {
					// If both items have a completion date, sort them based on their completion date.
					if (a.tags[compDate]!.compareTo(b.tags[compDate]!) == 0) {
						// If both items have the same completion date, sort them alphabetically.
						return a.desc.compareTo(b.desc);
					} else {
						// Sort the items based on their completion date., inverted
						return (b.tags[compDate]!.compareTo(a.tags[compDate]!));
					} // end if else
				} // end if elif elif else
		}); // end sort

		todoItems = priority + normal + completed;
		return this;
	} // end sortItems

	void removeItem(ToDo item) {
		todoItems.remove(item);
	}


}


@HiveType(typeId: 1)
class ToDo extends HiveObject {
	@HiveField(0)
	String desc;

	@HiveField(1)
	String listName;

	/// ```dart
	/// {dueDate: DateTime, completed: DateTime, repeat: String}
	/// ```
	@HiveField(2)
	Map<String, String?> tags = {};	

	ToDo({required this.desc, required this.listName, Map<String, String?>? tags}) {
		if (tags != null) {
			this.tags = tags;
		}
	}

	ToDo clone() {
		return ToDo(
			desc: desc,
			listName: listName,
			tags: tags,
		);
	}

	@override
	String toString() {
		String str = "";

		str += isComplete()? "- [x] " : "- [ ] ";
		str += desc;

		for (String key in tags.keys) {
			str += " ";
			str += "#$key";
			if (tags[key] != null ) str += ":${tags[key].toString()}";
		}

		return str;
	}

	ToDo setItem(String description) {
		desc = description;
		return this;
	}

	ToDo setDueDate(DateTime? date) {
		if (date == null) {
			if (tags.containsKey(dueDate)) {
				tags.remove(dueDate);
			}
		} else {
			tags[dueDate] = date.toString();
		}
		return this;
	}

	DateTime? getDueDate() {
		return tags.containsKey(dueDate) ? DateTime.parse(tags[dueDate]!) : null;
	}

	ToDo setCompleted(DateTime? date) {
		tags[compDate] = date?.toIso8601String();
		return this;
	}

	ToDo unsetCompleted() {
		tags.remove(compDate);
		return this;
	}

	bool isComplete() {
		if (tags.containsKey(compDate)) {
			return true;
		}
		return false;
	}

	DateTime? getCompDate() {
		if (tags[compDate] == null) {
			return null;
		}
		return DateTime.parse(tags[compDate]!);
	}

	bool isDue() {
		if (tags.containsKey(dueDate)) {
			return true;
		}
		return false;
	}

	ToDo setTag(String key, dynamic value) {
		tags[key] = value;
		return this;
	}

	ToDo unsetTag(String key) {
		tags.remove(key);
		return this;
	}

	dynamic getTag(String key) {
		if (tags.containsKey(key)) {
			return tags[key];
		}
		throw Error();
	}


	ToDo setList(String value) {
		listName = value;
		return this;
	}

	String getList() {
		return listName;
	}

	bool isPriority() {
		return tags.containsKey("asap") || tags.containsKey("ASAP")? true : false;
	}

	ToDo setDesc(String str) {
		desc = str;
		return this;
	}

	String getDesc() {
		return desc;
	}
}


/* =========== HELPERS =========== */

ToDo defToDoP = ToDo(desc: "Pet a cat NOW!", listName: "Default", tags: {"asap":null});
ToDo defToDoN = ToDo(desc: "Pet a cat.", listName: "Default", tags: {});
ToDo defToDoC = ToDo(desc: "Make a note, Good Job :)", listName: "Default", tags: {});

ToDoList defToDoList = ToDoList(
	name: "Default",
	todoItems: [defToDoP.clone(), defToDoN.clone(), defToDoC.clone().setCompleted(DateTime.now())]
);


List<String> todoNames = [];
int todoNoteIndex = 0;

/// Initializes Hive and opens a box named 'remempurr'.
Future<void> initHive() async {
	// Initialize Hive
	await Hive.initFlutter();

	Hive.registerAdapter(ToDoAdapter());

	Hive.registerAdapter(ToDoListAdapter());

	try {
		await Hive.openBox('remempurr');
	} catch (e) {
		thrownError = "The note database has failed to load properly.";
		hasError = true;
		try {
			Hive.deleteBoxFromDisk('remempurr');
			await Hive.openBox('remempurr');
			thrownError = "The note database has failed to load properly. The notes were reset, and"
				" loading now works";
		} catch (e) {
			thrownError = "The note database has failed to load properly, twice.";
		}
		
	}

}

/// Loads the to-do notes from the Hive box and returns them as a map.
///
/// Returns a map of to-do notes where the key is the name of the note list and the value is
/// the ToDoList object.
List<String> loadToDoNotes() {
	// Get the Hive box
	var box = Hive.box('remempurr');
	
	// Get the keys
	var keys = box.keys.toList();
	
	// If the box is empty
	if (keys.isEmpty) {
		// Add a default note list
		box.put("Default", defToDoList);
		
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
	// Return the map of to-do notes
	return todoNames;
} // end loadToDoNotes


/// Deletes a to-do note with the given key from the Hive box named 'remempurr' and from the
/// todoNotes map.
void deleteToDoNote(String key) {
	// Get the Hive box
	var box = Hive.box('remempurr');

	// Delete the note from the box
	box.delete(key);
	
	// Delete the note from the todoNotes map
	todoNames.remove(key);

} // end deleteToDo


void setToDoNote(String key) {
	todoNoteIndex = todoNames.indexOf(key);
} // end setNote

void nextToDoNote() {
	todoNoteIndex ++;
	if (todoNoteIndex >= todoNames.length) {
		todoNoteIndex = 0;
	}
} // end nextToDoNote

void previousToDoNote() {
	todoNoteIndex --;
	if (todoNoteIndex < 0) {
		todoNoteIndex = todoNames.length - 1;
	}
} // end previousToDoNote

String getCurrentToDoName() {
	if (todoNoteIndex == 0) {
		return "=ALL=";
	}
	return todoNames[todoNoteIndex];
} // end getCurrentToDoName

bool listNameIsValid(String name) {
	Set<String> invalid = {
		"=all=",
		"description", // contains {desc: "description", other tags...}
	};
	if (invalid.contains(name.toLowerCase())) {
		return false;
	}
	return true;
}

String listNameDupCheck(String name) {
	if (todoNames.contains(name) || !listNameIsValid(name)) {
		int count = 1;
		while (todoNames.contains("$name $count")) {
			count ++;
		} // end while
		name = "$name $count";
	} // end if
	return name;
} // end todoNamesDupCheck

void newToDoNote({String? name}) {
	var box = Hive.box('remempurr');
	name ??= "New ToDo";

	name = listNameDupCheck(name);

	box.put(name, ToDoList(name: name, todoItems: []));
	todoNames.add(name);

	todoNames.sort((a, b) => a.compareTo(b));
	todoNoteIndex = todoNames.indexOf(name);
	// return todoNames;
} // end newToDoNote

ToDoList renameToDoList(String key, String newKey) {
	var box = Hive.box('remempurr');
	if (newKey.length <= 1 || !listNameIsValid(newKey)) {
		return getToDoList(getCurrentToDoName());
	}
	newKey = listNameDupCheck(newKey);
	final ToDoList copy = box.get(key).clone();
	copy.name = newKey;

	deleteToDoNote(key);
	newToDoNote(name: newKey);
	for (ToDo k in copy.todoItems) {
		k.listName = newKey;
	}

	box.put(newKey, copy);
	return getToDoList(getCurrentToDoName());
} // end renameToDoNote

ToDoList getToDoList(String name) {
	var box = Hive.box('remempurr');
	// if requesting all
	if (name == allToDoList) {
		ToDoList allToDos = ToDoList(name: name, todoItems: []);
		// for every list
		for (String k in box.keys) {
			ToDoList tmp = box.get(k);
			
			// for every item
			for (ToDo td in tmp.todoItems) {
				allToDos.todoItems.add(td);
			} // end for
		} // end for every list
		return allToDos.sortItems();
	} // end if
	return box.get(name);
} // end getToDoList

void saveToDoNotes({String? name, ToDoList? note, ToDo? item}) {
	var box = Hive.box('remempurr');

	// List<ToDoList> lists = [];

	if (name == allToDoList) {
		if (item != null) {
			box.put(item.listName, getToDoList(item.listName));
		}
		return;
	}

	if (name != null) {
		box.put(name, getToDoList(name));
	} else if (note != null) {
		box.put(note.name, note);
	} // else {
	// 	for (String n in todoNames) {
	// 		if (n != todoAllName) {
	// 			print(todoNames);
	// 			print(n);
	// 			lists.add(getToDoList(n));
	// 		}
	// 	}
	// 	box.clear();
	// 	for (ToDoList tdl in lists) {
	// 		box.put(tdl.name, tdl);
	// 	}
	// }

	// print("+++");
	// print(box.keys);

}

void newToDo(String desc) {
	if (desc.isEmpty) return;
	String todoNoteName = getCurrentToDoName();
	var box = Hive.box('remempurr');
	ToDoList tdl = box.get(todoNoteName);
	tdl.todoItems.add(ToDo(desc: desc, listName: todoNoteName, tags: {}));
	tdl.sortItems();
	saveToDoNotes(name: todoNoteName, note: tdl);
} // end newToDo

void deleteToDo(ToDo item) {
	var box = Hive.box('remempurr');

	if (!todoNames.contains(item.listName)) {
		String name = getCurrentToDoName();
		if (name == allToDoList) {
			return;
		}
		ToDoList tdl = box.get(name);
		tdl.removeItem(item);
		saveToDoNotes(name: name, note: tdl);
	}

	String? itemListName = item.getList();
	
	ToDoList tdl = box.get(itemListName);
	tdl.removeItem(item);
	saveToDoNotes(name: itemListName, note: tdl);
	
} // end newToDo

ToDoList prioritize(ToDo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();
	
	ToDoList tdl = box.get(itemListName);
	return tdl.prioritize(item);
	
}

ToDoList dePrioritize(ToDo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	ToDoList tdl = box.get(itemListName);
	return tdl.dePrioritize(item);
}

ToDoList togglePriority(ToDo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();
	
	ToDoList tdl = box.get(itemListName);
	var ret = item.isPriority()? tdl.dePrioritize(item) : tdl.prioritize(item);
	saveToDoNotes();
	return ret;
	
}

ToDoList complete(ToDo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	ToDoList tdl = box.get(itemListName);
	return tdl.complete(item);
}

ToDoList uncomplete(ToDo item) {
	var box = Hive.box('remempurr');

	String? itemListName = item.getList();

	ToDoList tdl = box.get(itemListName);
	return tdl.incomplete(item);
}

ToDoList toggleComplete(ToDo td) {
	var ret = td.isComplete()? uncomplete(td) : complete(td);
	saveToDoNotes();
	return ret;
}

void closeBox() {
	saveToDoNotes();
	Hive.close();
}

String parseToString() {
	String parsedString = "";
	
	void addLine(String txt) {
		parsedString += "$txt\n";
	}
	
	addLine("## Remempurr");
	addLine("#todo\n");
	
	for (String name in todoNames) {
		if (name != allToDoList) {
			print(name);
			print(getToDoList(name).name);
			print("\n");
		  addLine(getToDoList(name).toString());
		}
	}
	return parsedString;
}

void setDueDate(ToDo td, DateTime? dt) {
	td.setDueDate(dt);
	saveToDoNotes(name: td.listName);
}

void setComplete(ToDo td, DateTime? dt) {
	td.setCompleted(dt);
	saveToDoNotes(name: td.listName);
}

void setDesc(ToDo td, String desc) {
	td.setDesc(desc);
	saveToDoNotes(name: td.listName);
}