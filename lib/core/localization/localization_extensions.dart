import 'package:flutter/widgets.dart';
import 'package:pet_finder/l10n/app_localizations.dart';

extension LocalizationExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
