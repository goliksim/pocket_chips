import 'dart:async';

import 'handlers/event_handler.dart';

class PromotionManager {
  final List<EventHandler> _handlers;

  PromotionManager({
    required List<EventHandler> handlers,
  }) : _handlers = handlers;

  Future<void> maybeShowPromotion({
    List<EventType>? types,
    Duration? delay,
  }) async {
    // Order of handlers set in list order
    final handlersToCheck = (types == null || types.isEmpty)
        ? _handlers
        : _handlers.where((h) => types.contains(h.type)).toList();

    for (final handler in handlersToCheck) {
      if (await handler.isReady()) {
        if (delay != null) {
          await Future.delayed(delay);
        }

        await handler.show();
        return;
      }
    }
  }
}
