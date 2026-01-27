import 'package:flutter/material.dart';

class RaiseProviderScope extends StatefulWidget {
  const RaiseProviderScope({
    super.key,
    required this.child,
    required this.additionalBet,
  });

  final Widget child;
  final int additionalBet;

  @override
  State<RaiseProviderScope> createState() => RaiseProviderScopeState();

  static RaiseProviderScopeState of(BuildContext context) {
    final state = context.findAncestorStateOfType<RaiseProviderScopeState>();
    assert(state != null, 'No RaiseProviderScope found in context');
    return state!;
  }
}

class RaiseProviderScopeState extends State<RaiseProviderScope> {
  late int _additionalBet;
  int get additionalBet => _additionalBet;

  void changeBet(int value) {
    setState(() {
      _additionalBet = value;
    });
  }

  @override
  void initState() {
    _additionalBet = widget.additionalBet;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RaiseProviderScope oldWidget) {
    _additionalBet = widget.additionalBet;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => NewBetValueProvider(
        additionalBet: _additionalBet,
        child: widget.child,
      );
}

class NewBetValueProvider extends InheritedWidget {
  final int additionalBet;

  const NewBetValueProvider({
    required this.additionalBet,
    required super.child,
    super.key,
  });

  static NewBetValueProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<NewBetValueProvider>();
    assert(provider != null, 'No RaiseProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(NewBetValueProvider oldWidget) =>
      additionalBet != oldWidget.additionalBet;
}
