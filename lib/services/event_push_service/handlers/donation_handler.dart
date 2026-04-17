import '../../../app/navigation/navigation_manager.dart';
import '../../../utils/logs.dart';
import 'event_handler.dart';

class DonationHandler implements EventHandler {
  static const _cooldown = Duration(minutes: 25);
  DateTime? _lastShowTime;

  final NavigationManager _navigationManager;
  final Future<bool> Function() _isPurchasesReady;

  DonationHandler({
    required NavigationManager navigationManager,
    required Future<bool> Function() isPurchasesReady,
  })  : _navigationManager = navigationManager,
        _isPurchasesReady = isPurchasesReady {
    // The first showing after 15 minutes after first launch
    _lastShowTime = DateTime.now().subtract(Duration(minutes: 10));
  }

  @override
  EventType get type => EventType.donation;

  @override
  Future<bool> isReady() async {
    final isTimeReady = _lastShowTime == null ||
        DateTime.now().difference(_lastShowTime!) > _cooldown;

    if (!isTimeReady) {
      final nextShowTime = _lastShowTime!.add(_cooldown);
      final left = nextShowTime.difference(DateTime.now()).inSeconds;

      logs.writeLog('DonationHandler is not ready, $left seconds left');
      return false;
    }

    logs.writeLog('DonationHandler is ready, checking purchases');
    return _isPurchasesReady();
  }

  @override
  Future<void> show() {
    _navigationManager.showDonationDialog(isTriggered: true);
    _lastShowTime = DateTime.now();
    return Future.value();
  }
}
