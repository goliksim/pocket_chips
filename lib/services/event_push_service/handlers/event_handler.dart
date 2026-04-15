enum EventType {
  advertisement,
  donation,
}

abstract interface class EventHandler {
  EventType get type;

  Future<bool> isReady();
  Future<void> show();
}
