import 'package:flutter/material.dart';

class CurrentBetValueProvider extends InheritedWidget {
  int currentBet;

  CurrentBetValueProvider({
    super.key,
    required this.currentBet,
    required super.child,
  });

  static CurrentBetValueProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CurrentBetValueProvider>();
    assert(provider != null, 'No RaiseProvider found in context');
    return provider!;
  }

  void changeBet(int value) {
    currentBet = value;
  }

  @override
  bool updateShouldNotify(CurrentBetValueProvider oldWidget) {
    return currentBet != oldWidget.currentBet;
  }
}
