import 'dart:async';

typedef TAction = Future<void> Function();

Future<void> runAction(TAction action) async {
  await action();
}

TAction runTestActions(Iterable<TAction> actions) => () async {
      for (final action in actions) {
        await runAction(action);
      }
    };
