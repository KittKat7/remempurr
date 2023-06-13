import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:remempurr/classes/rmpr_note.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';


class SignBox extends StatefulWidget {
  final Image? image;
  final bool offset;
  const SignBox({super.key, required this.image, this.offset = false});
  
  @override
  _SignBoxState createState() => _SignBoxState();
}

class _SignBoxState extends State<SignBox> {
    
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Image? image = widget.image;
    Size screenSize = getScreenSize(context);
    double width = (screenSize.width * (1 - paddingW * 2));
    double height = ((screenSize.width * (1 - paddingW * 2)) * 3 / 4);
    //_imagePath = widget.initialImagePath;
    
    var child = image == null ? const SizedBox()
      : (height - 4 >= 1024 ? Transform.scale(scale: (height - 4) / (1024), child: image) : image);
    
    Row box = Row(
      children: <Widget>[
        Expanded(flex: 6, child: child),
        Expanded(flex: widget.offset ? 1 : 0, child: const SizedBox()),
      ],
    );

    var border = Border.all(
      color: Colors.black,
      width: 2.0,
    );
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: border,
      ),
      child: box
    );
  }
}

class GoBackButton extends StatelessWidget
{
  // FIELDS
  final BuildContext context;
  final Function? exec;
  const GoBackButton({super.key, required this.context, this.exec});
  
  @override
  Widget build(BuildContext context)
  {
    return StyledOutlinedButton(
      onPressed: () {
        Navigator.pop(context);
        exec == null ? exec : null;
      },
      child: const Text('Go Back'),
    );
  } // end build
} // end GoBackButton

class PaddedScroll extends StatelessWidget
{
  // FIELDS
  final BuildContext context;
  final List<Widget> children;
	final Alignment alignment;
  
  const PaddedScroll({super.key, required this.context, required this.alignment, required this.children});

  @override
  Widget build(BuildContext context)
  {
    final screenSize = getScreenSize(context);
    var edgeInsets = EdgeInsets.symmetric(
      horizontal: screenSize.width * paddingW,
      vertical: screenSize.height * paddingH,
    );
    var column = Column(
				mainAxisAlignment: MainAxisAlignment.center,
      	children: children,
    );
    var padding = Padding(
      padding: edgeInsets,
      child: column,
    );
    return Align(
			alignment: alignment,
      child: SingleChildScrollView(
        child: padding
      ),
    );
  } // end buidl
} // end PaddedScroll


class StyledOutlinedButton extends StatelessWidget {
	final Widget child;
	final VoidCallback onPressed;
	final bool isFilled;

	const StyledOutlinedButton({super.key, required this.child, required this.onPressed, this.isFilled = false});

	@override
	Widget build(BuildContext context) {
		Color outline = isFilled? Theme.of(context).canvasColor : Theme.of(context).colorScheme.primary;
		Color fill = isFilled? Theme.of(context).colorScheme.primary : Theme.of(context).canvasColor;

		Widget content = Container(
			decoration: BoxDecoration(
				border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
				borderRadius: BorderRadius.circular(10),
				color: fill,
				// boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 2, spreadRadius: 5)]
			),
			margin: const EdgeInsets.only(top: 2, bottom: 2),
			child: Container(
				margin: const EdgeInsets.only(top: 4, bottom: 4),
				alignment: Alignment.center,
				child: child,
			),
		);

		Widget button = GestureDetector(
			onTap: onPressed,
			child: content
		);

		return button;
	}
}




// class noteButton extends StatelessWidget {
// 	final RmprNote note;
// 	final Function() onPressed;
// 	final Function() optFunc;
	
// 	noteButton({required this.onPressed, required this.note, required this.optFunc});


// 	@override
// 	Widget build(BuildContext context) {
// 		return StyledOutlinedButton(onPressed: onPressed, child: _buildChild(context, note, optFunc),);
// 		// Widget content = Container(
// 		// 	decoration: BoxDecoration(
// 		// 		border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
// 		// 		borderRadius: BorderRadius.circular(10),
// 		// 		color: Theme.of(context).canvasColor,
// 		// 		boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 3, spreadRadius: 1)]
// 		// 	),
// 		// 	margin: const EdgeInsets.only(top: 2, bottom: 2),
// 		// 	child: Container(
// 		// 		margin: const EdgeInsets.only(top: 4, bottom: 4),
// 		// 		alignment: Alignment.center,
// 		// 		child: _buildChild(context, note, optFunc),
// 		// 	),
// 		// );

// 		// Widget button = GestureDetector(
// 		// 	onTap: onTap,
// 		// 	child: content
// 		// );

// 		// return button;
// 	}
// 	static Widget _buildChild(BuildContext context, RmprNote note, Function() optFunc) {
// 		Column col = Column(
// 			children: [
// 				Text(note.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
// 				// const Text("--- --- ---"), // uncomment to add aditional space
// 				Divider(color: Theme.of(context).colorScheme.primary),
// 				Text(note.note.isEmpty? "---" : note.note, textAlign: TextAlign.center,),
// 				// Text(note.toDoItems.toString(), textAlign: TextAlign.center,),
// 				Row(children: [
// 					Expanded(child: Align(
// 						alignment: Alignment.centerLeft,
// 						child: Text("  ${note.toDoItems.length} items", style: const TextStyle(fontWeight: FontWeight.bold),),
// 					)),
// 					Expanded(child: Align(
// 						alignment: Alignment.centerRight,
// 						child: Material(child: IconButton(onPressed: optFunc, icon: const Icon(Icons.settings))),
// 					))
// 				]),
// 			],
// 		);
// 		return col;
// 	}
// }

// class StyledOutlinedButton extends StatelessWidget{
// 	final Widget child;
// 	final VoidCallback onPressed;

// 	const StyledOutlinedButton({super.key, required this.child, required this.onPressed});

// 	@override
// 	Widget build(BuildContext context) {
// 		OutlinedButton button = OutlinedButton(
// 			style: OutlinedButton.styleFrom(
// 				backgroundColor: Theme.of(context).canvasColor,
// 				side: BorderSide(
// 					width: 4,
// 					color: Theme.of(context).colorScheme.primary,
// 				)
// 			),
// 			onPressed: onPressed,
// 			child: child,
// 		);

// 		return button;
// 	}
// 	// 	OutlinedButton StyledOutlinedButton({
// 	// 	required BuildContext context,
// 	// 	required Function() onPressed,
// 	// 	required Widget child,
// 	// 	}) {
// 	// 	return OutlinedButton(
// 	// 		style: OutlinedButton.styleFrom(
// 	// 			backgroundColor: getColorTheme(context)
// 	// 		),
// 	// 		onPressed: onPressed,
// 	// 		child: child,
// 	// 	);
// 	// }
// }