import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/domain_managers.dart';
import '../utils/theme/themes.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  final Themes theme;

  static Themes of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    if (provider == null) {
      throw FlutterError('ThemeProvider not found in context');
    }
    return provider.theme;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => oldWidget.theme != theme;
}

class AppThemeBuilder extends ConsumerWidget {
  const AppThemeBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, Themes theme) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeManagerProvider);
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    final theme = isDarkMode ? Themes.dark() : Themes.light();

    return ThemeProvider(
      theme: theme,
      child: builder(context, theme),
    );
  }
}
