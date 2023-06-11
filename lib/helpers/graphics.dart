import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/classes/theme.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/options.dart';
import 'package:url_launcher/url_launcher_string.dart';


/* ========== HELPERS ========== */
// vars
const Text spacer = Text("");
double paddingW = 0.1; // the percent of horiontal padding on each side
double paddingH = 0.05; // the amount of verticle padding on each side
double paddedW = 0; // the width of the available screen (excluding padding)
double paddedH = 0; // the height of the available screen (excluding padding)
double scale = 1; // not sure

var rBundle = rootBundle;

bool isDark = true;

// Future<void> loadWords() async {
//   String text = await rootBundle.loadString('assets/texts/words.txt');
//   wordList = text.split(" ");
// }

Size getScreenSize(BuildContext context) {
	Size size = MediaQuery.of(context).size;

	double aspectW = 1;
	// double aspectW = 10;
	double aspectH = 1;
	// double aspectH = 16;

	double scaleW = size.width / aspectW;
	double scaleH = size.height / aspectH;

	// ignore: unused_local_variable
	double drawW = scaleW / aspectW;
	// ignore: unused_local_variable
	double drawH = scaleH / aspectH;

	double scale = scaleH * aspectW;
	paddingW = (size.width - scale) / (size.width) / 2;
	if (paddingW < 0.1) {
		paddingW = 0.01;
	}
	// paddingW = 0.01;
	return size;
}

double getPaddingW()
{
	return paddedW;
}

double getPaddingH()
{
	return paddedH;
}

/// Returns a widget for displaying the content of a file located at the given path.
/// The content is displayed using a MarkdownBody widget.
Widget readFileWidget(String path) {
	// Use a FutureBuilder to load the file content asynchronously
	return FutureBuilder(
		// Load the file content as a string
		future: rootBundle.loadString(path),
		// Build the widget once the file content is loaded
		builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
			// If the file content is loaded
			if (snapshot.hasData) {
				// Return a MarkdownBody widget to display the file content
				return MarkdownBody(
					data: snapshot.data ?? "Could not load file",
					onTapLink: (text, url, title) {
						// Launch the URL when a link is tapped
						launchUrlString(url!);
					},
					//textAlign: TextAlign.justify,
				);
			} else {
				// Return a CircularProgressIndicator while the file content is being loaded
				return const CircularProgressIndicator();
			} // if else
		},
	);
} // end readFileWidget


void enterTxtPopup(BuildContext context, String title, Function(String) onConfirm, {String hint = "", String def = ""}) {
	final TextEditingController controller = TextEditingController(text: def);

	showDialog(
		context: context,
		builder: (BuildContext context) {
			return AlertDialog(
				title: Text(title),
				content: TextField(
					decoration: InputDecoration(
						hintText: hint
					),
					controller: controller,
					onChanged: (value) {
						// Handle text change
					},
					keyboardType: TextInputType.multiline,
					maxLines: null,
				),
				actions: <Widget>[
					TextButton(
						child: const Text('Cancel'),
						onPressed: () {
							// Handle cancel
							Navigator.of(context).pop();
						},
					),
					TextButton(
						child: const Text('Confirm'),
						onPressed: () {
							// Handle confirm
							String text = controller.text;
							Navigator.of(context).pop();
							onConfirm(text);
						},
					),
				],
			);
		},
	);
}

void showToDoListsPopup(BuildContext context, State state, Function (String) onConfirm) {

	var column = Column(
		mainAxisSize: MainAxisSize.min,
		children: [
			Row(children: [Expanded(
				child: TextButton(
					style: ButtonStyle(
						side: MaterialStateProperty.all(
							const BorderSide(width: 1, color: Colors.black),
						),
					),
					onPressed: () {
						// ignore: invalid_use_of_protected_member
						state.setState(() {
							onConfirm("=ALL=");
						});
						// setToDoNote(name);
						Navigator.of(context).pop();
					},
					child: const Text("=ALL="),
			))]),

			// for every list
			for (String name in currentFile.notes.keys) Row(children: [Expanded(
				child: TextButton(
					style: ButtonStyle(
						side: MaterialStateProperty.all(
							const BorderSide(width: 1, color: Colors.black),
						),
					),
					onPressed: () {
						// ignore: invalid_use_of_protected_member
						state.setState(() {
							onConfirm(name);
						});
						// setToDoNote(name);
						Navigator.of(context).pop();
					},
					child: Text(name),
			))]),
		],
	);

	showDialog(
		context: context,
		builder: (BuildContext context) {
			return AlertDialog(
				title: const Text('New Name'),
				content: column,
				actions: <Widget>[
					TextButton(
						child: const Text('Cancel'),
						onPressed: () {
							// Handle cancel
							Navigator.of(context).pop();
						},
					),
				],
			);
		},
	);
}

