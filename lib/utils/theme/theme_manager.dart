import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/model_holders.dart';
import '../../domain/model_holders/config_model_holder.dart';

class ThemeManager extends Notifier<ThemeMode> {
  ConfigModelHolder get _configModelHolder =>
      ref.read(configModelHolderProvider.notifier);

  @override
  ThemeMode build() {
    ref.listen(
      configModelHolderProvider,
      (_, value) {
        value.whenOrNull(
          data: (data) {
            state = data.isDark ? ThemeMode.dark : ThemeMode.light;
          },
        );
      },
    );

    return ThemeMode.system;
  }

  Future<void> changeTheme() async {
    final isDark = (state == ThemeMode.dark);

    return _configModelHolder.updateTheme(isDark: !isDark);
  }
}
