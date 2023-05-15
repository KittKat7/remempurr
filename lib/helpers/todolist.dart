import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/classes/todolist.dart';
import 'package:remempurr/options.dart';

List<String> todoNames = [];
int todoNoteIndex = 0;

/// Initializes Hive and opens a box named 'remempurr'.
Future<void> initHive() async {
	// Initialize Hive
	await Hive.initFlutter();

	Hive.registerAdapter(TodoAdapter());

	Hive.registerAdapter(TodoListAdapter());

	try {
		var box = await Hive.openBox('remempurr');
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

	todoNames = [];
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
void deleteTodo(String key) {
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
		todoNoteIndex = -1;
	}
} // end nextTodoNote

void previousTodoNote() {
	todoNoteIndex --;
	if (todoNoteIndex < -1) {
		todoNoteIndex = todoNames.length - 1;
	}
} // end previousTodoNote

String getCurrentTodoName() {
	if (todoNoteIndex < 0) {
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

	box.put(name, TodoList(name: name, priority: [], items: [], complete: []));
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
	
	deleteTodo(key);
	newTodoNote(name: newKey);

	box.put(newKey, copy);
} // end renameTodoNote

