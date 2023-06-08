
// class GlowButton extends StatefulWidget {
// 	final Widget child;
// 	final VoidCallback onTap;
// 	final Color color;

// 	GlowButton({required this.child, required this.onTap, this.color = Colors.blue});

// 	@override
// 	_GlowButtonState createState() => _GlowButtonState();
// }

// class _GlowButtonState extends State<GlowButton> {
// 	bool _isHovered = false;

// 	@override
// 	Widget build(BuildContext context) {
// 		Color defaultBorderColor = Theme.of(context).canvasColor;
// 		Color hoverBorderColor = Colors.red;
// 		Color currentBorderColor = _isHovered ? hoverBorderColor : defaultBorderColor;

// 		Color defaultColor = Theme.of(context).canvasColor;
// 		Color hoverColor = Colors.red;
// 		Color currentColor = _isHovered ? hoverColor : defaultColor;

// 		Widget content = AnimatedContainer(
// 			duration: const Duration(milliseconds: 100),
// 			decoration: BoxDecoration(
// 				border: Border.all(
// 					color: currentBorderColor,
// 					width: 2,
// 				),
// 				borderRadius: BorderRadius.circular(10),
// 				color: currentColor,
// 				boxShadow: [
// 					BoxShadow(
// 						color: Theme.of(context).colorScheme.primary,
// 						blurRadius: 3,
// 						spreadRadius: 1,
// 					),
// 				],
// 			),
// 			margin: const EdgeInsets.only(top: 2, bottom: 2),
// 			child: Container(
// 				margin: const EdgeInsets.only(top: 4, bottom: 4),
// 				alignment: Alignment.center,
// 				child: widget.child,
// 			),
// 		);

// 		Widget button = GestureDetector(
// 			onLongPress: () => setState(() {
// 				_isHovered = true;
// 			}),
// 			onLongPressCancel: () => setState(() {
// 				_isHovered = false;
// 			}),
// 			onTap: widget.onTap,
// 			child: content,
// 		);

// 		return MouseRegion(
// 			onEnter: (_) {
// 				setState(() {
// 					_isHovered = true;
// 				});
// 			},
// 			onExit: (_) {
// 				setState(() {
// 					_isHovered = false;
// 				});
// 			},
// 			child: button,
// 		);
// 	}
// }


/*
class GlowButton extends StatefulWidget {
	final Widget child;
	final VoidCallback onTap;
	final Color color;

	GlowButton({required this.child, required this.onTap, this.color = Colors.blue});

	@override
	_GlowButtonState createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
	bool _isHovered = false;

	@override
	Widget build(BuildContext context) {
		Widget content = Container(
			decoration: BoxDecoration(
				border: Border.all(
					color: _isHovered ? Colors.red : Theme.of(context).colorScheme.onBackground,
					width: 2,
				),
				borderRadius: BorderRadius.circular(10),
				color: _isHovered ? Colors.red : Theme.of(context).canvasColor,
				boxShadow: [
					BoxShadow(
						color: Theme.of(context).colorScheme.primary,
						blurRadius: 3,
						spreadRadius: 1,
					),
				],
			),
			margin: const EdgeInsets.only(top: 2, bottom: 2),
			child: Container(
				margin: const EdgeInsets.only(top: 4, bottom: 4),
				alignment: Alignment.center,
				child: widget.child,
			),
		);

		Widget button = GestureDetector(
			onTap: widget.onTap,
			child: content,
		);

		return MouseRegion(
			onEnter: (_) {
				setState(() {
					_isHovered = true;
				});
			},
			onExit: (_) {
				setState(() {
					_isHovered = false;
				});
			},
			child: button,
		);
	}
}
*/
/*
class GlowButton extends StatelessWidget {
	final Widget child;
	final VoidCallback onTap;
	final Color color;

	GlowButton({required this.child, required this.onTap, this.color = Colors.blue});

	@override
	Widget build(BuildContext context) {

		Widget content = Container(
			decoration: BoxDecoration(
				border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
				borderRadius: BorderRadius.circular(10),
				color: Theme.of(context).canvasColor,
				boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 3, spreadRadius: 1)]
			),
			margin: const EdgeInsets.only(top: 2, bottom: 2),
			child: Container(
				margin: const EdgeInsets.only(top: 4, bottom: 4),
				alignment: Alignment.center,
				child: child,
			),
		);

		Widget button = GestureDetector(
			onTap: onTap,
			child: content
		);

		return button;
	}
}
*/


// return the Scaffold
// return Scaffold(
// 	appBar: AppBar(
// 		centerTitle: true,
// 		title: titleRow,
// 		// remove the back button
// 		automaticallyImplyLeading: false,
// 		// add menu btn
// 		leading: menuBtn,
// 		actions: [ if (currentName != keyAll) rmprNoteSettingsBtn,/*if (currentName != keyAll) newToDoBtn,*/ ],
// 	),
// 	body: PaddedScroll(
// 		context: context,
// 		children: children,
// 	),
// 	floatingActionButton: currentName != keyAll? FloatingActionButton(
// 		onPressed: () {
// 			enterTxtPopup(context, "New ToDo", (text) {setState(() => newToDo(getCurrentNote(), text));}, hint: "Something to do");
// 		},
// 		child: const Icon(Icons.add),
// 	) : null,
// 	// floatingActionButton: FloatingActionButton(
// 	// 	onPressed: () => Navigator.pushNamed(context, "/help"),
// 	// 	child: const Icon(Icons.help),
// 	// ),
// );