import 'package:remempurr/options.dart';
import 'package:flutter/material.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/classes/theme.dart';

// Define a StatefulWidget called OptionsPage
class OptionsPage extends StatefulWidget {
	// Declare a final String variable called title
	final String title;
	
	// Define a constructor for OptionsPage that takes in a required title parameter
	const OptionsPage({super.key, required this.title});
	
	// Override the createState method to return an instance of _OptionsPageState
	@override
	State<OptionsPage> createState() => _OptionsPageState();
} // end OptionsPage

// Define a class called _OptionsPageState that extends State<OptionsPage>
class _OptionsPageState extends State<OptionsPage> {
	// Override the build method to define the widget tree for this stateful widget
	@override
	Widget build(BuildContext context) {
		// Define an ElevatedButton called cycleColorBtn that calls cycleColor on the ThemeModel when pressed
		var cycleColorBtn = ElevatedButton(
			onPressed: () {
				getColorTheme(context).cycleColor();
				saveOptions();
			},
			child: const Text("Cycle Color"),
		);
		
		// Define an ElevatedButton called resetBtn that calls resetOptions and toggleMode on the ThemeModel when pressed
		var resetBtn = ElevatedButton(
			onPressed: () {
				resetOptions().then((value) => getColorTheme(context).setColor(null));
				// Provider.of<ThemeModel>(context, listen: false).toggleMode();
				// saveOptions();
				// used with universal html import, refresh app hopefuly?
				// html.window.location.reload();
			},
			child: const Text("Reset"),
		);
		
		// Define a Text widget called titleText that displays the title passed into OptionsPage
		var titleText = Text(
			widget.title,
			textAlign: TextAlign.center,
			textScaleFactor: 2,
			style: const TextStyle(fontWeight: FontWeight.bold),
		);
		
		// Define a Row called row1 that contains cycleColorBtn and toggleModeBtn with some space in between
		var row1 = Row(
			children: [
				Expanded(flex: 7, child: cycleColorBtn),
				// const Expanded(flex: 1, child: SizedBox()),
			],
		);
		
		// Define a Row called row2 that contains resetBtn and some empty space
		var row2 = Row(
			children: [
				Expanded(flex: 7, child: resetBtn),
				const Expanded(flex: 1, child: SizedBox()),
				const Expanded(flex: 7, child: SizedBox()),
			],
		);
		
		// Define a list of Widgets called children that contains all the widgets to be displayed on this page
		var children = <Widget>[
			titleText,
			readFileWidget('assets/texts/options.md'),
			spacer,
			row1,
			spacer,
			row2,
			spacer,
			GoBackButton(context: context),
		];
		
		// Return a Scaffold with an AppBar and a body containing all the children widgets wrapped in a PaddedScroll widget
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				context: context,
				children: children,
			),
		);
	}
} // end _OptionsPageState

