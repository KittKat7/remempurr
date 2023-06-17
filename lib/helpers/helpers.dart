import 'dart:async';
import 'dart:io';
import 'package:remempurr/classes/rmpr_file.dart';
import 'package:remempurr/classes/to_do.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/classes/rmpr_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/options.dart';

String formatDate(DateTime? date) {
	if (date == null) return "null";
	String formattedDate = 
		"${date.year.toString().padLeft(4, '0')}-"
		"${date.month.toString().padLeft(2, '0')}-"
		"${date.day.toString().padLeft(2, '0')} "
		"${date.hour.toString().padLeft(2, '0')}:"
		"${date.minute.toString().padLeft(2, '0')}";
		return formattedDate;
}

String formatDateString(String str) {
	DateTime? date = DateTime.tryParse(str);
	if (date == null) return "null";
	String formattedDate = 
		"${date.year.toString().padLeft(4, '0')}-"
		"${date.month.toString().padLeft(2, '0')}-"
		"${date.day.toString().padLeft(2, '0')} "
		"${date.hour.toString().padLeft(2, '0')}:"
		"${date.minute.toString().padLeft(2, '0')}";
		return formattedDate;
}

void exportToDoLists() async {
	String name = "Remempurr.md";
	String text = parseToString();
	print("Exporting");
	if (kIsWeb) {
		saveFileOnWeb(name, text);
	}
	else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
		saveFileOnDesktop(name, text);
	}
	else if (Platform.isAndroid) {
		saveFileOnMobile(name, text);
	}
	print("Exported");
}

void saveFileOnWeb(String name, String text) {
	final encodedContent = base64.encode(utf8.encode(text));
	final dataUri = 'data:text/plain;charset=utf-8;base64,$encodedContent';
	final anchorElement = html.AnchorElement(href: dataUri)
		..setAttribute('download', name)
		..click();
}

// not work on android?
void saveFileOnDesktop(String name, String text) async {
	const typeGroup = XTypeGroup(label: 'text', extensions: ['md']);
	final savePath = await getSavePath(
		acceptedTypeGroups: [typeGroup], 
		suggestedName: name
	);
	if (savePath == null) {
		// The user canceled the save dialog
		return;
	}
	final file = File(savePath);
	await file.writeAsString(text);
}

// void saveFileOnMobile(String name, String text) async {
//   final savePath = await FilePicker.platform.saveFile(
//     type: FileType.custom,
//     allowedExtensions: ['txt'],
// 		fileName: name
//   );
//   if (savePath == null) {
//     // The user canceled the save dialog
//     return;
//   }
//   final file = File(savePath);
//   await file.writeAsString(text);
// }


Future<void> saveFileOnMobile(String fileName, String content) async {
	// Requesting storage permission if not already granted
	if (Platform.isAndroid) {
		var status = await Permission.storage.status;
		if (!status.isGranted) {
			await Permission.storage.request();
		}
	}

	// Getting the base directory for storing files
	Directory? baseDir;
	if (Platform.isAndroid) {
		baseDir = await getExternalStorageDirectory();
	} else {
		baseDir = await getApplicationDocumentsDirectory();
	}

	if (baseDir != null) {
		// Creating the file
		File file = File('${baseDir.path}/$fileName');

		// Writing content to the file
		await file.writeAsString(content);

		// Showing a toast message with the file path
		print('File saved at: ${file.path}');
	} else {
		// Showing an error message if the base directory is null
		print('Error: Unable to get base directory');
	}
}

Future importToDoLists() async {
	print("importing");
	String? inData;
	if (kIsWeb) {
		inData = await selectFileWeb();
	}
	else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
		inData = await selectFileDesktop();
	}
	else if (Platform.isAndroid) {
		// saveFileOnMobile(name, text);
	}
	if (inData == null) {
		return;
	}
	print(inData);
	// toDoLists = parseFromString(inData); // TODO
	print("imported");
}


Future<String> selectFileWeb() async {
  // Create an input element
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  
  // Allow only text file types
  // uploadInput.accept = 'text/plain';
  
  // Trigger the file selection dialog
  uploadInput.click();
  
  // Wait for the user to select a file
  await uploadInput.onChange.first;
  
  // Access the selected file
  final file = uploadInput.files!.first;
  
  // Create a FileReader
  final reader = html.FileReader();
  
  // Read the file content as text
  reader.readAsText(file);
  
  // Wait for the file to be read
  await reader.onLoad.first;
  
  // Get the text content as a String
  final text = reader.result as String;
  
  return text;
}



// Future<String?> selectFileWeb() async {
// 	// Pick a file.
// 	FilePickerResult? result = await FilePicker.platform.pickFiles(
// 		type: FileType.any,
// 		withData: true,
// 	);

