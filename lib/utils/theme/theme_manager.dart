import '../../domain/model_holders/config_model_holder.dart';
import '../logs.dart';
import 'ui_values.dart';

class ThemeManager {
  final ConfigModelHolder _configModelHolder;

  ThemeManager({required ConfigModelHolder configModelHolder})
      : _configModelHolder = configModelHolder;

  void changeTheme() {
    final currentConfig = _configModelHolder.state.requireValue;

    final isDark = thisTheme == themeList[1];

    thisTheme = themeList[isDark ? 0 : 1];

    _configModelHolder.updateConfig(
      currentConfig.copyWith(isDark: isDark),
    );

    logs.writeLog('Turn to ${thisTheme.name} mode');
  }
}
