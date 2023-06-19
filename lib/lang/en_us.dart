import 'package:remempurr/lang/helpers.dart';

Map<String, String> lang = {
	'example': '\${0}',

	'title': 'Remempurr',

	'rename': 'Rename',
	'timeline': 'Timeline',
	'change_to-do': 'Change To-Do',
	'new_to-do': 'New To-Do',
	'confirm_remove_due_date': 'Remove Due Date',
	'confirm_delete': 'Confirm Delete',
	'cycle_color': 'Cycle Color',
	'reset': 'Reset',
	'enable_notifications': 'Enable Notifications',
	'language': 'Language',

	'hdr_checklist': '## **Checklist**',
	'hdr_note': '## **Note**',

	'str_due': 'Due: \${0}',
	'str_not_due': 'Not Due',
	'str_completed': 'Done: \${0}',
	'str_not_completed': 'Incomplete',
	'str_n/a': 'N/A',

	'msg_confirm_remove_due_date': 'Pressing "Confirm" will remove the due date for  \n"\${0}"',
	'msg_confirm_delete': "Pressing \"Confirm\" will **permanently** delete  \n\"\${0}\"",
	'msg_error_has_occured': 'An Error has occured\n\${0}',

	'long_about': concat([
		'## **What is Remempurr**',
		'Remempurr is a reminder / to-do app designed to be simple, clean, and to help you stay on track. Remempurr is OSS (open-source software), and the source code can be found at [$githubSite]($githubSite).',
		'',
		'### **Features**',
		'- Allows exporting to-do lists to markdown files',
		'- Allows importing to-do lists from markdown files',
		'- Prioritizing to-do items',
		'- Recuring to-do items (*coming soon*)',
		'- Setting due dates',
		'- Keeping track of item completion dates',
		'- Timeline of items (*coming soon*)',
		'- Catagorized lists',
		'- Open-source software',
		'- Free to use web-app',
	])
};