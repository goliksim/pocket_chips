import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';

import '../domain/model_holders/config_model_holder.dart';

class LocaleManager with ChangeNotifier {
  final ConfigModelHolder _configModelHolder;

  static Locale? _lang;

  LocaleManager({
    required ConfigModelHolder configModelHolder,
    required Function(VoidCallback) addListener,
  }) : _configModelHolder = configModelHolder {
    addListener(notifyListeners);
  }

  Future<void> initLocale() async {
    final appConfig = _configModelHolder.dataOrNull;

    if (appConfig != null && appConfig.locale != '') {
      _lang = Locale(appConfig.locale);
    } else {
      final locale = await findSystemLocale();
      _lang = Locale(locale.split('_')[0]);
    }
  }

  Locale get lang => _lang!;

  void changeLocale(Locale newLocale) {
    _lang = newLocale;
    notifyListeners();
  }
}
