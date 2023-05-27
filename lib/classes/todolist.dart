import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/options.dart';

part 'todolist.g.dart';

const String keyAll = "=ALL=";
const String dueDate = "due";
const String compDate = "done";


@HiveType(typeId: 0)
class ToDoList extends HiveObject {
	
	@HiveField(0)
	String name;

	@HiveField(1)
	String desc;

	@HiveField(2)
	List<ToDo> todoItems;

	@HiveField(3)
	Map<String, String> tags;

	ToDoList({required this.name, required this.desc, required this.todoItems, required this.tags});

	ToDoList clone() {
		return ToDoList(
			name: name,
			desc: desc,
			todoItems: List.from(todoItems),
			tags: tags,
		);
	}

	@override
	String toString() {
		String str = "### $name\n$desc";

		for (String key in tags.keys) {
			str += " ";
			str += "#$key";
			if (tags[key] != null) str += ":${tags[key].toString()}";
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
	} // end toString

	ToDoList prioritize(ToDo item) {
		item.tags["ASAP"] = "";
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
	Map<String, String> tags;	

	ToDo({required this.desc, required this.listName, required this.tags});

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
		if (date == null) {
			tags[compDate] = "";
			return this;
		}
		tags[compDate] = date.toIso8601String();
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

ToDo defToDoP = ToDo(desc: "Pet a cat NOW!", listName: "Default", tags: {"asap":""});
ToDo defToDoN = ToDo(desc: "Pet a cat.", listName: "Default", tags: {});
ToDo defToDoC = ToDo(desc: "Make a note, Good Job :)", listName: "Default", tags: {});

ToDoList defToDoList = ToDoList(
	name: "Default",
	desc: "Desault list",
	todoItems: [defToDoP.clone(), defToDoN.clone(), defToDoC.clone().setCompleted(DateTime.now())],
	tags: {}
);

Map<String, ToDoList> toDoLists = {};

String currentFile = "remempurr";
String currentList = keyAll;

int saveFormetVersion = 0;

/// Returns a sorted list of keys from the `toDoLists` map.
///
/// The first element of the original list of keys is removed,
/// then the remaining keys are sorted in ascending order,
/// and finally the first element is re-inserted at the beginning of the list.
List<String> get sortedKeys {
	// Get a list of keys from the `toDoLists` map
	List<String> keys = toDoLists.keys.toList();
	
	// Remove the first element from the list of keys
	String firstElement = keys.removeAt(0);
	
	// Sort the remaining keys in ascending order
	keys.sort((a, b) => a.compareTo(b));
	
	// Re-insert the first element at the beginning of the list
	keys.insert(0, firstElement);
	
	// Return the sorted list of keys
	return keys; // ['c', 'a', 'b', 'd']
} // end get sortedKeys

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
void loadToDoNotes() {
	// Get the Hive box
	var box = Hive.box('remempurr');
	
	if (box.keys.toList().contains("version") && !box.keys.toList().contains("tags")) {
		box.delete("version");
		box.put("tags", <String, String>{"version": saveFormetVersion.toString()});
	}

	// TODO
	if (box.keys.toList().isNotEmpty && !box.keys.toList().contains("tags")) {
		// print(box.toMap());
		toDoLists = box.toMap().cast<String, ToDoList>();
		toDoLists[keyAll] = ToDoList(name: keyAll, desc: "", todoItems: [], tags: {});
		box.deleteAll(box.keys);
		saveToDoLists();
		box.put("tags", <String, String>{"version": saveFormetVersion.toString()});
	}
	
	
	// If the box is empty
	if (box.keys.toList().isEmpty || !box.containsKey("remempurr")) {
		// Add a default note list
		box.put("remempurr", <String, ToDoList>{});
		box.put("tags", <String, String>{});
		
	} // end if
	toDoLists = box.get("remempurr").cast<String, ToDoList>();

	if (toDoLists.length < 2) {
		toDoLists["Default"] = defToDoList;
	}
	if (!toDoLists.containsKey(keyAll)) {
		toDoLists[keyAll] = ToDoList(name: keyAll, desc: "", todoItems: [], tags: {});
	}

	saveToDoLists();

} // end loadToDoNotes


/// Deletes a to-do note with the given key from the Hive box named 'remempurr' and from the
/// todoNotes map.
void deleteToDoList(String key) {
	// // Get the Hive box
	// var box = Hive.box('remempurr');

	// // Delete the note from the box
	// box.delete(key);
	
	// // Delete the note from the todoNotes map
	// toDoNames.remove(key);

	toDoLists.remove(key);
	saveToDoLists();


} // end deleteToDo


void setToDoNote(String key) {
	currentList = key;
} // end setNote

void nextToDoNote() {
	List<String> list = sortedKeys;

	if (list.indexOf(currentList) + 1 >= list.length) {
		currentList = list.first;
	} else {
		currentList = list[list.indexOf(currentList) + 1];
	}

	// toDoNoteIndex ++;
	// if (toDoNoteIndex >= toDoNames.length) {
	// 	toDoNoteIndex = 0;
	// }
} // end nextToDoNote

void previousToDoNote() {
	List<String> list = sortedKeys;

	if (list.indexOf(currentList) - 1 < 0) {
		currentList = list.last;
	} else {
		currentList = list[list.indexOf(currentList) - 1];
	}
	
	// toDoNoteIndex --;
	// if (toDoNoteIndex < 0) {
	// 	toDoNoteIndex = toDoNames.length - 1;
	// }
} // end previousToDoNote

String getCurrentList() {
	return currentList;
	
	// if (toDoNoteIndex == 0) {
	// 	return "=ALL=";
	// }
	// return toDoNames[toDoNoteIndex];
} // end getCurrentToDoName

bool lNameValid(String name) {
	Set<String> invalid = {
		"=all=",
	};
	if (invalid.contains(name.toLowerCase())) {
		return false;
	}
	return true;
}

String lNameDupCheck(String name) {
	if (toDoLists.containsKey(name) || !lNameValid(name)) {
		int count = 1;
		while (toDoLists.containsKey("$name $count")) {
			count ++;
		} // end while
		name = "$name $count";
	} // end if
	return name;
} // end todoNamesDupCheck

void newToDoList({String? name}) {
	name ??= "New To-Do List";
	name = lNameDupCheck(name);

	toDoLists[name] = ToDoList(name: name, desc: "", todoItems: [], tags: {});
	
	// var box = Hive.box('remempurr');
	// name ??= "New To-Do List";

	// name = lNameDupCheck(name);

	// box.put(name, ToDoList(name: name, todoItems: []));
	// toDoNames.add(name);

	// toDoNames.sort((a, b) => a.compareTo(b));
	// toDoNoteIndex = toDoNames.indexOf(name);
	// // return todoNames;
} // end newToDoNote

ToDoList renameToDoList(String key, String newKey) {
	if (newKey.length <= 1 || !lNameValid(newKey)) {
		return getToDoList(getCurrentList());
	}
	newKey = lNameDupCheck(newKey);
	final ToDoList copy = toDoLists[key]!.clone();
	copy.name = newKey;
	deleteToDoList(key);

	newToDoList(name: newKey);
	for (ToDo k in copy.todoItems) {
		k.listName = newKey;
	}

	toDoLists[newKey] = copy;
	if (currentList == key) {
		currentList = newKey;
	}
	return getToDoList(getCurrentList());
	
	// var box = Hive.box('remempurr');
	// if (newKey.length <= 1 || !lNameValid(newKey)) {
	// 	return getToDoList(getCurrentList());
	// }
	// newKey = lNameDupCheck(newKey);
	// final ToDoList copy = box.get(key).clone();
	// copy.name = newKey;

	// deleteToDoList(key);
	// newToDoList(name: newKey);
	// for (ToDo k in copy.todoItems) {
	// 	k.listName = newKey;
	// }

	// box.put(newKey, copy);
	// return getToDoList(getCurrentList());
} // end renameToDoNote

ToDoList getToDoList(String name) {
	if (name == keyAll) {
		List<ToDo> allToDos = [];
		// for every list
		for (String k in toDoLists.keys) {	
				if (lNameValid(k)) {		
				// for every item
				for (ToDo td in toDoLists[k]!.todoItems) {
					allToDos.add(td);
				} // end for
			} // end for every list
		}
		toDoLists[keyAll]!.todoItems = allToDos;
		return toDoLists[keyAll]!;
	} // end if 
	return toDoLists[name]!;

	// var box = Hive.box('remempurr');
	// // if requesting all
	// if (name == keyAll) {
	// 	ToDoList allToDos = ToDoList(name: name, todoItems: []);
	// 	// for every list
	// 	for (String k in box.keys) {
	// 		ToDoList tmp = box.get(k);
			
	// 		// for every item
	// 		for (ToDo td in tmp.todoItems) {
	// 			allToDos.todoItems.add(td);
	// 		} // end for
	// 	} // end for every list
	// 	return allToDos.sortItems();
	// } // end if
	// return box.get(name);
} // end getToDoList

void saveToDoLists({String? name, ToDoList? note, ToDo? item}) {
	toDoLists[keyAll]!.todoItems = [];
	
	var box = Hive.box('remempurr');

	box.put(currentFile, toDoLists);

	// if (name == keyAll || (name == null && note == null && item == null)) {
		
	// }

	// if (name == keyAll) {
	// 	if (item != null) {
	// 		box.put(item.listName, getToDoList(item.listName));
	// 	}
	// 	return;
	// }

	// if (name != null) {
	// 	box.put(name, getToDoList(name));
	// } else if (note != null) {
	// 	box.put(note.name, note);
	// } 
	
	// else {
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
	// if no description was entered, cancel
	if (desc.isEmpty) return;

	// get the current list name
	String todoListName = getCurrentList();

	// add a new to-do to the list
	toDoLists[todoListName]!.todoItems.add(ToDo(desc: desc, listName: todoListName, tags: {}));

	saveToDoLists();

	// if (desc.isEmpty) return;
	// String todoNoteName = getCurrentList();
	// var box = Hive.box('remempurr');
	// ToDoList tdl = box.get(todoNoteName);
	// tdl.todoItems.add(ToDo(desc: desc, listName: todoNoteName, tags: {}));
	// tdl.sortItems();
	// saveToDoLists(name: todoNoteName, note: tdl);
} // end newToDo

void deleteToDo(ToDo item) {
	// if (!toDoLists.containsKey(item.listName)) {
	// 	String name = getCurrentList();
	// 	if (name == keyAll) {
	// 		return;
	// 	}
	// 	toDoLists[name]!.removeItem(item);
	// 	saveToDoLists();
	// }

	String? itemListName = item.getList();
	
	toDoLists[itemListName]!.removeItem(item);
	saveToDoLists();
	
	// var box = Hive.box('remempurr');

	// if (!toDoNames.contains(item.listName)) {
	// 	String name = getCurrentList();
	// 	if (name == keyAll) {
	// 		return;
	// 	}
	// 	ToDoList tdl = box.get(name);
	// 	tdl.removeItem(item);
	// 	saveToDoLists(name: name, note: tdl);
	// }

	// String? itemListName = item.getList();
	
	// ToDoList tdl = box.get(itemListName);
	// tdl.removeItem(item);
	// saveToDoLists(name: itemListName, note: tdl);
	
} // end deleteToDo

ToDoList prioritize(ToDo item) {
	String? itemListName = item.getList();
	saveToDoLists();
	
	return toDoLists[itemListName]!.prioritize(item);
	
	// var box = Hive.box('remempurr');

	// String? itemListName = item.getList();
	
	// ToDoList tdl = box.get(itemListName);
	// return tdl.prioritize(item);
	
}

ToDoList dePrioritize(ToDo item) {
	String? itemListName = item.getList();
	saveToDoLists();
	
	return toDoLists[itemListName]!.dePrioritize(item);
	// var box = Hive.box('remempurr');

	// String? itemListName = item.getList();

	// ToDoList tdl = box.get(itemListName);
	// return tdl.dePrioritize(item);
}

ToDoList togglePriority(ToDo item) {
	String? itemListName = item.getList();
	var ret = item.isPriority()?
		toDoLists[itemListName]!.dePrioritize(item) : toDoLists[itemListName]!.prioritize(item);
	saveToDoLists();

	return ret;
	
	// var box = Hive.box('remempurr');

	// String? itemListName = item.getList();
	
	// ToDoList tdl = box.get(itemListName);
	// var ret = item.isPriority()? tdl.dePrioritize(item) : tdl.prioritize(item);
	// saveToDoLists();
	// return ret;
	
}

ToDoList complete(ToDo item) {
	String? itemListName = item.getList();
	saveToDoLists();
	
	return toDoLists[itemListName]!.complete(item);
	
	// var box = Hive.box('remempurr');

	// String? itemListName = item.getList();

	// ToDoList tdl = box.get(itemListName);
	// return tdl.complete(item);
}

ToDoList uncomplete(ToDo item) {
	String? itemListName = item.getList();
	saveToDoLists();
	
	return toDoLists[itemListName]!.incomplete(item);

	// var box = Hive.box('remempurr');

	// String? itemListName = item.getList();

	// ToDoList tdl = box.get(itemListName);
	// return tdl.incomplete(item);
}

ToDoList toggleComplete(ToDo td) {
	var ret = td.isComplete()? uncomplete(td) : complete(td);
	saveToDoLists();
	return ret;
}

void closeBox() {
	saveToDoLists();
	Hive.close();
}

void setDueDate(ToDo td, DateTime? dt) {
	td.setDueDate(dt);
	saveToDoLists(name: td.listName);
}

void setComplete(ToDo td, DateTime? dt) {
	td.setCompleted(dt);
	saveToDoLists(name: td.listName);
}

void setDesc(ToDo td, String desc) {
	td.setDesc(desc);
	saveToDoLists(name: td.listName);
}

String parseToString() {
	String parsedString = "";
	
	void addLine(String txt) {
		parsedString += "$txt\n";
	}
	
	addLine("## Remempurr");
	addLine("#todo\n");
	
	for (String name in toDoLists.keys.toList()) {
		if (name != keyAll) {
			// print(name);
			// print(getToDoList(name).name);
			// print("\n");
		  addLine(getToDoList(name).toString());
		}
	}
	return parsedString;
}

Map<String, ToDoList> parseFromString(String dataIn) {
	int index = 0;
	List<String> lines = dataIn.split("\n");

	Map<String, ToDoList> parsed = {};
	// ignore heading line
	while (!lines[index].startsWith("## ")) {
		index ++;
	} index ++;// index is now at the line after the first heading

	// get tags for all / description
	String tmpStr = "";
	while (!lines[index].startsWith("### ")) {
		tmpStr += lines[index];
		index ++;
	} // index is now at first catagorie

	ToDoList toDoAll = ToDoList(name: keyAll, desc: "", todoItems: [], tags: {});
	// find all the tags and build the description
	List<String> words = tmpStr.split(" ");
	for (String w in words) {
		// remove extra white space, " " or "\n", etc...
		w = w.trim();
		// if the word is a tag
		if (w.startsWith("#") && w[1] != '#') {
			// if the tag has a value
			if (w.contains(":")) {
				toDoAll.tags[w.split(":")[0].substring(1)] = w.split(":")[1];
			} else {
				toDoAll.tags[w.substring(1)] = "";
			} // end if else
		} else {
			toDoAll.desc = "${toDoAll.desc}$w ";
		} // end if else
	}

	parsed[keyAll] = toDoAll;
	
	String tmp = "\n";
	for (int i = index; i < lines.length; i++) {
		tmp += "${lines[i]}\n";
	}

	List<String> lists = tmp.split("\n### ");
	for (String list in lists) {
		if (list.isEmpty) {
			continue;
		}
		lines = list.split("\n");
		bool isToDoItems = false;
		ToDoList toDoList = ToDoList(name: lines[0].trim(), desc: "", todoItems: [], tags: {});
		
		for (String line in lines) {
			if (lines.indexOf(line) == 0) continue;
			if (line.trim().isNotEmpty && !line.startsWith("- [") && !isToDoItems && !line.startsWith("##")) {
				words = line.split(" ");
				for (String w in words) {
					// if the word is a tag
					if (w.startsWith("#") && w[1] != '#') {
						w = w.substring(1);
						// if the tag has a value
						if (w.contains(":")) {
							toDoList.tags[w.split(":")[0]] = w.split(":")[1];
						} else {
							toDoList.tags[w] = "";
						} // end if else
					} else {
						toDoList.desc = "${toDoList.desc}$w ";
					} // end if else
				}
			} // end desc and tags

			// print(toDoList.name);

			if (line.startsWith("- [")) {
				isToDoItems = true;
				ToDo toDo = ToDo(desc: "", listName: toDoList.name, tags: {});
				
				line = line.trim();
				if (line.startsWith("- [x]")) {
					toDo.setCompleted(null);
				}
				
				if (line.startsWith("- [x]")) {
				  line = line.substring(5);
				} else if (line.startsWith("- [ ]")) {
					line = line.substring(5);
				} else if (line.startsWith("- []")) {
					line = line.substring(4);
				}
				line = line.trim();
				words = line.split(" ");
				for (String w in words) {
					// if the word is a tag
					if (w.startsWith("#") && w[1] != '#') {
						w = w.substring(1);
						// if the tag has a value
						if (w.contains(":")) {
							toDo.tags[w.split(":")[0]] = w.split(":")[1];
							print("${w.split(":")[0]} date -- ${toDo.tags[compDate]}");
						} else {
							toDo.tags[w] = "";
						} // end if else
					} else {
						toDo.desc = "${toDo.desc}$w ";
					} // end if else
				}
				toDo.desc = toDo.desc.trim();
				toDoList.todoItems.add(toDo);
				print("comp: ${toDo.getCompDate()} - ${toDo.tags[compDate]}");
			} // end desc and tags
			
		} // end for line
		parsed[toDoList.name] = toDoList;
	} // end for list
	

	return parsed;
}