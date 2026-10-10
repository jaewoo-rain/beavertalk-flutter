import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

/// 서버 `premium` 브랜치(09-23) §4 — WS error 코드 두 개는 앱 문구로 바꾼다.
void main() {
  final l10n = AppLocalizationsEn();

  test('DAILY_LIMIT → 오늘 학습 시간 소진 문구(서버 문구를 쓰지 않는다)', () {
    expect(
      serverErrorMessage(
          {'type': 'error', 'code': 'DAILY_LIMIT', 'message': 'budget'}, l10n),
      l10n.callDailyLimit,
    );
  });

  test('ALREADY_IN_CALL → 이미 통화 중 문구', () {
    expect(
      serverErrorMessage({'type': 'error', 'code': 'ALREADY_IN_CALL'}, l10n),
      l10n.callAlreadyInCall,
    );
  });

  test('그 밖의 코드는 서버 문구 그대로, 없으면 일반 오류', () {
    expect(serverErrorMessage({'code': 'X', 'message': 'raw'}, l10n), 'raw');
    expect(serverErrorMessage({'code': 'X'}, l10n), l10n.callErrorGeneric);
  });
}
