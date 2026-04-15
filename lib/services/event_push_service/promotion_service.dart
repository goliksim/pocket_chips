import 'dart:async';

import '../../utils/logs.dart';
import 'handlers/event_handler.dart';

class PromotionManager {
  final List<EventHandler> _handlers;
  bool _isProcessing = false;

  PromotionManager({
    required List<EventHandler> handlers,
  }) : _handlers = handlers;

  Future<void> maybeShowPromotion({
    List<EventType>? types,
    Duration? delay,
  }) async {
    if (_isProcessing) return;
    logs.writeLog('PromotionManager: maybeShowPromotion with delay $delay');

    final handlersToCheck = (types == null || types.isEmpty)
        ? _handlers
        : _handlers.where((h) => types.contains(h.type)).toList();

    for (final handler in handlersToCheck) {
      if (await handler.isReady()) {
        _isProcessing = true;

        try {
          if (delay != null) {
            await Future.delayed(delay);
          }

          await handler.show();
        } finally {
          _isProcessing = false;
        }
        return;
      }
    }
  }
}
