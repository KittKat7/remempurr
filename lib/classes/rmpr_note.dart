import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/classes/to_do.dart';
import 'package:remempurr/classes/undo_redo_manager.dart';
import 'package:remempurr/options.dart';
// import 'package:universal_html/html.dart';

part 'rmpr_note.g.dart';

/// A class representing a RmprNote object that extends HiveObject.
/// 
/// This class has a HiveType annotation with a typeId of 1.
@HiveType(typeId: 1)
class RmprNote extends HiveObject {
	
	static const Map<String, String> dataKeys = {
		'toDoItems': 'List<ToDo> toDoItems',
	};
	// static const String toDoItems = 'List<ToDo> toDoItems';


	/// The name of the RmprNote.
	@HiveField(0)
	String name;

	/// The note content of the RmprNote.
	@HiveField(1)
	String note;

	/// The data associated with the RmprNote.\
	/// `'toDoItems'` => `List<ToDo>`\
	/// `'timeSheet'` => `List<TimeCard>`\
	/// `'timeSheet'` => `List<Map<String, dynamic>>`
	@HiveField(2)
	Map<String, dynamic> data;

	/// A map of tags associated with the RmprNote.
	@HiveField(3)
	Map<String, String> tags;

	/// Creates a new RmprNote object with the given name, note, toDoItems, and tags.
	RmprNote({required this.name, required this.note, required this.data, required this.tags});

	/// Returns a clone of the current RmprNote object.
	RmprNote clone() {
		return RmprNote(
			name: name,
			note: note,
			data: data,
			tags: tags,
		);
	} // end clone

	List<ToDo> get toDoItems {
		if (!data.containsKey(RmprNote.dataKeys['toDoItems']) ||
			data[RmprNote.dataKeys['toDoItems']] is! List) {
			data[RmprNote.dataKeys['toDoItems']!] = <ToDo>[];
		} else if (data[RmprNote.dataKeys['toDoItems']] is! List<ToDo>) {
			// ignore: avoid_print
			print("\n+++++++\nERROR -> An error has occured, toDoItems is List<dynamic> not List<ToDo>\n+++++++");
			data[RmprNote.dataKeys['toDoItems']!] = (data[RmprNote.dataKeys['toDoItems']!] as List).map((item) => item as ToDo).toList();
		}
		return data[RmprNote.dataKeys['toDoItems']];
	}

	set toDoItems(List<ToDo> toDoItems) {
		data[RmprNote.dataKeys['toDoItems']!] = toDoItems;
	}

	/// creates a new ToDo in the list, and returns this note
	RmprNote newToDo(String desc) {
		// toDoItems.add(ToDo(desc: desc, noteName: name, tags: {}));
		toDoItems.add(ToDo(desc: desc, noteName: name, tags: {}));
		return this;
	} // end addToDo

	/// Deletes the given ToDo item from the RmprNote's list of ToDo items.
	RmprNote delToDo(ToDo toDo) {
		// Remove the given ToDo item from the list of ToDo items.
		toDoItems.remove(toDo);
		// Return the current RmprNote object.
		return this;
	}

	String toString() {
		return "<$note>";
	}

	void initSaveTimeline() {
		if (!saveStateTimelines.containsKey("$name:note")) {
			saveStateTimelines["$name:note"] = UndoRedoManager<String>();
		}
	}

} // end RmprNote


