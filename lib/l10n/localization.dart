import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl_standalone.dart';

import '../di/model_holders.dart';
import '../domain/models/config_model.dart';

class LocaleManager extends Notifier<Locale> {
  @override
  Locale build() {
    ref.listen(
      configModelHolderProvider,
      (_, value) {
        value.whenOrNull(
          data: _updateFromConfig,
        );
      },
    );

    return Locale('en');
  }

  Future<void> _updateFromConfig(ConfigModel config) async {
    if (config.locale.isNotEmpty) {
      state = Locale(config.locale);
    } else {
      final systemLocale = await findSystemLocale();
      state = Locale(systemLocale.split('_')[0]);
    }
  }

  void changeLocale(Locale newLocale) => ref
      .read(configModelHolderProvider.notifier)
      .changeLocale(newLocale.languageCode);
}
