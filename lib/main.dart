import 'package:flutter/material.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/helpers/todolist.dart';
import 'package:remempurr/pages/todo_page.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/options.dart';

Future<void> main(List<String> args) async {
	WidgetsFlutterBinding.ensureInitialized();
	await loadOptions();
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

class _HomePageState extends State<HomePage> {
	
	@override
	void initState() {
		super.initState();
	}
	
	
	@override
	Widget build(BuildContext context) {
		/// Generates a list of widgets for displaying todo note buttons.
		/// Each todo button is displayed as a row with two buttons: one for viewing the note and one for
		/// deleting the note.
		List<Widget> todoButtons() {
			// Create an empty list to store the widgets
			List<Widget> widgets = [];
			// Iterate over the todo notes
			for (int i = 0; i < todoNames.length; i++) {
				// Create a button for viewing the note
				var button = ElevatedButton(
					onPressed: () {
						// Set the currentNote to the selected note
						setTodoNote(todoNames[i]);
						// Navigate to the '/about' route
						Navigator.pushNamed(context, '/todo').whenComplete(() => setState(() {}));
					},
					child: Text(todoNames[i]),
				);
				// Create a button for deleting the note
				var rmButton = ElevatedButton(
					onPressed: () {
						// Delete the selected note
						setState(() { deleteTodo(todoNames[i]); });
						// Navigate to the '/' route
						// Navigator.pushReplacementNamed(context, '/');
					},
					child: const Icon(Icons.delete, size: 16),
				);
				// Add the buttons to the widgets list
				widgets.addAll([
					Row(children: <Widget>[
						Expanded(flex: 10, child: button),
						const Expanded(flex: 2, child: SizedBox()),
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
					todoNoteIndex = -1;
					Navigator.pushNamed(context, '/todo').whenComplete(() => setState(() {}));
				},
				child: const Text("=ALL="),
			)),
			const Expanded(flex: 6, child: SizedBox()),
		]),spacer];

    // create a timeline button
		var timelineBtn = ElevatedButton(
			onPressed: () {
				// TODO
				// Navigator.pushNamed(context, '/todo');
			},
			child: const Text("Timeline"),
		);
		// create a new todo button
		var newTodoBtn = ElevatedButton(
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
			// add new todo button
			Row(children: <Widget>[
				Expanded(flex: 5, child: newTodoBtn),
			]),
			spacer,
			// add option button
			// Row(children: <Widget>[
			// 	Expanded(flex: 5, child: optionsBtn),
			// ]),
			// spacer,
			// add about
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
		);
	} // end build
} // end _HomePageState

/* ========== ABOUT PAGE ==========*/
/* ABOUT PAGE */
class AboutPage extends StatefulWidget {
	const AboutPage({super.key, required this.title});
	final String title;
	@override
	State<AboutPage> createState() => _AboutPageState();
} // and AboutPage

class _AboutPageState extends State<AboutPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				context: context,
				children: children(context),
			)
		);
	}

	List<Widget> children(BuildContext context) {
		return <Widget>[
			Text(
				widget.title,
				textAlign: TextAlign.center,
				textScaleFactor: 2,
				style: const TextStyle(fontWeight: FontWeight.bold),
			),
			// main about
			readFileWidget('assets/texts/about.md'),
			// spacer
			spacer,
			// back button
			GoBackButton(context: context),
		];
	} // end build
} // end _AboutPageState


/* ========== ERROR PAGE ==========*/
/* ABOUT PAGE */
class ErrorPage extends StatefulWidget {
	const ErrorPage({super.key, required this.title});
	final String title;
	@override
	State<ErrorPage> createState() => _ErrorPageState();
} // and AboutPage

class _ErrorPageState extends State<ErrorPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				context: context,
				children: children(context),
			)
		);
	}

	List<Widget> children(BuildContext context) {
		return <Widget>[
			Text(
				widget.title,
				textAlign: TextAlign.center,
				textScaleFactor: 2,
				style: const TextStyle(fontWeight: FontWeight.bold),
			),
			// main about
			Text("An Error has occured\n$thrownError"),
			// spacer
			spacer,
			// back button
			GoBackButton(context: context),
		];
	} // end build
} // end _AboutPageState


