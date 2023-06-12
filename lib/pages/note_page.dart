import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// custom
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/classes/rmpr_note.dart';
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/helpers/helpers.dart';
import 'package:remempurr/options.dart';

class NotePage extends StatefulWidget
{
	final String title;
	const NotePage({super.key, required this.title});
	
	@override
	State<NotePage> createState() => _NotePageState();
} // end ToDoPagePage

class _NotePageState extends State<NotePage>
{
	@override
	Widget build(BuildContext context) {
		
		// menu button
		var backBtn = IconButton(
			icon: const Icon(Icons.arrow_back),
			onPressed: () {
				Navigator.pop(context);
				// Navigator.pushNamed(context, '/menu');
			},
		);
		
		// set the text for the title
		var titleText = GestureDetector(
			onTap: () {
				// showListPopup();
				showToDoListsPopup(context, this, (name) {currentName = name;});
				// setState(() => showToDoListsPopup(context, this));
			},
			child: Padding(
				padding: const EdgeInsets.all(15.0),
				child: Text(
					currentName,
					textAlign: TextAlign.center,
					// style: const TextStyle(fontWeight: FontWeight.bold),
				),
			),
		);

		var rmprNoteSettingsBtn = IconButton(
			icon: const Icon(Icons.settings),
			onPressed: () {
				enterTxtPopup(
					context,
					"Rename",
					(text) {setState(() => renameNote(currentName, text));},
					def: currentName,
				);
				// setState(() => nextToDoNote());
				//Navigator.pushReplacementNamed(context, pageRoute['note']);
			},
		);

		var leftListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_left),
			onPressed: () {
				setState(() => currentName = prevNoteName());
				//Navigator.pushReplacementNamed(context, pageRoute['note']);
			},
		);

		var rightListBtn = IconButton(
			icon: const Icon(Icons.keyboard_arrow_right),
			onPressed: () {
				setState(() => currentName = nextNoteName());
				//Navigator.pushReplacementNamed(context, pageRoute['note']);
			},
		);
		
		// title row
		var titleRow = Row(
			// mainAxisAlignment: MainAxisAlignment.center,
			mainAxisSize: MainAxisSize.min,
			children: [
				leftListBtn,
				titleText,
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
				leading: backBtn,
				actions: [ if (currentName != keyAll) rmprNoteSettingsBtn,/*if (currentName != keyAll) newToDoBtn,*/ ],
			),
			body: PaddedScroll(
				context: context,
				children: children,
			),
			floatingActionButton: currentName != keyAll? FloatingActionButton(
				onPressed: () {
					enterTxtPopup(context, "New ToDo", (text) {setState(() => newToDo(getCurrentNote(), text));}, hint: "Something to do");
				},
				child: const Icon(Icons.add),
			) : null,
			// floatingActionButton: FloatingActionButton(
			// 	onPressed: () => Navigator.pushNamed(context, "/help"),
			// 	child: const Icon(Icons.help),
			// ),
		);
	} // end build
} // end _ToDoPageState


