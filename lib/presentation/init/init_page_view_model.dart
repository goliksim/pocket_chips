import 'package:flutter/material.dart';

import '../../app/navigation/models/app_route.dart';
import '../../app/navigation/navigation_manager.dart';
import '../../services/initialization_manager.dart';

class InitPageViewModel extends ValueNotifier<bool> {
  final InitializationManager _initializationManager;
  final NavigationManager _navigationManager;

  InitPageViewModel({
    required NavigationManager navigationManager,
    required InitializationManager initializationManager,
  })  : _initializationManager = initializationManager,
        _navigationManager = navigationManager,
        super(false) {
    _initializationManager.addListener(_completeInitialization);
  }

  void _completeInitialization() {
    if (_initializationManager.isInitialized) {}
  }

  @override
  void dispose() {
    _initializationManager.removeListener(_completeInitialization);

    super.dispose();
  }

  void pushHomePage() => _navigationManager.goTo(AppRoute.menu());
}
