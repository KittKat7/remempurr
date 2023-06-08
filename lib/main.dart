import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remempurr/classes/theme.dart';
// custom
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/pages/note_page.dart';
import 'package:remempurr/pages/helper_pages.dart';
import 'package:remempurr/options.dart';
import 'package:remempurr/pages/overview_page.dart';

Future<void> main(List<String> args) async {
	WidgetsFlutterBinding.ensureInitialized();
	// await loadOptions();
  await initHive();
	if (!hasError) {
		loadToDoNotes();
	}
	runApp(ChangeNotifierProvider<ThemeModel>(
			create: (context) => ThemeModel(),
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
		Provider.of<ThemeModel>(context).updateTheme();
		return MaterialApp(
			title: 'Remempurr',
			//theme: Provider.of<ThemeModel>(context).currentTheme,
			// theme: Provider.of<ThemeModel>(context).currentTheme,
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   /* light theme settings */
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),
			theme: Provider.of<ThemeModel>(context).lightTheme,
			darkTheme: Provider.of<ThemeModel>(context).darkTheme,
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
        ThemeMode.light for light theme,
        ThemeMode.dark for dark theme */

			initialRoute: hasError ? errorPageRoute : overviewPageRoute,
			routes: {
				overviewPageRoute: (context) => const OverviewPage(title: title),
        notePageRoute: (context) => const NotePage(title: "$title - ToDo"),
				aboutPageRoute: (context) => const AboutPage(title: "$title - About"),
				helpPageRoute: (context) => const HelpPage(title: "$title - Help"),
				errorPageRoute: (context) => const ErrorPage(title: "$title - ERROR")
				// '/options':(context) => const OptionsPage(title: "$title - Options"),
			},
		);
	} // end build
} // end MyApp


