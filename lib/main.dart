import 'package:flutter/material.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/classes/todolist.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/pages/todo_page.dart';
import 'package:remempurr/pages/helper_pages.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/options.dart';

Future<void> main(List<String> args) async {
	WidgetsFlutterBinding.ensureInitialized();
	// await loadOptions();
  await initHive();
	if (!hasError) {
		loadTodoNotes();
	}
	// runApp(ChangeNotifierProvider<ThemeModel>(
	// 		create: (context) => ThemeModel(),
	// 		child: const MyApp(),
	// 	)
	// );
	runApp(const MyApp());
} // end main

/* ========== MYAPP ========== */
class MyApp extends StatelessWidget {
	const MyApp({super.key});	
	
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		// Provider.of<ThemeModel>(context).updateTheme();
		return MaterialApp(
			// title: 'Remempurr',
			//theme: Provider.of<ThemeModel>(context).currentTheme,
			// theme: Provider.of<ThemeModel>(context).currentTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
        ThemeMode.light for light theme,
        ThemeMode.dark for dark theme */

			initialRoute: hasError ? '/error' : '/',
			routes: {
				'/': (context) => const HomePage(title: title),
				// '/menu': (context) => const HomePage(title: title),
        '/todo': (context) => const TodoPage(title: "$title - Todo"),
				'/about': (context) => const AboutPage(title: "$title - About"),
				'/help': (context) => const HelpPage(title: "$title - Help"),
				'/error': (context) => const ErrorPage(title: "$title - ERROR")
				// '/options':(context) => const OptionsPage(title: "$title - Options"),
			},
		);
	} // end build
} // end MyApp

/* ========== HOME PAGE ========== */
class HomePage extends StatefulWidget {
	const HomePage({super.key, required this.title});

