import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../services/crash_reporting_service.dart';
import '../../utils/logs.dart';
import '../models/config_model.dart';

class ConfigModelHolder extends AsyncNotifier<ConfigModel> {
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  @override
  FutureOr<ConfigModel> build() => ref.read(appRepositoryProvider).getConfig();

  static Future<String> getCurrentVersion() async {
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
    } catch (error, trace) {
      logs.writeLog('Saving config error: $error');

      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'ConfigModelHolder.updateConfig',
        ),
      );
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