List<Widget> displayToDoItems(BuildContext context, State state) {
	// create an empty list, this is what will be returned
	List<Widget> todoItems = [];
	// get the current todolist
	//ToDoList toDoList = getToDoList(currentName);
	
	RmprNote rmprNote = getCurrentNote();

	List<ToDo> toDoList = [];


	toDoList = List.from(rmprNote.toDoItems);

	if (isTimeline) {
		toDoList.sort();
	} else {
		List<ToDo> inComplete = [];
		List<ToDo> completed = [];
		for (int i = 0; i < toDoList.length; i++) {
			if (toDoList[i].isComplete()) {
				completed.add(toDoList[i]);
			} else {
				inComplete.add(toDoList[i]);
			}
		}
		toDoList = inComplete + completed;
	}
	
	// sort the items
	//toDoList.sortItems();

	Container container(Widget child) {
		return Container(
			margin: const EdgeInsets.all(10),
			child: child,
		);
	}
	final TextEditingController controller = TextEditingController(text: rmprNote.note);
	if (rmprNote.name != keyAll) {
		todoItems.add(
			container(const MarkdownBody(data: "## **Note**"))
		);
		todoItems.add(
			// container(MarkdownBody(data: "${rmprNote.note}${/*rmprNote.tags.toString()*/""}"))
			StyledOutlinedButton(
				onPressed: () {  },
				child: container(
					TextField(
						controller: controller,
						onChanged: (String text) {
							rmprNote.note = text;
							saveToDoNotes();
						},
						keyboardType: TextInputType.multiline,
						maxLines: null,
					)
				)
			)
		);
		// todoItems.add(
		// 	GlowButton(child: Text("SaveText"), onTap: () {
		// 		rmprNote.note = controller.text;
		// 		saveToDoNotes();
		// 	})
		// );
	}

	todoItems.add(
		Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
			container(const MarkdownBody(data: "## **Checklist**")),
			StyledOutlinedButton(
				onPressed: () => state.setState(() {isTimeline = !isTimeline;}),
				isFilled: isTimeline,
				child: const Text("Timeline"),
			),
		])
	);
	for (ToDo td in toDoList) {
		
		// checkbox
		var checkbox = Checkbox(value: td.isComplete(), onChanged: (bool? value) { 
				// ignore: invalid_use_of_protected_member
				state.setState(() {
					td.isComplete()? td.clearCompDate() : td.setCompDate(DateTime.now());
					saveToDoNotes();
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
				(text) {state.setState(() {td.desc = text.trim(); saveToDoNotes();});},
				def: td.desc,
			),
			child: MarkdownBody(data: "${td.isComplete()? "~~" : ""}${td.isStarred()? "**" : ""}"
				"${td.desc.trim()}${td.isStarred()? "**" : ""}${td.isComplete()? "~~" : ""}")
		);

		// dueDate
		bool isLate = false;
		if (td.isDue() && !td.isComplete()) {
			DateTime? dueDate = DateTime.tryParse(td.getDueString());
			if (dueDate != null && DateTime.now().compareTo(dueDate) > -1) {
				isLate = true;
			}
		}

		TextStyle dueDateTxtStyle = TextStyle(
			color: isLate? Colors.red : null,
			fontWeight: isLate? FontWeight.bold : null,
			fontStyle: FontStyle.italic,
			);
		String formattedDueDate = formatDateString(td.getDueString());
		var dueDate = GestureDetector(
				onTap: () { 
					dateSelect(
						context, 
						// ignore: invalid_use_of_protected_member
						(date) => state.setState(() => td.setDueDate(date))
					);
				},
				onLongPress: () {
					confirmPopup(
						context, 
						"Remove Due Date", 
						"Pressing \"Confirm\" will remove the due date for  \n\"$shortDescription\"", 
						// ignore: invalid_use_of_protected_member
						() => state.setState(() => td.clearDueDate())
					);
				},
				child: Text(
					td.isDue()? "Due: $formattedDueDate" : "Not Due",
					style: dueDateTxtStyle,
				),
		);

		// compDate
		String formattedCompDate = td.isComplete()? formatDate(td.getCompDate()) : "";
		if (formattedCompDate == "") formattedCompDate = "N/A";
		var compDate = GestureDetector(
			onTap: () { 
				/* //TODO
				dateSelect(
					context, 
					// ignore: invalid_use_of_protected_member
					(p0) => state.setState(() => setComplete(td, p0))
				);
				*/
			},
			onLongPress: () {
				/* //TODO
				confirmPopup(
					context, 
					"Remove Completed Date", 
					"Pressing \"Confirm\" will remove the completed date for  \n\"$shortDescription\"", 
					// ignore: invalid_use_of_protected_member
					() => state.setState(() => setComplete(td, null))
				);
				*/
			},
			child: Text(
				td.isComplete()? "Done: $formattedCompDate" : "Incomplete",
				style: const TextStyle(fontStyle: FontStyle.italic),
			),
		);

		// star button
		var star = Material(child: IconButton(
				onPressed: () { 
					// ignore: invalid_use_of_protected_member
					state.setState(() {
						td.isStarred()? td.star(false) : td.star(true);
						saveToDoNotes();
					});
				}, icon: Icon(td.isStarred()? Icons.star : Icons.star_border),
				padding: EdgeInsets.zero,
		)); // end star button
		
		// delete button
		var delBtn = Material(child: IconButton(
				onPressed: () {
					// ignore: invalid_use_of_protected_member
					confirmPopup(
						context, 
						"Confirm Delete",
						"Pressing \"Confirm\" will **permanently** delete  \n\"$shortDescription\"",
						// ignore: invalid_use_of_protected_member
						() {state.setState(() => delToDo(td));}
					);
				}, icon: const Icon(Icons.settings),
			padding: EdgeInsets.zero,
		)); // end delete button

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
			child: StyledOutlinedButton(
				onPressed: () {},
				child: Container(margin: const EdgeInsets.only(top: 2, bottom: 2), child: itemRow)
			)
		);
		
		todoItems.add(
			item
		);
		todoItems.add(
			spacer
		);


	} // end for


	return todoItems;
} // end displayToDoItems

