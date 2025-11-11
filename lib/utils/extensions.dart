import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/theme_provider.dart';
import '../l10n/app_localizations.dart';
import 'theme/themes.dart';

extension LocalizationExs on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;
}

extension ThemeProviderExs on BuildContext {
  Themes get theme => ThemeProvider.of(this);
}

extension ThemeExs on Themes {
  bool get isDark => name == 'dark';
}

extension BankExtensions on int {
  String get toCompact => NumberFormat.compact(locale: "en_US").format(this);
  String get toCompactBank => '\$ $toCompact';

  String get toFullBank => '\$ $this';

  String get toSeparated =>
      NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 0)
          .format(this);
  String get toSeparatedBank => '\$ $toSeparated';
}
