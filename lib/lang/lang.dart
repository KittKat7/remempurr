import 'package:remempurr/lang/en_us.dart' as en_us;
import 'package:remempurr/lang/lolcat.dart' as lolcat;

Map<String, Map<String, String>> langs = {
	'en_us': en_us.lang,
	'lolcat': lolcat.lang,
};

class Lang {
	Map<String, String> langMap;
	Lang({required String lang}) : langMap = langs[lang]!;

	void setLang(String lang) {
		langMap = langs[lang]!;
	}

	String getLang(String key, [List params = const []]) {
		String str = langMap[key]!;
		for (int i = 0; i < params.length; i++) {
			str = str.replaceAll('\${$i}', params[i]);
		}
		// for (String key in params.keys) {
		// 	str.replaceAll('\${key}', params[key]);
		// }
		return str;
	}

	bool contains(String key) {
		return langMap.containsKey(key);
	}
}