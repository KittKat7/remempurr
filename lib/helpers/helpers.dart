import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:remempurr/classes/todolist.dart';
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