	final String title;
	@override
	State<HomePage> createState() => _HomePageState();
} // end HomePage

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
	
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
	}

	@override
	void dispose() {
		WidgetsBinding.instance.removeObserver(this);
		super.dispose();
	}

	@override
	void didChangeAppLifecycleState(AppLifecycleState state) {
		if (state == AppLifecycleState.paused) {
			closeBox();
		}
	}
	
	
	@override
	Widget build(BuildContext context) {
		/// Generates a list of widgets for displaying to-do note buttons.
		/// Each to-do button is displayed as a row with two buttons: one for viewing the note and one for
		/// deleting the note.
		List<Widget> todoButtons() {
			// Create an empty list to store the widgets
			List<Widget> widgets = [];
			// Iterate over the to-do notes
			for (int i = 1; i < todoNames.length; i++) {
				// Create a button for viewing the note
				var button = ElevatedButton(
					onPressed: () {
						// Set the currentNote to the selected note
						setTodoNote(todoNames[i]);
						// Navigate to the '/about' route
						Navigator.pushNamed(context, '/todo').whenComplete(() => setState(() {}));
					},
					child: Text(
						todoNames[i] == getTodoList(todoNames[i]).name?
							todoNames[i] : "${todoNames[i]} - ${getTodoList(todoNames[i]).name}"
					),
				);
				// Create a button for deleting the note
				var rmButton = ElevatedButton(
					onPressed: () {
						// Delete the selected note
						confirmPopup(
							context, 
							"Confirm Delete",
							"Pressing \"Confirm\" will **permanently** delete  \n\"${todoNames[i]}\"",
							() => setState(() => deleteTodoNote(todoNames[i]) )
						);
						// Navigate to the '/' route
						// Navigator.pushReplacementNamed(context, '/');
					},
					child: const Icon(Icons.delete, size: 16),
				);
				// Add the buttons to the widgets list
				widgets.addAll([
					Row(children: <Widget>[
						Expanded(flex: 10, child: button),
						const Expanded(flex: 1, child: SizedBox()),
						Expanded(flex: 4, child: rmButton),
					]),
					spacer,
				]);
			} // end for
			// Return the list of widgets
			return widgets;
		} // end todoButtons

		// This method is rerun every time setState is called, 
		var appBar = AppBar(
			// Here we take the value from the MyHomePage object that was created by
			// the App.build method, and use it to set our appbar title.
			// also add secret cyan color
			title: Text(widget.title),
			// title: GestureDetector(
			// 	onTap: () { Provider.of<ThemeModel>(context,listen: false).setColorCyan(); saveOptions(); },
			// 	child: Text(widget.title)
			// )
		);
		// header text
		const headerTxt = Text(
			title,
			textScaleFactor: 3,
			style: TextStyle(fontWeight: FontWeight.bold),
		);
		
		// show all button
		var showAll = [Row(children: <Widget>[
			Expanded(flex: 10, child: 
				ElevatedButton(
				onPressed: () {
					todoNoteIndex = 0;
					Navigator.pushNamed(context, '/todo').whenComplete(() => setState(() {}));
				},
				child: const Text("=ALL="),
			)),
			const Expanded(flex: 5, child: SizedBox()),
		]),spacer];

    // create a timeline button
		var timelineBtn = ElevatedButton(
			onPressed: () {
				// TODO
				// Navigator.pushNamed(context, '/todo');
				saveTodoNotes();
			},
			child: const Text("Timeline (not implemented yet)"),
		);
		// create a new to-do button
		var newTodoNoteBtn = ElevatedButton(
			onPressed: () {
				newTodoNote();
				Navigator.pushNamed(context, '/todo').whenComplete(() => setState(() {}));
				// setState(() { newTodoNote(); });
			},
			child: const Text("New Todo Note"),
		);
		
		// options page button
		// var optionsBtn = ElevatedButton(
		// 	onPressed: () {
		// 		Navigator.pushNamed(context, '/options');
		// 	},
		// 	child: const Text("App Settings"),
		// );

		var importExportBtns = Row(children: [
			Expanded(flex: 7, child: ElevatedButton(
				onPressed: () {
					// newTodoNote();
					// Navigator.pushNamed(context, '/').whenComplete(() => setState(() {}));
					print("\n${parseToString()}");
				},
				child: const Text("Import (WIP)"),
			)),
			const Expanded(flex: 1, child: SizedBox()),
			Expanded(flex: 7, child: ElevatedButton(
				onPressed: () {
					// newTodoNote();
					// Navigator.pushNamed(context, '/').whenComplete(() => setState(() {}));
					exportTodoLists();
				},
				child: const Text("Export (WIP)"),
			)),
		]);
		
		// about page button
		var aboutBtn = ElevatedButton(
			onPressed: () {
				Navigator.pushNamed(context, '/about');
			},
			child: const Text("About $title"),
		);
		
		// display the buttons
		List<Widget> buttonWidgets = [
      // add timeline button
      Row(children: <Widget>[
				Expanded(flex: 5, child: timelineBtn),
			]),
			spacer,
			// add new to-do button
			Row(children: <Widget>[
				Expanded(flex: 5, child: newTodoNoteBtn),
			]),
			spacer,
			// add option button
			// Row(children: <Widget>[
			// 	Expanded(flex: 5, child: optionsBtn),
			// ]),
			// spacer,
			// add about
			importExportBtns,
			spacer,
			Row(children: <Widget>[
				Expanded(flex: 5, child: aboutBtn),
			])
		];
		
		// This function creates and returns a Column widget
		Column column() {
			// Return a Column widget containing the list of widgets and the buttonWidgets
			return Column( children: showAll + todoButtons() + buttonWidgets );
		} // end column

		// return the page display
		return Scaffold(
			appBar: appBar,
			body: PaddedScroll(
				context: context,
				children: <Widget>[
				headerTxt,
				spacer,
				const Text(""), // sub heading text
				spacer,
				column(),
			]),
			floatingActionButton: FloatingActionButton(
				onPressed: () => Navigator.pushNamed(context, "/help"),
				child: const Icon(Icons.help),
			),
		);
	} // end build
} // end _HomePageState

