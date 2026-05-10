import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_finder/l10n/app_localizations.dart';

import '../core/localization/locale_controller.dart';
import '../core/providers/app_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class PetFinderApp extends StatelessWidget {
  const PetFinderApp({required this.localeController, super.key});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: AnimatedBuilder(
        animation: localeController,
        builder: (context, _) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: appRouter,
            locale: localeController.locale,
            supportedLocales: LocaleController.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
