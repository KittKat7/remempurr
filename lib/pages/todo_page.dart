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
				getCurrentTodoName() != todoAllName?
					showPopup(context, (text) {setState(() => newTodo(text));}) : null;
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
		);
	} // end build
} // end _TodoPageState


List<Widget> displayTodoItems(BuildContext context, State state) {
	// create an empty list, this is what will be returned
	List<Widget> todoItems = [];
	// get the current todolist
	TodoList todoList = getTodoList(getCurrentTodoName());
	// sort the items
	todoList.sortItems();

	List<Todo> priority = [];
	List<Todo> normal = [];
	List<Todo> completed = [];

	for (Todo td in todoList.todoItems) {
		if (td.isComplete()) {
			completed.add(td);
		} else if (td.isPriority()) {
			priority.add(td);
		} else {
			normal.add(td);
		}
	}

	// for every priority todo
	for (Todo td in priority) {
		// checkbox
		var checkbox = Checkbox(value: false, onChanged: (bool? value) { 
			state.setState(() {
				// _isChecked = value!;
				complete(td);
		}); }); // end checkBtn
		// star button
		var star = IconButton(onPressed: () { 
			state.setState(() {
				saveTodoNotes(name: getCurrentTodoName(), note: togglePriority(td), item: td);
		}); },icon: const Icon(Icons.star)); // end star button
		// delete button
		var delBtn = IconButton(onPressed: () {
				state.setState(() {
					deleteTodo(td);
		}); }, icon: const Icon(Icons.delete)); // end delete button

		String formattedDate = "";
		td.vars[dueDate] == null? formattedDate = "" : formattedDate = formatDate(td.vars[dueDate]!);

		var row = Row(children: <Widget>[
			Expanded(flex: 1, child: checkbox),
			Expanded(flex: 4, child: Text(td.item, style: const TextStyle(fontWeight: FontWeight.bold,))),
			Expanded(flex: 1, child: star),
			Expanded(flex: 2, child: Text(formattedDate)),
			Expanded(flex: 1, child: delBtn),
		]);

		todoItems.add(
			row
		);
	} // end for every priority todo

	// for every normal todo
	for (Todo td in normal) {
		// checkbox
		var checkbox = Checkbox(value: false, onChanged: (bool? value) { 
			state.setState(() {
				// _isChecked = value!;
				complete(td);
		}); }); // end checkBtn
		// star button
		var star = IconButton(onPressed: () { 
			state.setState(() {
				saveTodoNotes(name: getCurrentTodoName(), note: togglePriority(td), item: td);
		}); },icon: const Icon(Icons.star_border)); // end star button
		// delete button
		var delBtn = IconButton(onPressed: () {
				state.setState(() {
					deleteTodo(td);
		}); }, icon: const Icon(Icons.delete)); // end delete button

		String formattedDate = "";
		td.vars[dueDate] == null? formattedDate = "" : formattedDate = formatDate(td.vars[dueDate]!);

		var row = Row(children: <Widget>[
			Expanded(flex: 1, child: checkbox),
			Expanded(flex: 4, child: Text(td.item)),
			Expanded(flex: 1, child: star),
			Expanded(flex: 2, child: Text(formattedDate)),
			Expanded(flex: 1, child: delBtn),
		]);

		todoItems.add(
			row
		);
	} // end for every normal todo

	// for every completed todo
	for (Todo td in completed) {
		// checkbox
		var checkbox = Checkbox(value: true, onChanged: (bool? value) { 
			state.setState(() {
				// _isChecked = value!;
				uncomplete(td);
		}); }); // end checkBtn
		// star button
		var star = IconButton(onPressed: () { 
			state.setState(() {
				saveTodoNotes(name: getCurrentTodoName(), note: togglePriority(td), item: td);
		}); },icon: Icon(td.isPriority() == true? Icons.star : Icons.star_border)); // end star button
		// delete button
		var delBtn = IconButton(onPressed: () {
				state.setState(() {
					deleteTodo(td);
		}); }, icon: const Icon(Icons.delete)); // end delete button

		String formattedDate = "";
		td.vars[compDate] == null? formattedDate = "" : formattedDate = formatDate(td.vars[compDate]!);

		var row = Row(children: <Widget>[
			Expanded(flex: 1, child: checkbox),
			Expanded(flex: 4, child: Text(td.item)),
			Expanded(flex: 1, child: star),
			Expanded(flex: 2, child: Text(formattedDate)),
			Expanded(flex: 1, child: delBtn),
		]);

		todoItems.add(
			row
		);
	} // end for every completed


	return todoItems;
} // end displayTodoItems

