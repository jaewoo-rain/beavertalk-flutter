// 개발자 도구 「내 배운 기록 삭제」 — `POST /__dev/cur-reset`.
//
// 파괴적 버튼이라 세 가지를 잠근다: 취소하면 **호출이 0** 이어야 하고, 삭제하면 **정확히
// 1번** 호출되고 결과가 스낵바로 보여야 하며, 403(`ADMIN_ONLY` — user 계정)이면 서버
// 문구가 그대로 스낵바에 떠야 한다(앱 문구로 뭉개면 원인을 못 본다).
//
// 서버 계약(main.py dev_cur_reset, origin/dev): 루트 경로 `/__dev/cur-reset` ·
// `CurrentAdmin` · body {} · 200 {member_id, lesson:{no,code}, deleted_calls}.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/core/network/env.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';

/// 리셋과 진도 조회만 진짜로 답하고 나머지는 [noSuchMethod] 로 막는다
/// (`join_code_setup_failure_test` 와 같은 관례).
class _FakeRepo implements NormalcallRepository {
  _FakeRepo({this.failWith});

  final Object? failWith;
  int resetCalls = 0;
  int curMeCalls = 0;

  @override
  Future<CurResetResult> resetCurriculum() async {
    resetCalls++;
    if (failWith != null) throw failWith!;
    return const CurResetResult(
      memberId: 7,
      lessonNo: 1,
      lessonCode: 'A1-T01-1',
      deletedCalls: 3,
    );
  }

  @override
  Future<CurMe> getCurMe() async {
    curMeCalls++;
    return CurMe.fromJson({
      'lesson': {'no': 1, 'code': 'A1-T01-1', 'level_no': 1},
      'status': 'learning',
      'items_total': 18,
      'items_drilled': 0,
      'open': {'expression': true, 'freetalk': false},
      'next_course': 'expression',
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

Widget _host(_FakeRepo repo) => ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyPageScreen(),
      ),
    );

Future<void> _pumpToButton(WidgetTester tester, _FakeRepo repo) async {
  tester.view.physicalSize = const Size(375, 2400); // 개발자 카드는 스크롤 맨 아래
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_host(repo));
  await tester.pump(const Duration(milliseconds: 32));
  tester.takeException(); // 다른 카드의 프로바이더는 여기서 목이 없다 — 이 줄만 본다
  await tester.ensureVisible(find.text('내 배운 기록 삭제'));
  await tester.pump();
}

final _button = find.text('내 배운 기록 삭제');

void main() {
  // betatest 브랜치는 마이페이지 개발자 도구를 기본으로 가린다(09-26 사용자 지시) —
  // 이 시험은 개발자 도구를 눌러 확인하므로 켠다.
  setUpAll(() => debugShowMyPageDevTools = true);
  tearDownAll(() => debugShowMyPageDevTools = false);
  test('Env.stripApiPrefix — /api/v1 을 뗀 루트가 /__dev/* 가 붙는 자리다', () {
    // 서버 main.py 가 라우터 밖 `@app.post("/__dev/…")` 로 열어 API_PREFIX 를 안 탄다.
    // (`Env.apiRootUrl` 은 dotenv 를 읽어 순수 시험이 안 된다 — 잘라내기만 여기서 잠근다.)
    expect(Env.stripApiPrefix('https://h.run.app/api/v1'), 'https://h.run.app');
    expect(Env.stripApiPrefix('http://10.0.2.2:8000/api/v1'), 'http://10.0.2.2:8000');
    expect(Env.stripApiPrefix('https://h.run.app'), 'https://h.run.app',
        reason: '접두사가 없으면 그대로');
  });

  testWidgets('다이얼로그에서 취소하면 호출이 0 이다', (tester) async {
    final repo = _FakeRepo();
    await _pumpToButton(tester, repo);

    await tester.tap(_button);
    await tester.pumpAndSettle();
    expect(find.text('배운 기록을 지울까요?'), findsOneWidget, reason: '확인을 거친다');

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(repo.resetCalls, 0, reason: '취소는 아무것도 지우지 않는다');
    expect(find.text('배운 기록을 지울까요?'), findsNothing);
  });

  testWidgets('삭제하면 정확히 1번 호출하고 «차시 A1-T01-1 부터 다시 시작» 스낵바 + 진도 새로고침',
      (tester) async {
    final repo = _FakeRepo();
    await _pumpToButton(tester, repo);
    final curMeBefore = repo.curMeCalls;

    await tester.tap(_button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();

    expect(repo.resetCalls, 1);
    expect(find.text('차시 A1-T01-1 부터 다시 시작'), findsOneWidget);
    expect(repo.curMeCalls, greaterThan(curMeBefore),
        reason: '성공하면 curMeProvider 를 무효화해 진도 한 줄을 다시 읽는다');
  });

  testWidgets('403 ADMIN_ONLY — 서버 문구가 그대로 스낵바에 뜬다', (tester) async {
    // dio 매퍼가 403 + detail.message 를 ForbiddenFailure.server 로 올린다.
    final repo = _FakeRepo(
      failWith: const ForbiddenFailure.server('관리자 전용 기능입니다.'),
    );
    await _pumpToButton(tester, repo);

    await tester.tap(_button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();

    expect(repo.resetCalls, 1);
    expect(find.text('관리자 전용 기능입니다.'), findsOneWidget,
        reason: '앱 문구로 바꾸면 「왜 안 되나」 를 못 본다');
    expect(find.text('내 배운 기록 삭제'), findsOneWidget, reason: '버튼이 다시 살아난다');
  });
}
