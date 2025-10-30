import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/logs.dart';
import '../models/config_model.dart';
import '../repositories/app_repository.dart';

class ConfigModelHolder extends AsyncNotifier<ConfigModel> {
  final AppRepository _repository;

  ConfigModelHolder({
    required AppRepository repository,
  }) : _repository = repository;

  @override
  FutureOr<ConfigModel> build() => _repository.getConfig();

  ConfigModel? get dataOrNull => state.maybeWhen(
        data: (data) => data,
        orElse: () => null,
      );

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> updateConfig(ConfigModel newConfig) async {
    state = AsyncValue.data(newConfig);

    try {
      await _repository.updateConfig(newConfig);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении конфига: $e');
    }
  }
}
