import 'dart:async';

import 'package:flutter/material.dart';

import '../app/navigation/navigation_manager.dart';
import '../domain/model_holders/config_model_holder.dart';
import '../domain/model_holders/remote_config_links_holder.dart';
import '../domain/models/config_model.dart';
import '../services/crash_reporting_service.dart';
import '../utils/firebase_flags.dart';
import 'monitization/purchases/pro_version_manager.dart';

class InitializationManager with ChangeNotifier {
  final ConfigModelHolder _configModelHolder;
  final RemoteConfigLinksHolder _remoteConfigLinksHolder;
  final NavigationManager _navigationManager;
  final ProVersionManager _proVersionManager;
  final CrashReportingService _crashReportingService;

  bool isInitialized = false;

  InitializationManager({
    required ConfigModelHolder configModelHolder,
    required RemoteConfigLinksHolder remoteConfigLinksHolder,
    required NavigationManager navigationManager,
    required ProVersionManager proVersionManager,
    required CrashReportingService crashReportingService,
  })  : _configModelHolder = configModelHolder,
        _remoteConfigLinksHolder = remoteConfigLinksHolder,
        _navigationManager = navigationManager,
        _proVersionManager = proVersionManager,
        _crashReportingService = crashReportingService {
    init();
  }

  Future<void> init() async {
    try {
      await _initFirebaseConfig();
      final config = await _configModelHolder.build();
      _proVersionManager.restorePurchases();
      await _runInitializationFlow(config);
    } catch (error, trace) {
      await _crashReportingService.recordError(
        error: error,
        trace: trace,
        reason: 'InitializationManager.init',
      );
    } finally {
      isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _initFirebaseConfig() async {
    if (!kEnableFirebase) {
      return;
    }

    await _remoteConfigLinksHolder.refresh();
  }

  Future<void> _runInitializationFlow(ConfigModel config) async {
    await checkFirstLaunch(config).then(
      (pushed) async {
        if (!pushed) {
          await checkForUpdates(config).then(
            (pushed) async {
              if (pushed) {
                await Future.delayed(const Duration(milliseconds: 500));
              }
            },
          );
        } else {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      },
    );
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
