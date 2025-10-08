import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';

import '../data/config_model.dart';
import '../l10n/app_localizations.dart';

extension LocalizationExs on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
}

class LocaleManager with ChangeNotifier {
  static AppLocalizations? _appLocalizations;
  static Locale? _lang; // Set the default locale to English

  static void initialize(AppLocalizations appLocalizations) {
    _appLocalizations = appLocalizations;
  }

  Future<void> initLocale() async {
    if (thisConfig.locale != '') {
      _lang = Locale(thisConfig.locale);
    } else {
      final locale = await findSystemLocale();
      _lang = Locale(locale.split('_')[0]);
    }
  }

  static AppLocalizations get locale {
    return _appLocalizations!;
  }

  static Locale get lang => _lang!;
  void changeLocale(Locale newLocale) {
    _lang = newLocale;
    notifyListeners();
  }

  static void staticChangeLocale(Locale newLocale) {
    _lang = newLocale;
    //notifyListeners();
  }
}
