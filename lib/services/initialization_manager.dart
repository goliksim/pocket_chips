import 'dart:async';

import 'package:flutter/material.dart';

import '../app/navigation/navigation_manager.dart';
import '../domain/model_holders/config_model_holder.dart';
import '../domain/models/config_model.dart';
import 'monitization/purchases/pro_version_manager.dart';

class InitializationManager with ChangeNotifier {
  final ConfigModelHolder _configModelHolder;
  final NavigationManager _navigationManager;
  final ProVersionManager _proVersionManager;

  bool isInitialized = false;

  InitializationManager({
    required ConfigModelHolder configModelHolder,
    required NavigationManager navigationManager,
    required ProVersionManager proVersionManager,
  })  : _configModelHolder = configModelHolder,
        _navigationManager = navigationManager,
        _proVersionManager = proVersionManager {
    init();
  }

  Future<void> init() async {
    final config = await _configModelHolder.build();
    _proVersionManager.restorePurchases();

    await checkFirstLaunch(config).then(
      (pushed) async {
        if (!pushed) {
          await checkForUpdates(config).then(
            (pushed) async {
              if (pushed) {
                await Future.delayed(Duration(milliseconds: 500));
              }
            },
          );
        } else {
          await Future.delayed(Duration(milliseconds: 500));
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

      await showUpdateInfo(currentVersion);
      return true;
    }

    return false;
  }

  Future<bool> checkFirstLaunch(ConfigModel config) async {
    final firstLaunch = config.firstLaunch;

    if (firstLaunch) {
      await showAboutInfo();

      return true;
    }

    return false;
  }

  Future<void> showUpdateInfo(String version) =>
      _navigationManager.showUpdateDialog(version);

  Future<void> showAboutInfo() => _navigationManager.showAboutDialog(
        canPop: false,
      );
}
