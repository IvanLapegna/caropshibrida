import 'package:caropshibrida/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Esto añade una propiedad .l10n a cualquier Context
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
