import 'package:beavertalk/core/time/device_timezone.dart';
import 'package:flutter_test/flutter_test.dart';

/// 서버는 IANA 가 아닌 `tz` 를 422 로 거절한다(서버 회신 09-29 §3-1). 앱은 모양이 IANA 인
/// 값만 싣고, 아니면 키를 뺀다(`tz_offset_min` 폴백).
void main() {
  test('IANA 모양만 통과', () {
    for (final id in [
      'Asia/Seoul',
      'America/Argentina/Buenos_Aires',
      'America/Port-au-Prince',
      'Etc/GMT+9',
      'Etc/GMT-14',
      'UTC',
      'GMT',
    ]) {
      expect(DeviceTimezone.looksLikeIana(id), isTrue, reason: id);
    }
    for (final id in [
      '',
      'GMT+09:00',
      'KST',
      'Asia/',
      '/Seoul',
      'Asia Seoul',
      '+09:00',
      'asia/seoul;drop',
    ]) {
      expect(DeviceTimezone.looksLikeIana(id), isFalse, reason: id);
    }
  });
}
