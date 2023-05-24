import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// custom
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/classes/todolist.dart';
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/helpers/helpers.dart';

class ToDoPage extends StatefulWidget
{
	final String title;
	const ToDoPage({super.key, required this.title});
	
	@override
	State<ToDoPage> createState() => _ToDoPageState();
} // end ToDoPagePage

class _ToDoPageState extends State<ToDoPage>
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

		// new to-do button
		var newToDoBtn = IconButton(
			icon: const Icon(Icons.add),
			onPressed: () {
				getCurrentToDoName() != allToDoList?
					enterTxtPopup(context, "New ToDo", (text) {setState(() => newToDo(text));}, hint: "Something to do") : null;
			},
		);
		
		// set the text for the title
		var titleText = GestureDetector(
			onTap: () {
				// showListPopup();
				showToDoListsPopup(context, this);
				// setState(() => showToDoListsPopup(context, this));
			},
			child: Padding(
				padding: const EdgeInsets.all(15.0),
				child: Text(
					getCurrentToDoName(),
					textAlign: TextAlign.center,
					// style: const TextStyle(fontWeight: FontWeight.bold),
				),
			),
		);

		var todoListSettingsBtn = IconButton(
			icon: const Icon(Icons.settings),
			onPressed: () {
				enterTxtPopup(
					context,
					"Rename",
					(text) {setState(() => renameToDoList(getCurrentToDoName(), text));},
					def: getCurrentToDoName(),
				);
				// setState(() => nextToDoNote());
				//Navigator.pushReplacementNamed(context, '/todo');
			},
		);

		var leftListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_left),
			onPressed: () {
				setState(() => previousToDoNote());
				//Navigator.pushReplacementNamed(context, '/todo');
			},
		);

		var rightListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_right),
			onPressed: () {
				setState(() => nextToDoNote());
				//Navigator.pushReplacementNamed(context, '/todo');
			},
		);
		
		// title row
		var titleRow = Row(
			// mainAxisAlignment: MainAxisAlignment.center,
			mainAxisSize: MainAxisSize.min,
			children: [
				leftListBtn,
				titleText,
				if (getCurrentToDoName() != allToDoList) todoListSettingsBtn,
				rightListBtn,
			],
		);
		
		var children = displayToDoItems(context, this);

		// return the Scaffold
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: titleRow,
				// remove the back button
				automaticallyImplyLeading: false,
				// add menu btn
				leading: menuBtn,
				actions: [ newToDoBtn, ],
			),
			body: PaddedScroll(
				context: context,
				children: children,
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => Navigator.pushNamed(context, "/help"),
				child: const Icon(Icons.help),
			),
		);
	} // end build
} // end _ToDoPageState


