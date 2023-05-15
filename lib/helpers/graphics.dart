import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher_string.dart';


/* ========== HELPERS ========== */
// vars
const Text spacer = Text("");
double paddingW = 0.1; // the percent of horiontal padding on each side
double paddingH = 0.05; // the amount of verticle padding on each side
double paddedW = 0; // the width of the available screen (excluding padding)
double paddedH = 0; // the height of the available screen (excluding padding)
double scale = 1; // not sure

var rBundle = rootBundle;

bool isDark = true;

// Future<void> loadWords() async {
//   String text = await rootBundle.loadString('assets/texts/words.txt');
//   wordList = text.split(" ");
// }

Size getScreenSize(BuildContext context) {
	Size size = MediaQuery.of(context).size;

	double scaleW = size.width / 10;
	double scaleH = size.height / 16;

	double aspectW = 10;
	double aspectH = 16;

	// ignore: unused_local_variable
	double drawW = scaleW / aspectW;
	// ignore: unused_local_variable
	double drawH = scaleH / aspectH;

	double scale = scaleH * 10;
	paddingW = (size.width - scale) / (size.width) / 2;
	if (paddingW < 0.1) {
		paddingW = 0.1;
	}
	return size;
}

double getPaddingW()
{
	return paddedW;
}

double getPaddingH()
{
	return paddedH;
}

/// Returns a widget for displaying the content of a file located at the given path.
/// The content is displayed using a MarkdownBody widget.
Widget readFileWidget(String path) {
	// Use a FutureBuilder to load the file content asynchronously
	return FutureBuilder(
		// Load the file content as a string
		future: rootBundle.loadString(path),
		// Build the widget once the file content is loaded
		builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
			// If the file content is loaded
			if (snapshot.hasData) {
				// Return a MarkdownBody widget to display the file content
				return MarkdownBody(
					data: snapshot.data ?? "Could not load file",
					onTapLink: (text, url, title) {
						// Launch the URL when a link is tapped
						launchUrlString(url!);
					},
					//textAlign: TextAlign.justify,
				);
			} else {
				// Return a CircularProgressIndicator while the file content is being loaded
				return const CircularProgressIndicator();
			} // if else
		},
	);
} // end readFileWidget


void showPopup(BuildContext context, Function(String) onConfirm) {
  final TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('New Name'),
        content: TextField(
          controller: _controller,
          onChanged: (value) {
            // Handle text change
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              // Handle cancel
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              // Handle confirm
              String text = _controller.text;
              onConfirm(text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


