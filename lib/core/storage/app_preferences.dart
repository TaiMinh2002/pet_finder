import 'package:shared_preferences/shared_preferences.dart';

import '../constants/preference_keys.dart';

class AppPreferences {
  static AppPreferences? _instance;
  static AppPreferences get instance => _instance ??= AppPreferences._();

  AppPreferences._();

  Future<String?> loadLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PreferenceKeys.localeCode);
  }

  Future<void> saveLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.localeCode, code);
  }

  Future<bool> loadHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferenceKeys.hasSeenOnboarding) ?? false;
  }

  Future<void> saveHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferenceKeys.hasSeenOnboarding, true);
  }
}