List<Widget> displayToDoItems(BuildContext context, State state) {
	// create an empty list, this is what will be returned
	List<Widget> todoItems = [];
	// get the current todolist
	ToDoList todoList = getToDoList(getCurrentToDoName());
	// sort the items
	todoList.sortItems();

	List<ToDo> priority = [];
	List<ToDo> normal = [];
	List<ToDo> completed = [];

	for (ToDo td in todoList.todoItems) {
		if (td.isComplete()) {
			completed.add(td);
		} else if (td.isPriority()) {
			priority.add(td);
		} else {
			normal.add(td);
		}
	}

	Container container(Widget child) {
		return Container(
			margin: EdgeInsets.all(10),
			child: child,
		);
	}

	int check = 0;
	for (ToDo td in todoList.todoItems) {

		if (check < 1 && td.isPriority() && !td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Priority**"))
			);
			check ++;
		} else if (check < 2 && !td.isPriority() && !td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Regular**"))
			);
			check ++;
		} else if (check < 3 && td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Completed**"))
			);
			check ++;
		}

		// checkbox
		var checkbox = Expanded(
			flex: 1,
			child: Checkbox(value: td.isComplete(), onChanged: (bool? value) { 
				// ignore: invalid_use_of_protected_member
				state.setState(() {
					// td.isComplete()? uncomplete(td) : complete(td);
					saveToDoNotes(name: getCurrentToDoName(), note: toggleComplete(td), item: td);
				});
			})
		); 

		// description
		bool toLong = td.desc.length >= 32;
		String shortDescription = toLong? td.desc.substring(0, 29) : td.desc;
		var style = td.isPriority()?
			const TextStyle(fontWeight: FontWeight.bold) : const TextStyle(fontWeight: FontWeight.normal);
		var description = Expanded(
			flex: 5,
			child: GestureDetector(
				onTap: () => enterTxtPopup(
					context, 
					"Change To Do", 
					// ignore: invalid_use_of_protected_member
					(text) {state.setState(() => setDesc(td, text));},
					def: td.getDesc(), 
				),
				child: Text(toLong? "$shortDescription..." : td.desc, style: style)
			)
		);

		var fullDescription = Expanded(
			flex: 14,
			child: GestureDetector(
				onTap: () => enterTxtPopup(
					context, 
					"Change To Do", 
					// ignore: invalid_use_of_protected_member
					(text) {state.setState(() => setDesc(td, text));},
					def: td.getDesc(),
				),
				child: Text(td.desc)
			)
		);

		// dueDate
		bool isLate = td.isDue() && !td.isComplete()?
			DateTime.now().compareTo(td.getDueDate()!) > -1? true : false : false;
		TextStyle dueDateTxtStyle = TextStyle(
			color: isLate? Colors.red : null,
			fontWeight: isLate? FontWeight.bold : null
			);
		String formattedDueDate = td.isDue()? formatDate(td.getDueDate()!) : "";
		var dueDate = Expanded(
			flex: 3, 
			child: GestureDetector(
				onTap: () { 
					dateSelect(
						context, 
						// ignore: invalid_use_of_protected_member
						(p0) => state.setState(() => setDueDate(td, p0))
					);
				},
				onLongPress: () {
				  confirmPopup(
						context, 
						"Remove Due Date", 
						"Pressing \"Confirm\" will remove the due date for  \n\"$shortDescription\"", 
						// ignore: invalid_use_of_protected_member
						() => state.setState(() => setDueDate(td, null))
					);
				},
				child: Text(
					td.isDue()? "Due: $formattedDueDate" : "Due",
					style: dueDateTxtStyle,
				),
		));

		// star button
		var star = Expanded(
			flex: 1,
			child: IconButton(
				onPressed: () { 
				// ignore: invalid_use_of_protected_member
					state.setState(() {
						saveToDoNotes(name: getCurrentToDoName(), note: togglePriority(td), item: td);
					});
				}, icon: Icon(td.isPriority()? Icons.star : Icons.star_border),
				padding: EdgeInsets.zero,
		)); // end star button

		// compDate
		String formattedCompDate = td.isComplete()? formatDate(td.getCompDate()) : "";
		if (formattedCompDate == "null") formattedCompDate = "N/A";
		var compDate = Expanded(
			flex: 3, 
			child: GestureDetector(
				onTap: () { 
					dateSelect(
						context, 
						// ignore: invalid_use_of_protected_member
						(p0) => state.setState(() => setComplete(td, p0))
					);
				},
				onLongPress: () {
				  confirmPopup(
						context, 
						"Remove Completed Date", 
						"Pressing \"Confirm\" will remove the completed date for  \n\"$shortDescription\"", 
						// ignore: invalid_use_of_protected_member
						() => state.setState(() => setComplete(td, null))
					);
				},
				child: Text(
					td.isComplete()? "Done: $formattedCompDate" : "Done"
				),
		));
		
		// delete button
		var delBtn = Expanded(
			flex: 1,
			child: IconButton(
				onPressed: () {
				// ignore: invalid_use_of_protected_member
				confirmPopup(
					context, 
					"Confirm Delete",
					"Pressing \"Confirm\" will **permanently** delete  \n\"$shortDescription\"",
					// ignore: invalid_use_of_protected_member
					() {state.setState(() => deleteToDo(td));}
				);
			}, icon: const Icon(Icons.delete),
			padding: EdgeInsets.zero,
		)); // end delete button




		var row = Row(children: <Widget>[
			checkbox,
			star,
			description,
			// dueDate,
			// compDate,
			delBtn,
		]);

		var column = Container(
			decoration: BoxDecoration(
				border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
				borderRadius: BorderRadius.circular(10),
				color: Theme.of(context).canvasColor,
				boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 5, spreadRadius: 3)]
			),
			margin: EdgeInsets.only(top: 2, bottom: 2),
			child: Container(margin: EdgeInsets.only(top: 2, bottom: 2), child: Column(
				children: [
					row,
					if (toLong) Row(children: [const Expanded(flex: 1, child: SizedBox()), fullDescription]),
					Row(children: [const Expanded(flex: 1, child: SizedBox()), dueDate, compDate,])
				],
			))
		);
		
		todoItems.add(
			column
		);


		


	} // end for


	return todoItems;
} // end displayToDoItems

