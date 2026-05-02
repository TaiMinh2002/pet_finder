import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const _localeCodeKey = 'locale_code';

  Future<String?> loadLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeCodeKey);
  }

  Future<void> saveLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, code);
  }
}