// 	// Check if the user picked a file.
// 	if (result == null) {
// 		return null;
// 	}

// 	// Get the file's data as a string.
// 	String data = String.fromCharCodes(result.files.single.bytes!);

// 	// Return the file's data.
// 	return data;
// }

Future<String?> selectFileDesktop() async {
	FilePickerResult? result = await FilePicker.platform.pickFiles();
	if (result != null) {
		File file = File(result.files.single.path!);
		String data = await file.readAsString();
		return data;
	}
	return null;
}


/* =========== HELPERS ========== */

ToDo defToDoP = ToDo(desc: "Pet a cat NOW!", noteName: "Default", tags: {"star":""});
ToDo defToDoN = ToDo(desc: "Pet a cat.", noteName: "Default", tags: {});
ToDo defToDoC = ToDo(desc: "Make a note, Good Job :)", noteName: "Default", tags: {});

RmprNote defToDoNote = RmprNote(
	name: "Default",
	note: "Default Note",
	data: {RmprNote.dataKeys['toDoItems']!: <ToDo>[defToDoP.clone(), defToDoN.clone(), defToDoC.clone()]},
	// toDoItems: [defToDoP.clone(), defToDoN.clone(), defToDoC.clone().setCompleted(DateTime.now())],
	tags: {}
);

// Map<String, ToDoList> toDoLists = {};
RmprFile currentFile = RmprFile(
	name: 'Remempurr', path: "remempurr", notes: {defToDoNote.name: defToDoNote}, tags: {},
);

// String currentFile = "remempurr";
String currentName = keyAll;


