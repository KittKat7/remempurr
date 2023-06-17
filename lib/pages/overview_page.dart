import 'package:flutter/material.dart';
import 'package:remempurr/classes/theme.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/options.dart';

/* ========== HOME PAGE ========== */
class OverviewPage extends StatefulWidget {
	const OverviewPage({super.key, required this.title});

	final String title;
	@override
	State<OverviewPage> createState() => _OverviewPageState();
} // end HomePage

class _OverviewPageState extends State<OverviewPage> with WidgetsBindingObserver {
	
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

	// @override
	// void didChangeAppLifecycleState(AppLifecycleState state) {
	// 	if (state == AppLifecycleState.paused) {
	// 		closeBox();
	// 	}
	// }
	
	
	@override
	Widget build(BuildContext context) {
		// if (!themeInit) {
		// 	setState (() => getColorTheme(context).setColor(null));
		// }
		
		/// Generates a list of widgets for displaying to-do note buttons.
		/// Each to-do button is displayed as a row with two buttons: one for viewing the note and one for
		/// deleting the note.
		List<Widget> noteButtons() {
			// Create an empty list to store the widgets
			List<Widget> widgets = [];

			// Iterate over the to-do notes
			
			void confirmDel(String name) {
				// Delete the selected note
				confirmPopup(
					context, 
					"Confirm Delete",
					"Pressing \"Confirm\" will **permanently** delete  \n\"$name\"",
					() => setState(() => delRmprNote(name) )
				);
				// Navigate to the '/' route
				// Navigator.pushReplacementNamed(context, '/');
			}

			List<Widget> noteBtns = [];
			List<Widget> leftList = [];
			List<Widget> rightList = [];
			// Column leftCol;
			// Column rightCol;


			for (String name in currentFile.notes.keys) {
				
				// Create a button for viewing the note
				var button = noteButton(
					context: context,
					onPressed: () {
						// Set the currentNote to the selected note
						currentName = name;
						// Navigate to the pageRoute['about'] route
						Navigator.pushNamed(context, pageRoute['note']!).whenComplete(() => setState(() {}));
					},
					note: getRmprNote(name)!,
					timelineFunction: () {
						// Set the currentNote to the selected note
						currentName = name;
						// Navigate to the pageRoute['about'] route
						Navigator.pushNamed(context, pageRoute['timeline']!).whenComplete(() => setState(() {}));
					},
					optionsFunction: () => confirmDel(name),
					// child: Text(
					// 	name == getRmprNote(name)!.name?
					// 		name : "$name - ${getRmprNote(name)!.name}"
					// ),
				);
				//TODO
				
				// var layout = LayoutBuilder(
				// 	builder: (BuildContext context, BoxConstraints constraints) {
				// 		final double width = constraints.maxWidth;
				// 		final double height = constraints.maxHeight;

				// 		// Use the width and height values to determine the size or layout of your widget

				// 		return Container(
				// 			// Widget content...
				// 		);
				// 	},
				// );

				if (rightList.length >= leftList.length) {
					leftList.add(button);
				} else {
					rightList.add(button);
				}

				// if (noteBtns.length < 2) {
				// 	noteBtns.add(button);
				// }

				// if (noteBtns.length >= 2) {
				// 	widgets.addAll([
				// 		Row(children: <Widget>[
				// 			Expanded(flex: 5, child: noteBtns[0]),
				// 			const Expanded(flex: 1, child: SizedBox()),
				// 			Expanded(flex: 5, child: noteBtns[1]),
				// 		]),
				// 		spacer,
				// 	]);
				// 	noteBtns = [];
				// }



				// Create a button for deleting the note
				// var delButton = GlowButton(
				// 	onTap: () => confirmDel(name),
				// 	child: const Icon(Icons.delete, size: 16),
				// );
				// Add the buttons to the widgets list
				// widgets.addAll([
				// 	Row(children: <Widget>[
				// 		Expanded(flex: 10, child: button),
				// 		const Expanded(flex: 1, child: SizedBox()),
				// 		// Expanded(flex: 4, child: delButton),
				// 	]),
				// 	spacer,
				// ]);
				noteBtns.add(button);
			} // end for

			// leftCol = Column(children: [for (var item in leftList) item]);
			// rightCol = Column(children: [for (var item in rightList) item]);
			List<Widget> tmpCol = [];
			for (var item in noteBtns) {
				tmpCol.add(item);
				tmpCol.add(spacer);
			}
			widgets.add(
				Column(children: tmpCol)
				// Row(children: [
				// 	Expanded(flex: 5, child: leftCol),
				// 	const Expanded(flex: 1, child: SizedBox()),
				// 	Expanded(flex: 5, child: rightCol)
				// ],)
			);
			
			// if (noteBtns.isNotEmpty) {
			// 	widgets.addAll([
			// 		Row(children: <Widget>[
			// 			Expanded(flex: 5, child: noteBtns[0]),
			// 			const Expanded(flex: 6, child: SizedBox()),
			// 		]),
			// 		spacer,
			// 	]);
			// 	noteBtns = [];
			// }

			// Return the list of widgets
			return widgets;
		} // end todoButtons

		IconButton menuBtn = IconButton(
			onPressed: () => showMainMenu(context),
			icon: const Icon(Icons.menu)
		);

		// This method is rerun every time setState is called, 
		var appBar = AppBar(
			centerTitle: true,
			title: GestureDetector(
				onTap: () { getColorTheme(context).setColorCyan(); saveOptions();},
				child: const Text("Remempurr: $version"),
			),
			// remove the back button
			automaticallyImplyLeading: false,
			// add menu btn
			leading: menuBtn
			// actions: [ if (currentName != keyAll) rmprNoteSettingsBtn,/*if (currentName != keyAll) newToDoBtn,*/ ],
		);
		
		const headerTxt = Text(
			title,
			textScaleFactor: 3,
			style: TextStyle(fontWeight: FontWeight.bold),
		);
		
		// show all button
		var showAll = [expand(StyledOutlinedButton(
			onPressed: () {
				currentName = keyAll;
				Navigator.pushNamed(context, pageRoute['note']!).whenComplete(() => setState(() {}));
			},
			child: const Text("=ALL=", style: TextStyle(fontWeight: FontWeight.bold),),
		)),spacer];
		
		// about page button
		
		
		// display the buttons
		List<Widget> buttonWidgets = [
			// add option button
			// Row(children: <Widget>[
			// 	Expanded(flex: 5, child: optionsBtn),
			// ]),
			// spacer,
			// add about
			// importExportBtns,
			// spacer,
			// Row(children: <Widget>[
			// 	Expanded(flex: 5, child: aboutBtn),
			// ])
		];
		
		// This function creates and returns a Column widget
		Column column() {
			// Return a Column widget containing the list of widgets and the buttonWidgets
			return Column( children: showAll + noteButtons() + buttonWidgets );
		} // end column


		// return the page display
		return Scaffold(
			appBar: appBar,
			body: PaddedScroll(
				context: context,
				alignment: Alignment.center,
					children: <Widget>[
					headerTxt,
					spacer,
					const Text(""), // sub heading text
					spacer,
					column(),
				]
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					enterTxtPopup(context, title, (p0) {
						RmprNote tmp = newRmprNote(p0);
						currentName = tmp.name;
						// setState(() => renameToDoList(getCurrentToDoName(), p0));
						Navigator.pushNamed(context, pageRoute['note']!).whenComplete(() => setState(() {}));
					}, hint: "To-Do Name");
					
					// setState(() { newToDoNote(); });
				},
				child: const Icon(Icons.add),
			),

		);
	} // end build
} // end _HomePageState
