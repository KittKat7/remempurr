import 'dart:async';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


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
	final typeGroup = XTypeGroup(label: 'text', extensions: ['md']);
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