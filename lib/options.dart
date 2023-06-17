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

bool isTimeline = false;

bool waitingToSave = false;
Map<String, UndoRedoManager> saveStateTimelines = {};

String currentLang = 'en_us';

List<String> availableLangs = List.from(langs.keys);
Lang lang = Lang(lang: 'en_us');
Lang usLang = Lang(lang: 'en_us');

getLang(String k,[List p = const []])=>lang.contains(k)? lang.getLang(k, p) : usLang.getLang(k, p);

const String keyAll = "=ALL=";
const String due = "due";
const String comp = "done";


/* ======= Theme ======= */
// Save the value to shared preferences
Future<void> saveOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.setBool("isTimeline", isTimeline);
	prefs.setInt("themeColor", themeColorList.indexOf(themeColor));
	prefs.setString('language', currentLang);
} // end saveOptions

// Load the value from shared preferences
Future<void> loadOptions() async {
	try {
		final prefs = await SharedPreferences.getInstance();
		isTimeline = prefs.getBool("isTimeline") == null ? false : prefs.getBool("isTimeline")!;
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
	themeColor = Colors.red;
	currentLang = 'en_us';
	saveOptions();
} // end loadDefaults

Future<void> resetOptions() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.clear();
	loadDefaults();
} // end resetOptions



