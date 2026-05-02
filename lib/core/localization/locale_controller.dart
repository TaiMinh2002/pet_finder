import 'package:flutter/material.dart';

import 'locale_storage.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({LocaleStorage? storage})
    : _storage = storage ?? LocaleStorage();

  static const defaultLocale = Locale('vi');
  static const supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  final LocaleStorage _storage;

  Locale _locale = defaultLocale;
  Locale get locale => _locale;

  Future<void> load() async {
    final storedCode = await _storage.loadLocaleCode();
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
    await _storage.saveLocaleCode(locale.languageCode);
  }
}

final appLocaleController = LocaleController();