void dateSelect(BuildContext context, Function(DateTime?) onConfirm) {
	// final controller = TextEditingController();
	DateTime? date;

	showDatePicker(
		context: context, 
		initialDate: DateTime.now(), 
		firstDate: DateTime.now().subtract(const Duration(days: 365 * 1000)),
		lastDate: DateTime.now().add(const Duration(days: 365 * 1000)),
	).then((value) {
		if (value == null) return;
		date = value;
		showTimePicker(
			context: context, 
			initialTime: TimeOfDay.now()
		).then((value) {
			if (value == null) return;
			date = DateTime(date!.year, date!.month, date!.day, value.hour, value.minute);
			onConfirm(date);
		});
	});
}


void confirmPopup(BuildContext context, String title, String question, Function() onConfirm) {

	showDialog(
		context: context,
		builder: (BuildContext context) {
			return AlertDialog(
				title:  Text(title),
				content: MarkdownBody(data: question),
				actions: <Widget>[
					TextButton(
						child: const Text('Cancel'),
						onPressed: () {
							// Handle cancel
							Navigator.of(context).pop();
						},
					),
					TextButton(
						child: const Text('Confirm'),
						onPressed: () {
							// Handle confirm
							onConfirm();
							Navigator.of(context).pop();
						},
					),
				],
			);
		},
	);
}

Row flexible(List<Widget> children) {
	return Row(
		children: [
			for (Widget w in children) Flexible(flex: 1, child: w)
		]
	);
}

Row expand(Widget child) {
	return Row(
		children: [
			Expanded(flex: 1, child: child)
		]
	);
}


void showMainMenu(BuildContext context) {
	Row importExportBtns = Row(children: [
		Expanded(flex: 7, child: StyledOutlinedButton(
			onPressed: () {
				// newToDoNote();
				// Navigator.pushNamed(context, '/').whenComplete(() => setState(() {}));
				// importToDoLists().then((value) => setState(() {saveToDoNotes();})); //TODO
			},
			child: const Text("Import (in dev)"),
		)),
		const Expanded(flex: 1, child: SizedBox()),
		Expanded(flex: 7, child: StyledOutlinedButton(
			onPressed: () {
				// newToDoNote();
				// Navigator.pushNamed(context, '/').whenComplete(() => setState(() {}));
				// exportToDoLists(); //TODO
			},
			child: const Text("Export (in dev)"),
		)),
	]);

	var aboutBtn = StyledOutlinedButton(
		onPressed: () {
			Navigator.pushNamed(context, pageRoute['about']!);
		},
		child: const Text("About $title"),
	);
	
	Column buttons = Column(
		mainAxisSize: MainAxisSize.min,
		children: [
			StyledOutlinedButton(
				child: const Text('Options'),
				onPressed: () => Navigator.popAndPushNamed(context, pageRoute['options']!),
			),
			spacer,
			importExportBtns,
			spacer,
			aboutBtn,
		],
	);
	
	showDialog(
		context: context,
		builder: (BuildContext context) {
			return AlertDialog(
				title:  const Text('Menu'),
				content: buttons,
				actions: <Widget>[
					TextButton(
						child: const Text('Cancel'),
						onPressed: () {
							// Handle cancel
							Navigator.of(context).pop();
						},
					),
				],
			);
		},
	);
}

StyledOutlinedButton noteButton({required BuildContext context, required RmprNote note, required VoidCallback onPressed, required VoidCallback optFunc}) {
	Column col = Column(
			children: [
				Text(note.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
				// const Text("--- --- ---"), // uncomment to add aditional space
				Divider(color: Theme.of(context).colorScheme.primary),
				Text(note.note.isEmpty? "---" : note.note, textAlign: TextAlign.center,),
				// Text(note.toDoItems.toString(), textAlign: TextAlign.center,),
				Row(children: [
					Expanded(child: Align(
						alignment: Alignment.centerLeft,
						child: Text("  ${note.toDoItems.length} items", style: const TextStyle(fontWeight: FontWeight.bold),),
					)),
					Expanded(child: Align(
						alignment: Alignment.centerRight,
						child: Material(child: IconButton(onPressed: optFunc, icon: const Icon(Icons.settings))),
					))
				]),
			],
		);
	return StyledOutlinedButton(onPressed: onPressed, child: col,);
}