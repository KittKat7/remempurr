import 'package:flutter/material.dart';
// custom
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/helpers/todolist.dart';
import 'package:remempurr/helpers/graphics.dart';

class TodoPage extends StatefulWidget
{
	final String title;
	const TodoPage({super.key, required this.title});
	
	@override
	State<TodoPage> createState() => _TodoPageState();
} // end TodoPagePage

class _TodoPageState extends State<TodoPage>
{
	@override
	Widget build(BuildContext context) {
		
		// menu button
		var menuBtn = IconButton(
			icon: const Icon(Icons.menu),
			onPressed: () {
				Navigator.pop(context);
				// Navigator.pushNamed(context, '/menu');
			},
		);
		
		// set the text for the title
		var titleText = GestureDetector(
			onTap: () {
				showPopup(context, (text) {setState(() => renameTodoNote(getCurrentTodoName(), text));});
				// setState(() => todoNames = todoNames);
			},
			child: Padding(
				padding: const EdgeInsets.all(15.0),
				child: Text(
					getCurrentTodoName(),
					textAlign: TextAlign.center,
					// style: const TextStyle(fontWeight: FontWeight.bold),
				),
			),
		);


		// title row
		var titleRow = Row(
			// mainAxisAlignment: MainAxisAlignment.center,
			mainAxisSize: MainAxisSize.min,
			children: [
				IconButton(
					icon: const Icon(Icons.keyboard_arrow_left),
					onPressed: () {
						setState(() => previousTodoNote());
						//Navigator.pushReplacementNamed(context, '/todo');
					},
				),
				titleText,
				IconButton(
					icon: const Icon(Icons.keyboard_arrow_right),
					onPressed: () {
						setState(() => nextTodoNote());
						//Navigator.pushReplacementNamed(context, '/todo');
					},
				),
			],
		);
		
		var children = [const Text("data")];

		// return the Scaffold
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: titleRow,
				// remove the back button
				automaticallyImplyLeading: false,
				// add menu btn
				leading: menuBtn,
			),
			body: PaddedScroll(
				context: context,
				children: children,
			),
		);
	} // end build
} // end _TodoPageState
