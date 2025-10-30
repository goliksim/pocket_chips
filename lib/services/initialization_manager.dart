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
    await checkFirstLaunch().then(
      (pushed) async {
        if (!pushed) {
          await checkForUpdates();
        }
      },
    );

    isInitialized = true;
    notifyListeners();
  }

  Future<bool> checkForUpdates() async {
    final lastVersion = _configModelHolder.dataOrNull?.version;
    final currentVersion = await _configModelHolder.getCurrentVersion();

    if (lastVersion == null || currentVersion.compareTo(lastVersion) > 0) {
      _configModelHolder.updateConfig(
        _configModelHolder.dataOrNull?.copyWith(
              version: currentVersion,
              firstLaunch: false,
            ) ??
            ConfigModel.defaults(currentVersion),
      );

      showUpdateInfo();
      return true;
    }

    return false;
  }

  Future<bool> checkFirstLaunch() async {
    final firstLaunch = _configModelHolder.dataOrNull?.firstLaunch;
    final currentVersion = await _configModelHolder.getCurrentVersion();

    if (firstLaunch ?? true) {
      _configModelHolder.updateConfig(
        _configModelHolder.dataOrNull?.copyWith(
              firstLaunch: false,
            ) ??
            ConfigModel.defaults(currentVersion),
      );

      return true;
    }

    return false;
  }

  void showUpdateInfo() => _navigationManager.showUpdateDialog();

  void showAboutInfo() => _navigationManager.showAboutDialog(
        canPop: false,
      );
}
