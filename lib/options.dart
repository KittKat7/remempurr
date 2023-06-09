import 'package:remempurr/classes/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String title = "Remempurr";
const String filePath = "Documents/Purrductivity/Remempurr/";

const Map<String, String> pageRoute = {
	'overview': '/',
	'note': '/note',
	'about': '/about',
	'help': '/help',
	'error': '/error',
	'options': '/options',
};

const String version = "0.0.1";
const int buildID = 1;

bool isDarkMode = false;
// MaterialColor themeColor = Colors.amber;
MaterialColor themeColor = Colors.blue;

bool hasError = false;
String thrownError = "";
bool inPrivate = false;

// unused theming code
/* ======= Theme ======= */
// Save the value to shared preferences
Future<void> saveOptions() async
{
	final prefs = await SharedPreferences.getInstance();
	// prefs.setBool("isDarkMode", isDarkMode);
	prefs.setInt("themeColor", themeColorList.indexOf(themeColor));
} // end saveOptions

// Load the value from shared preferences
Future<void> loadOptions() async
{
	final prefs = await SharedPreferences.getInstance();
	// isDarkMode = prefs.getBool("isDarkMode") == null ? false : prefs.getBool("isDarkMode")!;
	int curColor = prefs.getInt("themeColor") == null ? 0 : prefs.getInt("themeColor")!;
	themeColor = themeColorList[curColor];
} // end loadOptions

void loadDefaults()
{
	// isDarkMode = false;
	themeColor = Colors.red;
} // end loadDefaults

Future<void> resetOptions() async
{
	final prefs = await SharedPreferences.getInstance();
	prefs.clear();
	loadDefaults();
} // end resetOptions



