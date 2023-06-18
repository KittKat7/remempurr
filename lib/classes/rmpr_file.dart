import 'package:hive_flutter/hive_flutter.dart';
import 'package:remempurr/classes/rmpr_note.dart';

part 'adapters/rmpr_file.g.dart';

/// A class representing a RmprFile object that extends HiveObject.
/// 
/// This class has a HiveType annotation with a typeId of 0.
@HiveType(typeId: 0)
class RmprFile extends HiveObject {
	
	/// The name of the RmprFile.
	@HiveField(0)
	String name;

	/// The path of the RmprFile.
	@HiveField(1)
	String path;

	/// A list of ToDoNote objects associated with the RmprFile.
	@HiveField(2)
	Map<String, RmprNote> notes;

	/// A map of tags associated with the RmprFile.
	@HiveField(3)
	Map<String, String> tags;

	/// Creates a new RmprFile object with the given name, path, notes, and tags.
	RmprFile({required this.name, required this.path, required this.notes, required this.tags});

} // end RmprFile