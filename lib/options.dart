import 'package:remempurr/classes/undo_redo_manager.dart';
import 'package:remempurr/classes/theme.dart';
import 'package:flutter/material.dart';
import 'package:remempurr/lang/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

const String version = "0.0.1";
const int buildID = 1;

bool isDarkMode = false;
// MaterialColor themeColor = Colors.amber;
// MaterialColor themeColor = Colors.blue;

bool themeInit = false;

bool hasError = false;
String thrownError = "";
bool inPrivate = false;

bool isTimeline = false;

bool waitingToSave = false;
Map<String, UndoRedoManager> saveStateTimelines = {};

Lang lang = Lang(lang: 'en_us');

getLang(String k, {List params = const [],}) => lang.getLang(k, params: params);


const String keyAll = "=ALL=";
const String due = "due";
const String comp = "done";


/* ======= Theme ======= */
// Save the value to shared preferences
Future<void> saveOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.setBool("isTimeline", isTimeline);
	prefs.setInt("themeColor", themeColorList.indexOf(themeColor));
} // end saveOptions

// Load the value from shared preferences
Future<void> loadOptions() async {
	try {
		final prefs = await SharedPreferences.getInstance();
		isTimeline = prefs.getBool("isTimeline") == null ? false : prefs.getBool("isTimeline")!;
		int curColor = prefs.getInt("themeColor") == null ? 0 : prefs.getInt("themeColor")!;
		themeColor = themeColorList[curColor];
	} catch (e) {
		loadDefaults();
	}
} // end loadOptions

void loadDefaults() {
	isTimeline = false;
	themeColor = Colors.red;
	saveOptions();
} // end loadDefaults

Future<void> resetOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.clear();
	loadDefaults();
} // end resetOptions



