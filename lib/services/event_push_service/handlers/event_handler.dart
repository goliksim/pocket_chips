enum EventType {
  advertisement,
  donation,
}

abstract interface class EventHandler {
  EventType get type;

  bool isReady();
  Future<void> show();
}
