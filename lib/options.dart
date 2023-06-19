import 'dart:io';

import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/classes/to_do.dart';
import 'package:remempurr/classes/undo_redo_manager.dart';
import 'package:remempurr/classes/theme.dart';
import 'package:flutter/material.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/lang/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const String title = "Remempurr";
const String filePath = "Documents/Purrductivity/Remempurr/";

const Map<String, String> pageRoute = {
	'overview': '/',
	'note': '/note',
	// 'timeline': '/timeline',
	'about': '/about',
	'help': '/help',
	'error': '/error',
	'options': '/options',
};

const String version = "1.0.0";
const int buildID = 10;

String status = 'Now with lolcat!';

bool isDarkMode = false;
// MaterialColor themeColor = Colors.amber;
// MaterialColor themeColor = Colors.blue;

bool themeInit = false;

bool hasError = false;
String thrownError = "";
bool inPrivate = false;
bool isNotifying = false;

bool isTimeline = false;
enum PlatformTypes { web, desktop, mobile }
enum Platforms { web, windows, linux, macos, android, ios }
PlatformTypes platformType = PlatformTypes.web;
Platforms platform = Platforms.web;

bool waitingToSave = false;
Map<String, UndoRedoManager> saveStateTimelines = {};

String currentLang = 'en_us';

List<String> availableLangs = List.from(langs.keys);
Lang lang = Lang(lang: 'en_us');
Lang usLang = Lang(lang: 'en_us');

getString(String k,[List p = const []])=>lang.contains(k)? lang.getString(k, p) : usLang.getString(k, p);

const String keyAll = "=ALL=";
const String due = "due";
const String comp = "done";


void initialize() {
	if (kIsWeb) {
		platformType = PlatformTypes.web;
		platform = Platforms.web;
	}
	else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
		platformType = PlatformTypes.desktop;
		if (Platform.isWindows) {
			platform = Platforms.windows;
		} else if (Platform.isLinux) {
			platform = Platforms.linux;
		} else if (Platform.isMacOS) {
			platform = Platforms.macos;
		}
	}
	else if (Platform.isAndroid || Platform.isIOS) {
		platformType = PlatformTypes.mobile;
		if (Platform.isAndroid) {
			platform = Platforms.android;
		} else if (Platform.isIOS) {
			platform = Platforms.ios;
		}
	}
}

void checkNotifications() {
	if (!isNotifying) return;
	for (RmprNote note in currentFile.notes.values) {
		for (ToDo td in note.data[RmprNote.dataKeys['toDoItems']]) {
			if (td.isDue() && !td.isComplete()) {
				showNotification('${getString('title')}: ${td.desc}', time: td.getDueDate());
			}
		}
	}
}

/* ======= Theme ======= */
// Save the value to shared preferences
Future<void> saveOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.setBool("isTimeline", isTimeline);
	prefs.setBool("isNotifying", isNotifying);
	prefs.setInt("themeColor", themeColorList.indexOf(themeColor));
	prefs.setString('language', currentLang);
} // end saveOptions

// Load the value from shared preferences
Future<void> loadOptions() async {
	try {
		final prefs = await SharedPreferences.getInstance();
		isTimeline = prefs.getBool("isTimeline") == null ? false : prefs.getBool("isTimeline")!;
		isNotifying = prefs.getBool("isNotifying") == null ? false : prefs.getBool("isNotifying")!;
		int curColor = prefs.getInt("themeColor") == null ? 0 : prefs.getInt("themeColor")!;
		themeColor = themeColorList[curColor];
		currentLang = prefs.getString('language') == null? 'en_us' : prefs.getString('language')!;
		lang.setLang(currentLang);
	} catch (e) {
		loadDefaults();
	}
} // end loadOptions

void loadDefaults() {
	isTimeline = false;
	isNotifying = false;
	themeColor = Colors.red;
	currentLang = 'en_us';
	saveOptions();
} // end loadDefaults

Future<void> resetOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.clear();
	loadDefaults();
} // end resetOptions



