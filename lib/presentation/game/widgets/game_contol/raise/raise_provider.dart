import 'package:flutter/material.dart';

class RaiseProviderScope extends StatefulWidget {
  const RaiseProviderScope({
    super.key,
    required this.child,
    required this.currentBet,
  });

  final Widget child;
  final int currentBet;

  @override
  State<RaiseProviderScope> createState() => RaiseProviderScopeState();

  static RaiseProviderScopeState of(BuildContext context) {
    final state = context.findAncestorStateOfType<RaiseProviderScopeState>();
    assert(state != null, 'No RaiseProviderScope found in context');
    return state!;
  }
}

class RaiseProviderScopeState extends State<RaiseProviderScope> {
  late int _currentBet;
  int get currentBet => _currentBet;

  void changeBet(int value) {
    setState(() {
      _currentBet = value;
    });
  }

  @override
  void initState() {
    _currentBet = widget.currentBet;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RaiseProviderScope oldWidget) {
    _currentBet = widget.currentBet;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CurrentBetValueProvider(
      currentBet: _currentBet,
      child: widget.child,
    );
  }
}

class CurrentBetValueProvider extends InheritedWidget {
  final int currentBet;

  const CurrentBetValueProvider({
    required this.currentBet,
    required super.child,
    super.key,
  });

  static CurrentBetValueProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CurrentBetValueProvider>();
    assert(provider != null, 'No RaiseProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(CurrentBetValueProvider oldWidget) {
    return currentBet != oldWidget.currentBet;
  }
}
