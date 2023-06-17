const String githubSite = 'https://github.com/KittKat7/Remempurr';

String concat(List<String> strs) {
	String str = '';
	for (int i = 0; i < strs.length; i++) {
		str += strs[i];
		if (i < strs.length - 1) {
			str += '\n';
		}
	}
	return str;
}