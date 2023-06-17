import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/options.dart';

part 'to_do.g.dart';

/// A class representing a ToDo object that extends HiveObject.
/// 
/// This class has a HiveType annotation with a typeId of 2.
@HiveType(typeId: 2)
class ToDo extends HiveObject implements Comparable{
	/// The description of the ToDo item.
	@HiveField(0)
	String desc;

	/// The name of the note associated with the ToDo item.
	@HiveField(1)
	String noteName;

	/// A map of tags associated with the ToDo item.
	///
	/// The tags can include dueDate, completed, and repeat information.
	@HiveField(2)
	Map<String, String> tags;	

	/// Creates a new ToDo object with the given description, noteName, and tags.
	ToDo({required this.desc, required this.noteName, required this.tags});

	/// Returns a clone of the current ToDo object.
	ToDo clone() {
		return ToDo(
			desc: desc,
			noteName: noteName,
			tags: tags,
		);
	} // end clone

	/// Sets the due date for this ToDo item.
	///
	/// If [date] is `null`, the due date is cleared.
	/// Otherwise, the due date is set to the given [date].
	///
	/// Returns this [ToDo] instance.
	ToDo setDueDate(DateTime? date) {
		if (date == null) {
			tags[due] = "";
		} else {
			tags[due] = date.toIso8601String();
		}
		return this;
	} // end setDueDate

	/// Clears the due date for this ToDo item.
	///
	/// Returns this [ToDo] instance.
	ToDo clearDueDate() {
		tags.remove(due);
		return this;
	} // end clearDueDate

	/// Returns the due date of this ToDo item as a string.
	///
	/// If this ToDo item does not have a due date, an empty string is returned.
	String getDueString() {
		if (!isDue()) {
			return "";
		}
		return tags[due]!;
	} // end getDueString

	/// Returns the due date of this ToDo item as a string.
	///
	/// If this ToDo item does not have a due date, an empty string is returned.
	DateTime? getDueDate() {
		return DateTime.tryParse(tags[due]!);
	} // end getDueString

	/// Returns `true` if this ToDo item has a due date, `false` otherwise.
	bool isDue() {
		if (tags.containsKey(due)) {
			return true;
		}
		return false;
	} // end isDue


	/// Sets the completion date for this ToDo item.
	///
	/// If [date] is `null`, the completion date is cleared.
	/// Otherwise, the completion date is set to the given [date].
	///
	/// Returns this [ToDo] instance.
	ToDo setCompDate(DateTime? date) {
		if (date == null) {
			tags[comp] = "";
		} else {
			tags[comp] = date.toIso8601String();
		}
		return this;
	}

	/// Clears the completion date for this ToDo item.
	///
	/// Returns this [ToDo] instance.
	ToDo clearCompDate() {
		tags.remove(comp);
		return this;
	}

	/// Returns whether the ToDo item is complete.
	bool isComplete() {
		// If the tags map does not contain a "done" key, return false.
		if (!tags.containsKey("done")) {
			return false;
		} else {
			// Else, return true.
			return true;
		} // end if else
	} // end isComplete

	DateTime? getCompDate() {
		if (!tags.containsKey(comp)) {
			return null;
		}
		return DateTime.tryParse(tags[comp]!);
	}

	/// Adds or removes a star tag from the ToDo item.
	/// 
	/// [star] - Whether to add or remove the star tag.
	/// 
	/// Returns the updated ToDo item.
	ToDo star(bool star) {
		if (star) {
			// Add a star tag
			tags["star"] = "";
		} else {
			// Remove the star tag
			tags.remove("star");
		} // end if else
		return this;
	} // end star

	/// Checks if the ToDo item has a star tag.
	/// 
	/// Returns true if the ToDo item has a star tag, false otherwise.
	bool isStarred() {
		// Check if the ToDo item has a star tag
		if (tags.containsKey("star")) {
			return true;
		} // end if
		return false;
	} // end hasStar

	@override
	String toString() {
		return desc;
	}

	@override
	int compareTo(other) {
		if (other is! ToDo) {
			return 0;
		}
		// sort by completed, then starred, then is due, then due date, then desc
		if (isComplete() != other.isComplete()) {
			// sort the complete one higher index value (lower on list)
			if (isComplete() && !other.isComplete()) {
				return 1;
			} else {
				return -1;
			}
		} else if (isComplete() && (getCompDate() != other.getCompDate())) {
			// sort by the due date
			return -1 * getCompDate()!.compareTo(other.getCompDate()!);
		} else if (isStarred() != other.isStarred()) {
			// sort the starred one lower index value (higher on list)
			if (isStarred() && !other.isStarred()) {
				return -1;
			} else {
				return 1;
			}
		} else if (isDue() != other.isDue()) {
			// sort the due one lower index value (higher on list)
			if (isDue() && !other.isDue()) {
				return -1;
			} else {
				return 1;
			}
		} else if (isDue() && (getDueDate() != other.getDueDate())) {
			// sort by the due date
			return getDueDate()!.compareTo(other.getDueDate()!);
		} else {
			return desc.compareTo(other.desc);
		}
	}

} // end end ToDo