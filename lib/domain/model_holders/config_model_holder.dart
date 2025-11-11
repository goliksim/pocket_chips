import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/repositories.dart';
import '../../utils/logs.dart';
import '../models/config_model.dart';

class ConfigModelHolder extends AsyncNotifier<ConfigModel> {
  @override
  FutureOr<ConfigModel> build() => ref.read(appRepositoryProvider).getConfig();

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> updateConfig(ConfigModel? newConfig) async {
    if (newConfig == null) {
      return;
    }

    state = AsyncValue.data(newConfig);

    try {
      await ref.read(appRepositoryProvider).updateConfig(newConfig);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении конфига: $e');
    }
  }

  Future<void> changeLocale(String newLocale) => updateConfig(
        state.value?.copyWith(
          locale: newLocale,
        ),
      );

  Future<void> setFirstLaunch() => updateConfig(
        state.value?.copyWith(
          firstLaunch: false,
        ),
      );

  Future<void> updateTheme({required bool isDark}) => updateConfig(
        state.value?.copyWith(
          isDark: isDark,
        ),
      );

  Future<void> updateVerion(String newVersion) => updateConfig(
        state.value?.copyWith(
          version: newVersion,
        ),
      );
}
