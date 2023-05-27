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
				getCurrentList() != keyAll?
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
					getCurrentList(),
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
					(text) {setState(() => renameToDoList(getCurrentList(), text));},
					def: getCurrentList(),
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
				if (getCurrentList() != keyAll) todoListSettingsBtn,
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
				actions: [ if (getCurrentList() != keyAll) newToDoBtn, ],
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
	ToDoList toDoList = getToDoList(getCurrentList());
	// sort the items
	toDoList.sortItems();

	List<ToDo> priority = [];
	List<ToDo> normal = [];
	List<ToDo> completed = [];

	for (ToDo td in toDoList.todoItems) {
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
			margin: const EdgeInsets.all(10),
			child: child,
		);
	}

	if (toDoList.desc.isNotEmpty) {
		todoItems.add(
				container(const MarkdownBody(data: "## **Note**"))
			);
		todoItems.add(
			container(MarkdownBody(data: "${toDoList.desc}${toDoList.tags.toString()}"))
		);
	}

	int check = 0;
	for (ToDo td in toDoList.todoItems) {

		if (check < 1 && td.isPriority() && !td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Priority**"))
			);
			check = 1;
		} else if (check < 2 && !td.isPriority() && !td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Low Priority**"))
			);
			check = 2;
		} else if (check < 3 && td.isComplete()) {
			todoItems.add(
				container(const MarkdownBody(data: "## **Completed**"))
			);
			check = 3;
		}

		// checkbox
		var checkbox = Checkbox(value: td.isComplete(), onChanged: (bool? value) { 
				// ignore: invalid_use_of_protected_member
				state.setState(() {
					// td.isComplete()? uncomplete(td) : complete(td);
					saveToDoLists(name: getCurrentList(), note: toggleComplete(td), item: td);
				});
			}
		); 

		// description
		bool toLong = td.desc.length >= 32;
		String shortDescription = toLong? td.desc.substring(0, 32) : td.desc;
		var description = GestureDetector(
			onTap: () => enterTxtPopup(
				context, 
				"Change To Do", 
				// ignore: invalid_use_of_protected_member
				(text) {state.setState(() => setDesc(td, text));},
				def: td.getDesc(),
			),
			child: MarkdownBody(data: "${td.isComplete()? "~~" : ""}${td.isPriority()? "**" : ""}"
				"${td.desc}${td.isPriority()? "**" : ""}${td.isComplete()? "~~" : ""}")
		);

		// dueDate
		bool isLate = td.isDue() && !td.isComplete()?
			DateTime.now().compareTo(td.getDueDate()!) > -1? true : false : false;
		TextStyle dueDateTxtStyle = TextStyle(
			color: isLate? Colors.red : null,
			fontWeight: isLate? FontWeight.bold : null,
			fontStyle: FontStyle.italic,
			);
		String formattedDueDate = td.isDue()? formatDate(td.getDueDate()!) : "";
		var dueDate = GestureDetector(
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
					td.isDue()? "Due: $formattedDueDate" : "Not Due",
					style: dueDateTxtStyle,
				),
		);

		// compDate
		String formattedCompDate = td.isComplete()? formatDate(td.getCompDate()) : "";
		if (formattedCompDate == "null") formattedCompDate = "N/A";
		var compDate = GestureDetector(
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
				td.isComplete()? "Done: $formattedCompDate" : "Incomplete",
				style: const TextStyle(fontStyle: FontStyle.italic),
			),
		);

		// star button
		var star = IconButton(
				onPressed: () { 
				// ignore: invalid_use_of_protected_member
					state.setState(() {
						saveToDoLists(name: getCurrentList(), note: togglePriority(td), item: td);
					});
				}, icon: Icon(td.isPriority()? Icons.star : Icons.star_border),
				padding: EdgeInsets.zero,
		); // end star button
		
		// delete button
		var delBtn = IconButton(
				onPressed: () {
				// ignore: invalid_use_of_protected_member
				confirmPopup(
					context, 
					"Confirm Delete",
					"Pressing \"Confirm\" will **permanently** delete  \n\"$shortDescription\"",
					// ignore: invalid_use_of_protected_member
					() {state.setState(() => deleteToDo(td));}
				);
			}, icon: const Icon(Icons.settings),
			padding: EdgeInsets.zero,
		); // end delete button

		var descCol = Column(
			children: [
				Row(
					children: [
						Flexible(child: description),
					]
				),
				Row(
					children: [
						Expanded(flex: 3, child: dueDate),
						const Expanded(flex: 1, child: Text(" - ")),
						Expanded(flex: 3, child: compDate),
						// Expanded(flex: 7, child: SizedBox())
						// flexible([dueDate]),
						// flexible([compDate]),
					],
				)
			]
		);

		var itemRow = Row(
			children: [
				Expanded(flex: 1, child: checkbox),
				Expanded(flex: 1, child: star),
				Expanded(flex: 12, child: descCol),
				Expanded(flex: 1, child: delBtn)
			]
		);

		var item = GestureDetector(
			onLongPress: () => confirmPopup(context, "Hi", "This is a test...", () => null),
			child: Container(
				decoration: BoxDecoration(
					border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
					borderRadius: BorderRadius.circular(10),
					color: Theme.of(context).canvasColor,
					boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 3, spreadRadius: 1)]
				),
				margin: const EdgeInsets.only(top: 2, bottom: 2),
				child: Container(margin: const EdgeInsets.only(top: 2, bottom: 2), child: itemRow)
			)
		);
		
		todoItems.add(
			item
		);


	} // end for


	return todoItems;
} // end displayToDoItems

