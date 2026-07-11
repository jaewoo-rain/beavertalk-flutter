import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../mock/mock_data.dart';
import '../../alarm/domain/entities/alarm.dart';

/// Mirrors the member's alarms to the native `AlarmManager` (see
/// `AlarmReceiver.kt`) so a learning-reminder call fires **even when the app is
/// killed** — the in-app [InboundCallScheduler] only runs while the app is
/// alive. Android only; a no-op elsewhere.
class NativeAlarmScheduler {
  static const _channel = MethodChannel('beavertalk/alarm_scheduler');

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Pushes the full active-alarm set to the OS scheduler (replaces any prior
  /// schedule). Called on every alarm-list change. Never throws.
  Future<void> sync(List<Alarm> alarms) async {
    if (!_supported) return;
    final active = alarms.where(
      (a) => a.active && a.id != null && a.days.any((d) => d),
    );
    final payload = jsonEncode([
      for (final a in active)
        {
          'id': a.id,
          'hour': a.hour24,
          'minute': a.minute,
          'days': a.days,
          'characterId': a.characterId,
          'name': a.characterName ?? characterName(a.characterId),
          'avatar': a.imageUrl ?? '',
        },
    ]);
    try {
      await _channel.invokeMethod<bool>('syncAlarms', {'alarms': payload});
    } catch (e) {
      debugPrint('native alarm sync failed: $e');
    }
  }

  /// Whether exact alarms can be scheduled (Android 12+ gates this behind a
  /// permission; pre-12 always true). Inexact scheduling is the fallback.
  Future<bool> canScheduleExact() async {
    if (!_supported) return false;
    try {
      return await _channel.invokeMethod<bool>('canScheduleExact') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Opens the OS "Alarms & reminders" permission screen (Android 12+).
  Future<void> requestExactPermission() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('requestExactPermission');
    } catch (_) {}
  }
}
