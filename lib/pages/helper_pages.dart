import 'package:flutter/material.dart';
// custom
import 'package:remempurr/helpers/graphics.dart';
import 'package:remempurr/classes/widgets.dart';
import 'package:remempurr/options.dart';

/* ========== ABOUT PAGE ==========*/
/* ABOUT PAGE */
class AboutPage extends StatefulWidget {
	const AboutPage({super.key, required this.title});
	final String title;
	@override
	State<AboutPage> createState() => _AboutPageState();
} // and AboutPage

class _AboutPageState extends State<AboutPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				context: context,
				alignment: Alignment.center,
				children: children(context),
			)
		);
	}

	List<Widget> children(BuildContext context) {
		return <Widget>[
			Text(
				widget.title,
				textAlign: TextAlign.center,
				textScaleFactor: 2,
				style: const TextStyle(fontWeight: FontWeight.bold),
			),
			// main about
			readFileWidget('assets/texts/about.md'),
			// MarkdownBody(data: getLang('long_about')),
			// spacer
			spacer,
			// back button
			GoBackButton(context: context),
		];
	} // end build
} // end _AboutPageState


/* ========== ERROR PAGE ==========*/
/* ABOUT PAGE */
class ErrorPage extends StatefulWidget {
	const ErrorPage({super.key, required this.title});
	final String title;
	@override
	State<ErrorPage> createState() => _ErrorPageState();
} // and AboutPage

class _ErrorPageState extends State<ErrorPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				alignment: Alignment.center,
				context: context,
				children: children(context),
			)
		);
	}

	List<Widget> children(BuildContext context) {
		return <Widget>[
			Text(
				widget.title,
				textAlign: TextAlign.center,
				textScaleFactor: 2,
				style: const TextStyle(fontWeight: FontWeight.bold),
			),
			// main about
			Text(getLang('msg_error_has_occured', [thrownError])),
			// spacer
			spacer,
			// back button
			GoBackButton(context: context),
		];
	} // end build
} // end _AboutPageState


/* ========== HELP PAGE ==========*/
/* HELP PAGE */
class HelpPage extends StatefulWidget {
	const HelpPage({super.key, required this.title});
	final String title;
	@override
	State<HelpPage> createState() => _HelpPageState();
} // and HelpPage

class _HelpPageState extends State<HelpPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: PaddedScroll(
				context: context,
				alignment: Alignment.center,
				children: children(context),
			)
		);
	}

	List<Widget> children(BuildContext context) {
		return <Widget>[
			Text(
				widget.title,
				textAlign: TextAlign.center,
				textScaleFactor: 2,
				style: const TextStyle(fontWeight: FontWeight.bold),
			),
			// main about
			readFileWidget('assets/texts/help.md'),
			// spacer
			spacer,
			// back button
			GoBackButton(context: context),
		];
	} // end build
} // end _HelpPageState