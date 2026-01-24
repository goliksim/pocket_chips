import '../../../app/navigation/navigation_manager.dart';
import '../../../utils/logs.dart';
import 'event_handler.dart';

class DonationHandler implements EventHandler {
  static const _cooldown = Duration(minutes: 25);
  DateTime? _lastShowTime;

  final NavigationManager _navigationManager;

  DonationHandler({
    required NavigationManager navigationManager,
  }) : _navigationManager = navigationManager {
    // The first showing after 15 minutes after first launch
    _lastShowTime = DateTime.now().subtract(Duration(minutes: 10));
  }

  @override
  EventType get type => EventType.donation;

  @override
  bool isReady() {
    final isReady = _lastShowTime == null ||
        DateTime.now().difference(_lastShowTime!) > _cooldown;

    if (isReady) {
      return true;
    }
    final nextShowTime = _lastShowTime!.add(_cooldown);
    final left = nextShowTime.difference(DateTime.now()).inSeconds;

    logs.writeLog('DonationHandler is not ready, $left seconds left');

    return false;
  }

  @override
  Future<void> show() {
    _navigationManager.showDonationDialog(isTriggered: true);
    _lastShowTime = DateTime.now();
    return Future.value();
  }
}
