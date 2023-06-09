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
    return ElevatedButton(
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
  
  const PaddedScroll({super.key, required this.context, required this.children});

  @override
  Widget build(BuildContext context)
  {
    final screenSize = getScreenSize(context);
    var edgeInsets = EdgeInsets.symmetric(
      horizontal: screenSize.width * paddingW,
      vertical: screenSize.height * paddingH,
    );
    var column = Column(
      children: children,
    );
    var padding = Padding(
      padding: edgeInsets,
      child: column,
    );
    return Center(
      child: SingleChildScrollView(
        child: padding
      ),
    );
  } // end buidl
} // end PaddedScroll


class GlowButton extends StatelessWidget {
	final Widget child;
	final VoidCallback onTap;
	final Color color;

	const GlowButton({super.key, required this.child, required this.onTap, this.color = Colors.blue});

	@override
	Widget build(BuildContext context) {

		Widget content = Container(
			decoration: BoxDecoration(
				border: Border.all(color: Theme.of(context).canvasColor, width: 2),
				borderRadius: BorderRadius.circular(10),
				color: Theme.of(context).canvasColor,
				boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 3, spreadRadius: 2)]
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


class NoteButton extends StatelessWidget {
	final RmprNote note;
	final Function() onTap;
	final Function() optFunc;
	
	NoteButton({required this.onTap, required this.note, required this.optFunc});


	@override
	Widget build(BuildContext context) {
		GlowButton button = GlowButton(onTap: onTap, child: _buildChild(context, note, optFunc),);
		// Widget content = Container(
		// 	decoration: BoxDecoration(
		// 		border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
		// 		borderRadius: BorderRadius.circular(10),
		// 		color: Theme.of(context).canvasColor,
		// 		boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary, blurRadius: 3, spreadRadius: 1)]
		// 	),
		// 	margin: const EdgeInsets.only(top: 2, bottom: 2),
		// 	child: Container(
		// 		margin: const EdgeInsets.only(top: 4, bottom: 4),
		// 		alignment: Alignment.center,
		// 		child: _buildChild(context, note, optFunc),
		// 	),
		// );

		// Widget button = GestureDetector(
		// 	onTap: onTap,
		// 	child: content
		// );

		return button;
	}
	static Widget _buildChild(BuildContext context, RmprNote note, Function() optFunc) {
		Column col = Column(
			children: [
				Text(note.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
				// const Text("--- --- ---"), // uncomment to add aditional space
				Divider(color: Theme.of(context).colorScheme.primary),
				Text(note.note.isEmpty? "---" : note.note, textAlign: TextAlign.center,),
				// Text(note.toDoItems.toString(), textAlign: TextAlign.center,),
				Row(children: [
					Expanded(child: Align(
						alignment: Alignment.centerLeft,
						child: Text("  ${note.toDoItems.length} items", style: const TextStyle(fontWeight: FontWeight.bold),),
					)),
					Expanded(child: Align(
						alignment: Alignment.centerRight,
						child: Material(child: IconButton(onPressed: optFunc, icon: const Icon(Icons.settings))),
					))
				]),
			],
		);
		return col;
	}
}
