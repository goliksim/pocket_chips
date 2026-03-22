import 'package:flutter/widgets.dart';

mixin AppResumeListenerMixin {
  AppLifecycleListener? _appLifecycleListener;

  VoidCallback get onAppResumed;

  void initAppResumeListener() {
    _appLifecycleListener ??= AppLifecycleListener(
      onResume: onAppResumed,
    );
  }

  void disposeAppResumeListener() {
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;
  }
}