/// Initializes Hive and opens a box named 'remempurr'.
Future<void> initHive() async {
	// Initialize Hive
	await Hive.initFlutter();

	Hive.registerAdapter(ToDoAdapter());

	Hive.registerAdapter(RmprNoteAdapter());

	Hive.registerAdapter(RmprFileAdapter());

	try {
		await Hive.openBox('remempurr');
	} catch (e) {
		// ignore: avoid_print
		print("AN ERROR HAS OCCURED!!!\n$e\n+++++");

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

/// Loads the ToDo notes from a Hive box.
void loadToDoNotes() {
	// Get the Hive box named 'remempurr'.
	var box = Hive.box('remempurr');
	
	// If the box is empty,
	if (box.isEmpty) {
		// Add a default note list with a saveVersion tag.
		box.put("tags", <String, String>{"saveVersion": "0"});
		box.put("remempurr", RmprFile(
			name: 'Remempurr', path: "remempurr", notes: {defToDoNote.name: defToDoNote}, tags: {},
		));
	} // end if

	// TODO
	if (box.keys.toList().contains("tags") && box.get("tags").containsKey("saveVersion")) {
		
	} else {
		// ignore: avoid_print
		print("+++++\nERROR - saveVersion tag non-existant\n+++++");
	}
	
	// Set the currentFile to the value stored in the 'remempurr' key in the box.
	currentFile = box.get("remempurr");

	for (RmprNote note in currentFile.notes.values) {
		note.data[RmprNote.dataKeys['toDoItems']!] =
			(note.data[RmprNote.dataKeys['toDoItems']!] as List).map((item) => item as ToDo).toList();
	}

	// If the currentFile has no notes, add a default note.
	if (currentFile.notes.isEmpty) {
		currentFile.notes[defToDoNote.name] = defToDoNote;
	}
	// Save the current ToDo notes.
	saveRmprFile();

} // end loadToDoNotes


/// Saves the current ToDo notes to a Hive box.
void saveRmprFile() {
	// Get the Hive box named 'remempurr'.
	var box = Hive.box('remempurr');

	// If the currentFile is the cached file or has an empty path,
	// save it to the 'remempurr' key in the box.
	if (currentFile.path.isEmpty || currentFile.name == "Remempurr") {
		box.put("remempurr", currentFile);
	} // end if
	// Else, the file is loaded from the system.
	else {

	} // end else
} // end saveToDoNotes


/// Adds a new ToDo item to the given RmprNote with the given text.
void newToDo(RmprNote note, String text) {
	// Call the newToDo method on the given RmprNote with the given text.
	note.newToDo(text);
	// Save the current ToDo notes.
	saveRmprFile();
} // end newToDo


/// Deletes the given ToDo item from the RmprNote with the same noteName as the ToDo item.
void delToDo(ToDo toDo) {
	// If the RmprNote with the same noteName as the ToDo item does not exist, return.
	if (getRmprNote(toDo.noteName) == null) {
		return;
	}
	// Call the delToDo method on the RmprNote with the same noteName as the ToDo item.
	getRmprNote(toDo.noteName)!.delToDo(toDo);
	// Save the current ToDo notes.
	saveRmprFile();
} // end delToDo


/// Returns the RmprNote with the given name from the currentFile's map of notes.
RmprNote? getRmprNote(String name) {
	// If the currentFile's map of notes contains the given name as a key,
	// return the value associated with that key.
	if (currentFile.notes.containsKey(name)) {
		return currentFile.notes[name];
	}
	// If no note with the given name is found, return null.
	return null;
} // end getRmprNote


/// Returns the current RmprNote.
RmprNote getCurrentNote() {
	// If the currentName is equal to keyAll,
	// return all ToDo items by calling the getAllToDos method.
	if (currentName == keyAll) {
		return getAllToDos();
	} // end if
	// Else, return the RmprNote associated with the currentName in the currentFile's map of notes.
	return currentFile.notes[currentName]!;
} // end getCurrentNote


/// Returns a RmprNote containing all ToDo items from all notes in the currentFile.
RmprNote getAllToDos() {
	// Create an empty list of ToDo items.
	var noteAll = RmprNote(name: keyAll, note: "All Items", data: <String, dynamic>{}, tags: {});
	// Loop through the values in the currentFile's map of notes.
	for (RmprNote note in currentFile.notes.values) {
		// Add the note's list of ToDo items to the toDoList.
		noteAll.toDoItems.addAll(note.toDoItems);
	} // end for

	// Return a new RmprNote with the name keyAll, a note of "All Items",
	// the toDoList as its list of ToDo items, and an empty map of tags.
	return noteAll;
} // end getAllToDos


/// Creates a new RmprNote with the given name and returns it.
/// 
/// [name] - The name of the new note.
/// 
/// Returns the newly created RmprNote.
RmprNote newRmprNote(String name) {
  // Check if the name is unique and make it unique if necessary
  name = noteNameValicCheck(name);
  // Create a new RmprNote with the given name and add it to the current file's notes
  currentFile.notes[name] = RmprNote(name: name, note: "", data: {}, tags: {});
  // Save the changes to the current file's notes
  saveRmprFile();
  // Return the newly created RmprNote
  return currentFile.notes[name]!;
} // end newRmprNote


/// Removes the [RmprNote] with the given [name] from the [currentFile]'s map of notes.
/// 
/// After removing the note, the current ToDo notes are saved by calling [saveRmprFile].
void delRmprNote(String name) {
  // Remove the RmprNote with the given name from the currentFile's map of notes.
  currentFile.notes.remove(name);
  // Save the current ToDo notes.
  saveRmprFile();
} // end delRmprNote


/// Checks if a note with the given name already exists in the current file.
/// If it does, appends a number to the name to make it unique.
/// 
/// [name] - The name of the note to check for uniqueness.
/// 
/// Returns a unique name for the note.
String noteNameValicCheck(String name) {
  // Check if a note with the given name already exists
  if (currentFile.notes.containsKey(name)) {
    int count = 1;
    // Keep incrementing the count until a unique name is found
    while (currentFile.notes.containsKey("$name $count")) {
      count ++;
    } // end while
    // Append the count to the name to make it unique
    name = "$name $count";
  } // end if
  return name;
} // end todoNamesDupCheck


/// Returns the name of the next note in the current file's notes.
/// 
/// If the current note is the last note, returns the key for all notes.
String nextNoteName() {
	// Get a list of all note names in the current file
	List<String> notes = currentFile.notes.keys.toList();
	// Sort the note names
	notes.sort();
	// Check if the current note is the key for all notes
	if (currentName == keyAll) {
		// Return the first note name
		return notes.first;
	} else if (notes.indexOf(currentName) + 1 >= notes.length) {
		// If the current note is the last note, return the key for all notes
		return keyAll;
	} else {
		// Otherwise, return the name of the next note
		return notes[notes.indexOf(currentName) + 1];
	} // end if elif else
} // end nextNoteName


/// Returns the name of the previous note in the current file's notes.
/// 
/// If the current note is the first note, returns the key for all notes.
String prevNoteName() {
	// Get a list of all note names in the current file
	List<String> notes = currentFile.notes.keys.toList();
	// Sort the note names
	notes.sort();
	// Check if the current note is the key for all notes
	if (currentName == keyAll) {
		// Return the last note name
		return notes.last;
	} else if (notes.indexOf(currentName) <= 0) {
		// If the current note is the first note, return the key for all notes
		return keyAll;
	} else {
		// Otherwise, return the name of the previous note
		return notes[notes.indexOf(currentName) - 1];
	} // end if elif else
} // end prevNoteName


/// Renames a note in the current file's notes.
/// 
/// [current] - The current name of the note to rename.
/// [newName] - The new name for the note.
void renameNote(String current, String newName) {
	// Check if a note with the current name exists
	if (!currentFile.notes.containsKey(current)) {
		return;
	}
	// Clone the note with the current name and add it to the current file's notes with the new name
	currentFile.notes[newName] = currentFile.notes[current]!.clone();
	// Remove the note with the current name
	currentFile.notes.remove(current);
	// Update the name of the cloned note
	currentFile.notes[newName]!.name = newName;
	// If the current note is the one being renamed, update the current note name
	if (currentName == current) {
		currentName = newName;
	}
	// save changes
	saveRmprFile();
}


/* =========== TODO =========== */

String parseToString() {
	return "";
}

// 	/// Sorts the items in the priority, items, and complete lists.
// 	ToDoList sortItems() {
// 		List<ToDo> tmp = List.from(todoItems);
// 		List<ToDo> priority = [];
// 		List<ToDo> normal = [];
// 		List<ToDo> completed = [];

// 		for (ToDo td in tmp) {
// 			if (td.isComplete()) {
// 				completed.add(td);
// 			} else if (td.isPriority()) {
// 				priority.add(td);
// 			} else {
// 				normal.add(td);
// 			}
// 		}

// 		// Sort the items in the priority list based on their due date.
// 		priority.sort((a, b) {
// 			if (a.getDueDate() == null && b.getDueDate() == null) {
// 				// If both items have no due date, sort them alphabetically.
// 				return a.desc.compareTo(b.desc);
// 			} else if (a.getDueDate() == null) {
// 				// If the first item has no due date, sort it after the second item.
// 				return 1;
// 			} else if (b.getDueDate() == null) {
// 				// If the second item has no due date, sort it after the first item.
// 				return -1;
// 			} else {
// 				// If both items have a due date, sort them based on their due date.
// 				if (a.getDueDate()!.compareTo(b.getDueDate()!) == 0) {
// 					// If both items have the same due date, sort them alphabetically.
// 					return a.desc.compareTo(b.desc);
// 				} else {
// 					// Sort the items based on their due date.
// 					return a.getDueDate()!.compareTo(b.getDueDate()!);
// 				} // end if else
// 			} // end if elif elif else
// 		}); // end sort

// 		// Sort the items in the normal list based on their due date.
// 		normal.sort((a, b) {
// 			if (a.getDueDate() == null && b.getDueDate() == null) {
// 				// If both items have no due date, sort them alphabetically.
// 				return a.desc.compareTo(b.desc);
// 			} else if (a.getDueDate() == null) {
// 				// If the first item has no due date, sort it after the second item.
// 				return 1;
// 			} else if (b.getDueDate() == null) {
// 				// If the second item has no due date, sort it after the first item.
// 				return -1;
// 			} else {
// 				// If both items have a due date, sort them based on their due date.
// 				if (a.getDueDate()!.compareTo(b.getDueDate()!) == 0) {
// 					// If both items have the same due date, sort them alphabetically.
// 					return a.desc.compareTo(b.desc);
// 				} else {
// 					// Sort the items based on their due date.
// 					return a.getDueDate()!.compareTo(b.getDueDate()!);
// 				} // end if else
// 			} // end if elif elif else
// 		}); // end sort

// 		// Sort the items in the complete list based on their completion date.
// 		completed.sort((a, b) {
// 			if (a.tags[compDate] == null && b.tags[compDate] == null) {
// 					// If both items have no completion date, sort them alphabetically.
// 					return a.desc.compareTo(b.desc);
// 				} else if (a.tags[compDate] == null) {
// 					// If the first item has no completion date, sort it after the second item.
// 					return 1;
// 				} else if (b.tags[compDate] == null) {
// 					// If the second item has no completion date, sort it after the first item.
// 					return -1;
// 				} else {
// 					// If both items have a completion date, sort them based on their completion date.
// 					if (a.tags[compDate]!.compareTo(b.tags[compDate]!) == 0) {
// 						// If both items have the same completion date, sort them alphabetically.
// 						return a.desc.compareTo(b.desc);
// 					} else {
// 						// Sort the items based on their completion date., inverted
// 						return (b.tags[compDate]!.compareTo(a.tags[compDate]!));
// 					} // end if else
// 				} // end if elif elif else
// 		}); // end sort

// /* =========== HELPERS =========== */

// ToDo defToDoP = ToDo(desc: "Pet a cat NOW!", listName: "Default", tags: {"asap":""});
// ToDo defToDoN = ToDo(desc: "Pet a cat.", listName: "Default", tags: {});
// ToDo defToDoC = ToDo(desc: "Make a note, Good Job :)", listName: "Default", tags: {});

// ToDoList defToDoList = ToDoList(
// 	name: "Default",
// 	note: "Desault list",
// 	todoItems: [defToDoP.clone(), defToDoN.clone(), defToDoC.clone().setCompleted(DateTime.now())],
// 	tags: {}
// );

// Map<String, ToDoList> toDoLists = {};

// String currentFile = "remempurr";
// String currentList = keyAll;

// int saveFormetVersion = 0;

// /// Returns a sorted list of keys from the `toDoLists` map.
// ///
// /// The first element of the original list of keys is removed,
// /// then the remaining keys are sorted in ascending order,
// /// and finally the first element is re-inserted at the beginning of the list.
// List<String> get sortedKeys {
// 	// Get a list of keys from the `toDoLists` map
// 	List<String> keys = toDoLists.keys.toList();
	
// 	// Remove the first element from the list of keys
// 	String firstElement = keys.removeAt(0);
	
// 	// Sort the remaining keys in ascending order
// 	keys.sort((a, b) => a.compareTo(b));
	
// 	// Re-insert the first element at the beginning of the list
// 	keys.insert(0, firstElement);
	
// 	// Return the sorted list of keys
// 	return keys; // ['c', 'a', 'b', 'd']
// } // end get sortedKeys

// /// Initializes Hive and opens a box named 'remempurr'.
// Future<void> initHive() async {
// 	// Initialize Hive
// 	await Hive.initFlutter();

// 	Hive.registerAdapter(ToDoAdapter());

// 	Hive.registerAdapter(ToDoListAdapter());

// 	try {
// 		await Hive.openBox('remempurr');
// 	} catch (e) {
// 		thrownError = "The note database has failed to load properly.";
// 		hasError = true;
// 		try {
// 			Hive.deleteBoxFromDisk('remempurr');
// 			await Hive.openBox('remempurr');
// 			thrownError = "The note database has failed to load properly. The notes were reset, and"
// 				" loading now works";
// 		} catch (e) {
// 			thrownError = "The note database has failed to load properly, twice.";
// 		}
		
// 	}

// }

// /// Loads the to-do notes from the Hive box and returns them as a map.
// ///
// /// Returns a map of to-do notes where the key is the name of the note list and the value is
// /// the ToDoList object.
// void loadToDoNotes() {
// 	// Get the Hive box
// 	var box = Hive.box('remempurr');
// 	print("---\n${box.keys}");
// 	if (box.keys.toList().contains("version") && !box.keys.toList().contains("tags")) {
// 		box.delete("version");
// 		box.put("tags", <String, String>{"version": saveFormetVersion.toString()});
// 	}

// 	// TODO
// 	if (box.keys.toList().isNotEmpty && !box.keys.toList().contains("tags")) {
// 		// print(box.toMap());
// 		toDoLists = box.toMap().cast<String, ToDoList>();
// 		toDoLists[keyAll] = ToDoList(name: keyAll, note: "", todoItems: [], tags: {});
// 		box.deleteAll(box.keys);
// 		saveToDoLists();
// 		box.put("tags", <String, String>{"version": saveFormetVersion.toString()});
// 	}
	
	
// 	// If the box is empty
// 	if (box.keys.toList().isEmpty || !box.containsKey("remempurr")) {
// 		// Add a default note list
// 		box.put("remempurr", <String, ToDoList>{});
// 		box.put("tags", <String, String>{});
		
// 	} // end if
// 	toDoLists = box.get("remempurr").cast<String, ToDoList>();

// 	if (toDoLists.length < 2) {
// 		toDoLists["Default"] = defToDoList;
// 	}
// 	if (!toDoLists.containsKey(keyAll)) {
// 		toDoLists[keyAll] = ToDoList(name: keyAll, note: "", todoItems: [], tags: {});
// 	}

// 	saveToDoLists();

// } // end loadToDoNotes


// /// Deletes a to-do note with the given key from the Hive box named 'remempurr' and from the
// /// todoNotes map.
// void deleteToDoList(String key) {
// 	// // Get the Hive box
// 	// var box = Hive.box('remempurr');

// 	// // Delete the note from the box
// 	// box.delete(key);
	
// 	// // Delete the note from the todoNotes map
// 	// toDoNames.remove(key);

// 	toDoLists.remove(key);
// 	saveToDoLists();


// } // end deleteToDo


// void setToDoNote(String key) {
// 	currentList = key;
// } // end setNote

// void nextToDoNote() {
// 	List<String> list = sortedKeys;

// 	if (list.indexOf(currentList) + 1 >= list.length) {
// 		currentList = list.first;
// 	} else {
// 		currentList = list[list.indexOf(currentList) + 1];
// 	}

// 	// toDoNoteIndex ++;
// 	// if (toDoNoteIndex >= toDoNames.length) {
// 	// 	toDoNoteIndex = 0;
// 	// }
// } // end nextToDoNote

// void previousToDoNote() {
// 	List<String> list = sortedKeys;

// 	if (list.indexOf(currentList) - 1 < 0) {
// 		currentList = list.last;
// 	} else {
// 		currentList = list[list.indexOf(currentList) - 1];
// 	}
	
// 	// toDoNoteIndex --;
// 	// if (toDoNoteIndex < 0) {
// 	// 	toDoNoteIndex = toDoNames.length - 1;
// 	// }
// } // end previousToDoNote

// String getCurrentList() {
// 	return currentList;
	
// 	// if (toDoNoteIndex == 0) {
// 	// 	return "=ALL=";
// 	// }
// 	// return toDoNames[toDoNoteIndex];
// } // end getCurrentToDoName

// bool lNameValid(String name) {
// 	Set<String> invalid = {
// 		"=all=",
// 	};
// 	if (invalid.contains(name.toLowerCase())) {
// 		return false;
// 	}
// 	return true;
// }

// String lNameDupCheck(String name) {
// 	if (toDoLists.containsKey(name) || !lNameValid(name)) {
// 		int count = 1;
// 		while (toDoLists.containsKey("$name $count")) {
// 			count ++;
// 		} // end while
// 		name = "$name $count";
// 	} // end if
// 	return name;
// } // end todoNamesDupCheck

// void newToDoList({String? name}) {
// 	name ??= "New To-Do List";
// 	name = lNameDupCheck(name);

// 	toDoLists[name] = ToDoList(name: name, note: "", todoItems: [], tags: {});
	
// 	// var box = Hive.box('remempurr');
// 	// name ??= "New To-Do List";

// 	// name = lNameDupCheck(name);

// 	// box.put(name, ToDoList(name: name, todoItems: []));
// 	// toDoNames.add(name);

// 	// toDoNames.sort((a, b) => a.compareTo(b));
// 	// toDoNoteIndex = toDoNames.indexOf(name);
// 	// // return todoNames;
// } // end newToDoNote

// ToDoList renameToDoList(String key, String newKey) {
// 	if (newKey.length <= 1 || !lNameValid(newKey)) {
// 		return getToDoList(getCurrentList());
// 	}
// 	newKey = lNameDupCheck(newKey);
// 	final ToDoList copy = toDoLists[key]!.clone();
// 	copy.name = newKey;
// 	deleteToDoList(key);

// 	newToDoList(name: newKey);
// 	for (ToDo k in copy.todoItems) {
// 		k.listName = newKey;
// 	}

// 	toDoLists[newKey] = copy;
// 	if (currentList == key) {
// 		currentList = newKey;
// 	}
// 	return getToDoList(getCurrentList());
	
// 	// var box = Hive.box('remempurr');
// 	// if (newKey.length <= 1 || !lNameValid(newKey)) {
// 	// 	return getToDoList(getCurrentList());
// 	// }
// 	// newKey = lNameDupCheck(newKey);
// 	// final ToDoList copy = box.get(key).clone();
// 	// copy.name = newKey;

// 	// deleteToDoList(key);
// 	// newToDoList(name: newKey);
// 	// for (ToDo k in copy.todoItems) {
// 	// 	k.listName = newKey;
// 	// }

// 	// box.put(newKey, copy);
// 	// return getToDoList(getCurrentList());
// } // end renameToDoNote

// ToDoList getToDoList(String name) {
// 	if (name == keyAll) {
// 		List<ToDo> allToDos = [];
// 		// for every list
// 		for (String k in toDoLists.keys) {	
// 				if (lNameValid(k)) {		
// 				// for every item
// 				for (ToDo td in toDoLists[k]!.todoItems) {
// 					allToDos.add(td);
// 				} // end for
// 			} // end for every list
// 		}
// 		toDoLists[keyAll]!.todoItems = allToDos;
// 		return toDoLists[keyAll]!;
// 	} // end if 
// 	return toDoLists[name]!;

// 	// var box = Hive.box('remempurr');
// 	// // if requesting all
// 	// if (name == keyAll) {
// 	// 	ToDoList allToDos = ToDoList(name: name, todoItems: []);
// 	// 	// for every list
// 	// 	for (String k in box.keys) {
// 	// 		ToDoList tmp = box.get(k);
			
// 	// 		// for every item
// 	// 		for (ToDo td in tmp.todoItems) {
// 	// 			allToDos.todoItems.add(td);
// 	// 		} // end for
// 	// 	} // end for every list
// 	// 	return allToDos.sortItems();
// 	// } // end if
// 	// return box.get(name);
// } // end getToDoList

// void newToDo(String desc) {
// 	// if no description was entered, cancel
// 	if (desc.isEmpty) return;

// 	// get the current list name
// 	String todoListName = getCurrentList();

// 	// add a new to-do to the list
// 	toDoLists[todoListName]!.todoItems.add(ToDo(desc: desc, listName: todoListName, tags: {}));

// 	saveToDoLists();

// 	// if (desc.isEmpty) return;
// 	// String todoNoteName = getCurrentList();
// 	// var box = Hive.box('remempurr');
// 	// ToDoList tdl = box.get(todoNoteName);
// 	// tdl.todoItems.add(ToDo(desc: desc, listName: todoNoteName, tags: {}));
// 	// tdl.sortItems();
// 	// saveToDoLists(name: todoNoteName, note: tdl);
// } // end newToDo

// void deleteToDo(ToDo item) {
// 	// if (!toDoLists.containsKey(item.listName)) {
// 	// 	String name = getCurrentList();
// 	// 	if (name == keyAll) {
// 	// 		return;
// 	// 	}
// 	// 	toDoLists[name]!.removeItem(item);
// 	// 	saveToDoLists();
// 	// }

// 	String? itemListName = item.getList();
	
// 	toDoLists[itemListName]!.removeItem(item);
// 	saveToDoLists();
	
// 	// var box = Hive.box('remempurr');

// 	// if (!toDoNames.contains(item.listName)) {
// 	// 	String name = getCurrentList();
// 	// 	if (name == keyAll) {
// 	// 		return;
// 	// 	}
// 	// 	ToDoList tdl = box.get(name);
// 	// 	tdl.removeItem(item);
// 	// 	saveToDoLists(name: name, note: tdl);
// 	// }

// 	// String? itemListName = item.getList();
	
// 	// ToDoList tdl = box.get(itemListName);
// 	// tdl.removeItem(item);
// 	// saveToDoLists(name: itemListName, note: tdl);
	
// } // end deleteToDo

// ToDoList prioritize(ToDo item) {
// 	String? itemListName = item.getList();
// 	saveToDoLists();
	
// 	return toDoLists[itemListName]!.prioritize(item);
	
// 	// var box = Hive.box('remempurr');

// 	// String? itemListName = item.getList();
	
// 	// ToDoList tdl = box.get(itemListName);
// 	// return tdl.prioritize(item);
	
// }

// ToDoList dePrioritize(ToDo item) {
// 	String? itemListName = item.getList();
// 	saveToDoLists();
	
// 	return toDoLists[itemListName]!.dePrioritize(item);
// 	// var box = Hive.box('remempurr');

// 	// String? itemListName = item.getList();

// 	// ToDoList tdl = box.get(itemListName);
// 	// return tdl.dePrioritize(item);
// }

// ToDoList togglePriority(ToDo item) {
// 	String? itemListName = item.getList();
// 	var ret = item.isPriority()?
// 		toDoLists[itemListName]!.dePrioritize(item) : toDoLists[itemListName]!.prioritize(item);
// 	saveToDoLists();

// 	return ret;
	
// 	// var box = Hive.box('remempurr');

// 	// String? itemListName = item.getList();
	
// 	// ToDoList tdl = box.get(itemListName);
// 	// var ret = item.isPriority()? tdl.dePrioritize(item) : tdl.prioritize(item);
// 	// saveToDoLists();
// 	// return ret;
	
// }

// ToDoList complete(ToDo item) {
// 	String? itemListName = item.getList();
// 	saveToDoLists();
	
// 	return toDoLists[itemListName]!.complete(item);
	
// 	// var box = Hive.box('remempurr');

// 	// String? itemListName = item.getList();

// 	// ToDoList tdl = box.get(itemListName);
// 	// return tdl.complete(item);
// }

// ToDoList uncomplete(ToDo item) {
// 	String? itemListName = item.getList();
// 	saveToDoLists();
	
// 	return toDoLists[itemListName]!.incomplete(item);

// 	// var box = Hive.box('remempurr');

// 	// String? itemListName = item.getList();

// 	// ToDoList tdl = box.get(itemListName);
// 	// return tdl.incomplete(item);
// }

// ToDoList toggleComplete(ToDo td) {
// 	var ret = td.isComplete()? uncomplete(td) : complete(td);
// 	saveToDoLists();
// 	return ret;
// }

// void closeBox() {
// 	saveToDoLists();
// 	Hive.close();
// }

// void setDueDate(ToDo td, DateTime? dt) {
// 	td.setDueDate(dt);
// 	saveToDoLists(name: td.listName);
// }

// void setComplete(ToDo td, DateTime? dt) {
// 	td.setCompleted(dt);
// 	saveToDoLists(name: td.listName);
// }

// void setDesc(ToDo td, String desc) {
// 	td.setDesc(desc);
// 	saveToDoLists(name: td.listName);
// }

// String parseToString() {
// 	String parsedString = "";
	
// 	void addLine(String txt) {
// 		parsedString += "$txt\n";
// 	}
	
// 	addLine("## Remempurr");
// 	addLine("#todo\n");
	
// 	for (String name in toDoLists.keys.toList()) {
// 		if (name != keyAll) {
// 			// print(name);
// 			// print(getToDoList(name).name);
// 			// print("\n");
// 		  addLine(getToDoList(name).toString());
// 		}
// 	}
// 	return parsedString;
// }

// Map<String, ToDoList> parseFromString(String dataIn) {
// 	int index = 0;
// 	List<String> lines = dataIn.split("\n");

// 	Map<String, ToDoList> parsed = {};
// 	// ignore heading line
// 	while (!lines[index].startsWith("## ")) {
// 		index ++;
// 	} index ++;// index is now at the line after the first heading

// 	// get tags for all / description
// 	String tmpStr = "";
// 	while (!lines[index].startsWith("### ")) {
// 		tmpStr += lines[index];
// 		index ++;
// 	} // index is now at first catagorie

// 	ToDoList toDoAll = ToDoList(name: keyAll, note: "", todoItems: [], tags: {});
// 	// find all the tags and build the description
// 	List<String> words = tmpStr.split(" ");
// 	for (String w in words) {
// 		// remove extra white space, " " or "\n", etc...
// 		w = w.trim();
// 		// if the word is a tag
// 		if (w.startsWith("#") && w[1] != '#') {
// 			// if the tag has a value
// 			if (w.contains(":")) {
// 				toDoAll.tags[w.split(":")[0].substring(1)] = w.split(":")[1];
// 			} else {
// 				toDoAll.tags[w.substring(1)] = "";
// 			} // end if else
// 		} else {
// 			toDoAll.note = "${toDoAll.note}$w ";
// 		} // end if else
// 	}

// 	parsed[keyAll] = toDoAll;
	
// 	String tmp = "\n";
// 	for (int i = index; i < lines.length; i++) {
// 		tmp += "${lines[i]}\n";
// 	}

// 	List<String> lists = tmp.split("\n### ");
// 	for (String list in lists) {
// 		if (list.isEmpty) {
// 			continue;
// 		}
// 		lines = list.split("\n");
// 		bool isToDoItems = false;
// 		ToDoList toDoList = ToDoList(name: lines[0].trim(), note: "", todoItems: [], tags: {});
		
// 		for (String line in lines) {
// 			if (lines.indexOf(line) == 0) continue;
// 			if (line.trim().isNotEmpty && !line.startsWith("- [") && !isToDoItems && !line.startsWith("##")) {
// 				words = line.split(" ");
// 				for (String w in words) {
// 					// if the word is a tag
// 					if (w.startsWith("#") && w[1] != '#') {
// 						w = w.substring(1);
// 						// if the tag has a value
// 						if (w.contains(":")) {
// 							toDoList.tags[w.split(":")[0]] = w.split(":")[1];
// 						} else {
// 							toDoList.tags[w] = "";
// 						} // end if else
// 					} else {
// 						toDoList.note = "${toDoList.note}$w ";
// 					} // end if else
// 				}
// 			} // end desc and tags

// 			// print(toDoList.name);

// 			if (line.startsWith("- [")) {
// 				isToDoItems = true;
// 				ToDo toDo = ToDo(desc: "", listName: toDoList.name, tags: {});
				
// 				line = line.trim();
// 				if (line.startsWith("- [x]")) {
// 					toDo.setCompleted(null);
// 				}
				
// 				if (line.startsWith("- [x]")) {
// 				  line = line.substring(5);
// 				} else if (line.startsWith("- [ ]")) {
// 					line = line.substring(5);
// 				} else if (line.startsWith("- []")) {
// 					line = line.substring(4);
// 				}
// 				line = line.trim();
// 				words = line.split(" ");
// 				for (String w in words) {
// 					// if the word is a tag
// 					if (w.startsWith("#") && w[1] != '#') {
// 						w = w.substring(1);
// 						// if the tag has a value
// 						if (w.contains(":")) {
// 							toDo.tags[w.split(":")[0]] = w.split(":")[1];
// 							print("${w.split(":")[0]} date -- ${toDo.tags[compDate]}");
// 						} else {
// 							toDo.tags[w] = "";
// 						} // end if else
// 					} else {
// 						toDo.desc = "${toDo.desc}$w ";
// 					} // end if else
// 				}
// 				toDo.desc = toDo.desc.trim();
// 				toDoList.todoItems.add(toDo);
// 				print("comp: ${toDo.getCompDate()} - ${toDo.tags[compDate]}");
// 			} // end desc and tags
			
// 		} // end for line
// 		parsed[toDoList.name] = toDoList;
// 	} // end for list
	

// 	return parsed;
// }