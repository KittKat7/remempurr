import 'package:flutter/material.dart';
// custom
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/classes/todolist.dart';
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/helpers/helpers.dart';

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

		// new todo button
		var newTodoBtn = IconButton(
			icon: const Icon(Icons.add),
			onPressed: () {
				getCurrentTodoName() != allTodoList?
					enterTxtPopup(context, "New Todo", "Todo", (text) {setState(() => newTodo(text));}) : null;
			},
		);
		
		// set the text for the title
		var titleText = GestureDetector(
			onTap: () {
				// showListPopup();
				showTodoListsPopup(context, this);
				// setState(() => showTodoListsPopup(context, this));
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

		var todoListSettingsBtn = IconButton(
			icon: const Icon(Icons.settings),
			onPressed: () {
				enterTxtPopup(
					context, 
					"Rename", 
					getCurrentTodoName(), 
					(text) {setState(() => renameTodoList(getCurrentTodoName(), text));}
				);
				// setState(() => nextTodoNote());
				//Navigator.pushReplacementNamed(context, '/todo');
			},
		);

		var leftListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_left),
			onPressed: () {
				setState(() => previousTodoNote());
				//Navigator.pushReplacementNamed(context, '/todo');
			},
		);

		var rightListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_right),
			onPressed: () {
				setState(() => nextTodoNote());
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
				if (getCurrentTodoName() != allTodoList) todoListSettingsBtn,
				rightListBtn,
			],
		);
		
		var children = displayTodoItems(context, this);

		// return the Scaffold
		return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: titleRow,
				// remove the back button
				automaticallyImplyLeading: false,
				// add menu btn
				leading: menuBtn,
				actions: [ newTodoBtn, ],
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
} // end _TodoPageState


List<Widget> displayTodoItems(BuildContext context, State state) {
	// create an empty list, this is what will be returned
	List<Widget> todoItems = [];
	// get the current todolist
	ToDoList todoList = getTodoList(getCurrentTodoName());
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

	for (ToDo td in todoList.todoItems) {

		// checkbox
		var checkbox = Expanded(
			flex: 1,
			child: Checkbox(value: td.isComplete(), onChanged: (bool? value) { 
				// ignore: invalid_use_of_protected_member
				state.setState(() {
					// td.isComplete()? uncomplete(td) : complete(td);
					saveTodoNotes(name: getCurrentTodoName(), note: toggleComplete(td), item: td);
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
					td.getDesc(), 
					// ignore: invalid_use_of_protected_member
					(text) {state.setState(() => setDesc(td, text));}
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
					td.getDesc(), 
					// ignore: invalid_use_of_protected_member
					(text) {state.setState(() => setDesc(td, text));}
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
						saveTodoNotes(name: getCurrentTodoName(), note: togglePriority(td), item: td);
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
					() {state.setState(() => deleteTodo(td));}
				);
			}, icon: const Icon(Icons.delete),
			padding: EdgeInsets.zero,
		)); // end delete button




		var row = Row(children: <Widget>[
			checkbox,
			star,
			description,
			dueDate,
			compDate,
			delBtn,
		]);

		todoItems.add(
			row
		);

		if (toLong) {
			todoItems.add(Row(children: [const Expanded(flex: 1, child: SizedBox()), fullDescription]));
		}


	}


	return todoItems;
} // end displayTodoItems

