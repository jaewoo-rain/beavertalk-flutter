// 참여 코드 화면 — **설정이 빠져도 얼어붙지 않는다.**
//
// 2026-09-09 iOS 실기기 사고: 맥에서 빌드한 앱의 `.env` 가 교실 서버 분리
// (9/2) 이전 사본이라 `B2B_API_BASE_URL` 만 없었다. 그러면 `b2bDioProvider` 가
// [StateError] 를 던지는데, 화면은 `AppException` 만 잡고 있어 예외가 그대로
// 빠져나갔다. `_busy` 가 true 로 굳어 「다음」 버튼이 영영 꺼졌고, 오류 문구
// 하나 없이 막다른 길이 됐다.
//
// ⛔ 이 테스트는 「예외 종류를 가리지 않고 화면이 되살아나는가」를 지킨다.
//    catch 갈래를 좁히면 여기서 걸린다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/domain/entities/join_preview.dart';
import 'package:beavertalk/features/classroom/domain/repositories/classroom_repository.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/join_code.dart';

/// 첫 호출부터 [StateError] 를 던진다 — 주소가 없는 빌드가 이 모양이다.
class _BrokenRepository implements ClassroomRepository {
  @override
  Future<JoinPreviewResult> previewByCode(String joinCode) async {
    throw StateError('B2B_API_BASE_URL 이 없다.');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('B2B_API_BASE_URL 이 없다.');
}

void main() {
  testWidgets('설정이 빠져 예외가 나도 버튼이 살아나고 안내가 뜬다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          classroomRepositoryProvider.overrideWithValue(_BrokenRepository()),
          // 카드·배너가 같은 리포지토리를 건드리지 않게 막는다.
          myAssignmentsProvider.overrideWith(
            (ref) async => const <ClassroomAssignment>[],
          ),
          myClassroomsProvider.overrideWith(
            (ref) async => const <JoinedClassroom>[],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const JoinCodeScreen(initialCode: 'B5BY7H'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Button).last, warnIfMissed: false);
    await tester.pumpAndSettle();

    // 1) 예외가 화면 밖으로 새지 않는다.
    expect(tester.takeException(), isNull);

    // 2) 버튼이 다시 눌리는 상태로 돌아온다 — 이것이 얼어붙던 자리다.
    final button = tester.widget<Button>(find.byType(Button).last);
    expect(button.disabled, isFalse);

    // 3) 학습자에게 무슨 일이 났는지 문구가 뜬다.
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.hwJoinFailed), findsOneWidget);
  });
}
