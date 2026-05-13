import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/localization/locale_controller.dart';
import 'features/auth/presentation/bloc/auth_session_controller.dart';
import 'features/onboarding/domain/onboarding_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  authSession.start();
  await appLocaleController.load();
  await onboardingController.load();
  runApp(PetFinderApp(localeController: appLocaleController));
}
