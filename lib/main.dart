import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/localization/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appLocaleController.load();
  runApp(PetFinderApp(localeController: appLocaleController));
}
