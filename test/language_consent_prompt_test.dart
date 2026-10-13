// 모국어 공개 재동의 · 처리방침 개정 안내(PM-DEC-543 · 시행 2026-10-20).
//
// - 10-13 전 동의 화면(모국어 비공개)으로 들어온 학습자에게 반 화면 진입 때 한 번 묻는다.
// - '동의' 만 서버에 남기고, '동의 안 함' 은 아무것도 보내지 않는다 — 반은 그대로 쓴다.
// - 이미 새 화면으로 동의한 학습자에게는 개정 안내만 한 번 띄운다.
// - 서버가 동의 버전을 안 주면(옛 서버) 아무것도 띄우지 않는다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beavertalk/features/classroom/data/datasources/classroom_consent_store.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/domain/language_share.dart';
import 'package:beavertalk/features/classroom/domain/repositories/classroom_repository.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/assignment_list.dart';

JoinedClassroom _room(int id, {int? version, bool reports = true}) =>
    JoinedClassroom(
      classroomId: id,
      name: 'TOPIK 1 A',
      languageShareVersion: version,
      reportsLanguageShare: reports,
    );

class _ConsentRepository implements ClassroomRepository {
  final calls = <(int, int)>[];

  @override
  Future<void> setLanguageConsent(int classroomId, int version) async =>
      calls.add((classroomId, version));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<_ConsentRepository> _pump(
  WidgetTester tester,
  List<JoinedClassroom> rooms, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final repo = _ConsentRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        classroomRepositoryProvider.overrideWithValue(repo),
        myAssignmentsProvider.overrideWith(
          (ref) async => const <ClassroomAssignment>[],
        ),
        myClassroomsProvider.overrideWith((ref) async => rooms),
      ],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AssignmentListScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  group('pickClassroomConsentPrompt', () {
    test('옛 서버(칸 없음)면 아무것도 띄우지 않는다', () {
      final p = pickClassroomConsentPrompt(
        [_room(1, reports: false)],
        answered: const {},
        noticeSeen: false,
      );
      expect(p, isA<NoConsentPrompt>());
    });

    test('옛 동의(null·1) 반에 답하지 않았으면 그 반에 다시 묻는다', () {
      final p = pickClassroomConsentPrompt(
        [_room(1, version: 2), _room(2, version: 1)],
        answered: const {},
        noticeSeen: false,
      );
      expect((p as LanguageReconsentPrompt).classroom.classroomId, 2);
    });

    test('거절로 답한 반은 다시 묻지 않고, 안내도 이미 봤으면 끝이다', () {
      final p = pickClassroomConsentPrompt(
        [_room(1)],
        answered: const {1},
        noticeSeen: true,
      );
      expect(p, isA<NoConsentPrompt>());
    });

    test('새 동의만 있으면 개정 안내만 한 번', () {
      expect(
        pickClassroomConsentPrompt(
          [_room(1, version: kLanguageShareVersion)],
          answered: const {},
          noticeSeen: false,
        ),
        isA<PrivacyNoticePrompt>(),
      );
    });
  });

  test('응답의 language_share_version 칸을 읽고, 칸이 없으면 모른다로 둔다', () {
    final withField = JoinedClassroom.fromJson({
      'classroom_id': 5,
      'name': 'A',
      'language_share_version': null,
    });
    expect(withField.reportsLanguageShare, isTrue);
    expect(withField.languageShareVersion, isNull);
    final v2 = JoinedClassroom.fromJson({
      'classroom_id': 5,
      'name': 'A',
      'language_share_version': 2,
    });
    expect(v2.languageShareVersion, 2);
    final old = JoinedClassroom.fromJson({'classroom_id': 5, 'name': 'A'});
    expect(old.reportsLanguageShare, isFalse);
  });

  testWidgets('옛 동의 반: 동의하면 서버에 v2 를 남기고 다시 묻지 않는다', (tester) async {
    final repo = await _pump(tester, [_room(5)]);
    expect(find.text('선생님에게 모국어를 공유할까요?'), findsOneWidget);

    await tester.tap(find.text('동의'));
    await tester.pumpAndSettle();
    expect(repo.calls, [(5, kLanguageShareVersion)]);
    expect(find.text('선생님에게 모국어를 공유할까요?'), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    final store = ClassroomConsentStore(prefs: prefs);
    expect(await store.answered(), {5});
    expect(await store.noticeSeen(), isTrue);
  });

  testWidgets('옛 동의 반: 거절해도 서버를 부르지 않고 반 화면은 그대로다', (tester) async {
    final repo = await _pump(tester, [_room(5, version: 1)]);
    await tester.tap(find.text('동의 안 함'));
    await tester.pumpAndSettle();
    expect(repo.calls, isEmpty);
    expect(find.text('선생님에게 모국어를 공유할까요?'), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(await ClassroomConsentStore(prefs: prefs).answered(), {5});
  });

  testWidgets('새 동의 반: 개정 안내를 한 번 띄우고 두 번째에는 띄우지 않는다', (tester) async {
    await _pump(tester, [_room(5, version: kLanguageShareVersion)]);
    expect(find.text('개인정보처리방침이 바뀌어요'), findsOneWidget);
    expect(find.textContaining(kPrivacyRevisionDate), findsOneWidget);
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    expect(find.text('개인정보처리방침이 바뀌어요'), findsNothing);

    await _pump(
      tester,
      [_room(5, version: kLanguageShareVersion)],
      prefs: {ClassroomConsentStore.noticeKey: true},
    );
    expect(find.text('개인정보처리방침이 바뀌어요'), findsNothing);
  });

  testWidgets('옛 서버(칸 없음)면 아무것도 띄우지 않는다', (tester) async {
    await _pump(tester, [_room(5, reports: false)]);
    expect(find.text('선생님에게 모국어를 공유할까요?'), findsNothing);
    expect(find.text('개인정보처리방침이 바뀌어요'), findsNothing);
  });
}
