import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/localization/locale_controller.dart';
import 'features/onboarding/domain/onboarding_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appLocaleController.load();
  await onboardingController.load();
  runApp(PetFinderApp(localeController: appLocaleController));
}
