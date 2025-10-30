import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

extension LocalizationExs on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;
}
