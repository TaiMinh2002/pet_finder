import 'package:flutter/foundation.dart';

import '../../../core/storage/app_preferences.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({AppPreferences? preferences})
    : _preferences = preferences ?? AppPreferences.instance;

  final AppPreferences _preferences;

  bool _hasSeenOnboarding = false;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> load() async {
    _hasSeenOnboarding = await _preferences.loadHasSeenOnboarding();
  }

  Future<void> complete() async {
    if (_hasSeenOnboarding) return;
    _hasSeenOnboarding = true;
    notifyListeners();
    await _preferences.saveHasSeenOnboarding();
  }

  void resetForTest() {
    _hasSeenOnboarding = false;
    notifyListeners();
  }
}

final onboardingController = OnboardingController();
