import 'package:remempurr/lang/en_us.dart' as en_us;

Map langs = {
	'en_us': en_us.lang,
};

class Lang {
	Map<String, String> langMap;
	Lang({required String lang}) : langMap = langs[lang];

	String getLang(String key, {List params = const []/*Map params = const {}*/,}) {
		String str = langMap[key]!;
		for (int i = 0; i < params.length; i++) {
			str = str.replaceAll('\${$i}', params[i]);
		}
		// for (String key in params.keys) {
		// 	str.replaceAll('\${key}', params[key]);
		// }
		return str;
	}
}