import 'dart:async';

import 'package:flutter/material.dart';

import '../app/navigation/navigation_manager.dart';
import '../domain/model_holders/config_model_holder.dart';
import '../domain/models/config_model.dart';

class InitializationManager with ChangeNotifier {
  final ConfigModelHolder _configModelHolder;
  final NavigationManager _navigationManager;

  bool isInitialized = false;

  InitializationManager({
    required ConfigModelHolder configModelHolder,
    required NavigationManager navigationManager,
  })  : _configModelHolder = configModelHolder,
        _navigationManager = navigationManager {
    init();
  }

  Future<void> init() async {
    final config = await _configModelHolder.build();

    await checkFirstLaunch(config).then(
      (pushed) async {
        if (!pushed) {
          await checkForUpdates(config);
        }
      },
    );

    isInitialized = true;
    notifyListeners();
  }

  Future<bool> checkForUpdates(ConfigModel config) async {
    final lastVersion = config.version;
    final currentVersion = await _configModelHolder.getCurrentVersion();

    if (currentVersion.compareTo(lastVersion) > 0) {
      _configModelHolder.updateVerion(currentVersion);

      showUpdateInfo();
      return true;
    }

    return false;
  }

  Future<bool> checkFirstLaunch(ConfigModel config) async {
    final firstLaunch = config.firstLaunch;

    if (firstLaunch) {
      showAboutInfo();

      return true;
    }

    return false;
  }

  void showUpdateInfo() => _navigationManager.showUpdateDialog();

  void showAboutInfo() => _navigationManager.showAboutDialog(
        canPop: false,
      );
}
