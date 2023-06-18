import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// custom
// import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/classes/theme.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/options.dart';
// pages
import 'package:remempurr/pages/note_page.dart';
import 'package:remempurr/pages/helper_pages.dart';
import 'package:remempurr/pages/overview_page.dart';
import 'package:remempurr/pages/options_page.dart';

Future<void> main(List<String> args) async {
	WidgetsFlutterBinding.ensureInitialized();
	initialize();
	await loadOptions();
  await initHive();
	if (!hasError) {
		loadToDoNotes();
		checkNotifications();
	}
	runApp(ChangeNotifierProvider<ColorTheme>(
			create: (context) => ColorTheme(),
			child: const MyApp(),
		)
	);
	// runApp(const MyApp());
} // end main

/* ========== MYAPP ========== */
class MyApp extends StatelessWidget {
	const MyApp({super.key});	
	
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		// Provider.of<ColorTheme>(context).updateTheme();
		// getColorTheme(context).setColor(null);
		return MaterialApp(
			title: title,
			theme: Provider.of<ColorTheme>(context).lightTheme,
			darkTheme: Provider.of<ColorTheme>(context).darkTheme,
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
        ThemeMode.light for light theme,
        ThemeMode.dark for dark theme */

			initialRoute: hasError ? pageRoute['error'] : pageRoute['overview'],
			routes: {
				pageRoute['overview']!: (context) => const OverviewPage(title: title),
        pageRoute['note']!: (context) => const NotePage(title: "$title - ToDo"),
				pageRoute['about']!: (context) => const AboutPage(title: "$title - About"),
				pageRoute['help']!: (context) => const HelpPage(title: "$title - Help"),
				pageRoute['error']!: (context) => const ErrorPage(title: "$title - ERROR"),
				pageRoute['options']!:(context) => const OptionsPage(title: "$title - Options"),
			},
		);
	} // end build
} // end MyApp


