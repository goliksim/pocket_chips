import 'dart:async';

import '../../../utils/logs.dart';

/// Shared retry policy for services that need cooldown-gated retries
/// and escalating delays between automatic retry attempts.
mixin RetryPolicyMixin {
  static const List<Duration> _defaultRetryDelays = [
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(minutes: 30),
  ];

  Timer? _retryTimer;
  int _retryAttempt = 0;
  DateTime? _lastAttemptAt;

  /// Delays used for automatic retries after consecutive failures.
  ///
  /// Implementers can override this to provide a custom backoff sequence.
  List<Duration> get autoRetryDelays => _defaultRetryDelays;

  /// Minimum allowed time between two retry attempts triggered externally.
  Duration get retryCooldown;

  /// Whether an automatic retry timer is currently scheduled.
  bool get hasScheduledRetry => _retryTimer?.isActive ?? false;

  /// Returns `true` when the last started retry attempt is still within
  /// [retryCooldown] and the caller should skip a new attempt.
  bool isRetryOnCooldown({
    required String logName,
    required String reason,
  }) {
    final lastAttemptAt = _lastAttemptAt;
    if (lastAttemptAt == null) {
      return false;
    }

    final isOnCooldown =
        DateTime.now().difference(lastAttemptAt) < retryCooldown;
    if (isOnCooldown) {
      logs.writeLog('$logName skip retry due to cooldown, reason: $reason');
    }

    return isOnCooldown;
  }

  /// Marks the current moment as the start of a retry attempt.
  ///
  /// This timestamp is used by [isRetryOnCooldown] to suppress too-frequent
  /// retries from manual or lifecycle-driven triggers.
  void markRetryStarted() {
    _lastAttemptAt = DateTime.now();
  }

  /// Schedules the next automatic retry using the current backoff step.
  ///
  /// If a retry is already scheduled, the call is ignored.
  void scheduleRetry({
    required String logName,
    required void Function() action,
  }) {
    if (hasScheduledRetry) {
      return;
    }

    final delay = autoRetryDelays[_retryAttempt];
    logs.writeLog('$logName schedule retry in ${delay.inMinutes} minutes');
    _retryTimer = Timer(delay, action);

    if (_retryAttempt < autoRetryDelays.length - 1) {
      _retryAttempt += 1;
    }
  }

  /// Clears accumulated backoff state after a successful recovery.
  ///
  /// This also cancels any pending automatic retry.
  void resetRetryPolicy() {
    _retryAttempt = 0;
    cancelScheduledRetry();
  }

  /// Cancels the currently scheduled automatic retry without resetting
  /// the accumulated backoff step.
  void cancelScheduledRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }
}
