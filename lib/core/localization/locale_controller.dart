import 'package:flutter/material.dart';

import '../storage/app_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({AppPreferences? preferences})
    : _preferences = preferences ?? AppPreferences.instance;

  static const defaultLocale = Locale('vi');
  static const supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  final AppPreferences _preferences;

  Locale _locale = defaultLocale;
  Locale get locale => _locale;

  Future<void> load() async {
    final storedCode = await _preferences.loadLocaleCode();
    if (storedCode == null || storedCode.isEmpty) {
      _locale = defaultLocale;
      return;
    }

    final matched = supportedLocales.where(
      (locale) => locale.languageCode == storedCode,
    );
    _locale = matched.isEmpty ? defaultLocale : matched.first;
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    await _preferences.saveLocaleCode(locale.languageCode);
  }
}

final appLocaleController = LocaleController();
