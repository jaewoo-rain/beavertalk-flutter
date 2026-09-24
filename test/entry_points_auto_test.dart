// 제품 진입점은 전부 «자동(auto)» 코스로 건다 — 사장님 결정(2026-09-13).
//
// 홈 전화 버튼(home_auto_call_test)에 이어 나머지 셋: 온보딩 완료 「레벨 테스트」 ·
// 기록 빈 화면 「통화 시작」 · 기록 목록 빈 상태 CTA. 셋 다 CourseCallRequest(auto),
// force 없음, plan 없음. 옛 경로(call_type 미전송)는 이제 개발자 도구 «일반 통화» 와
// 수신·레벨테스트만 쓴다.
//
// 그리고 개발자 도구 «Max/Free 로 통화» 두 버튼의 라우트 인자 — auto + plan_override.
// 인자 → start 프레임의 사슬은 call_start_frame_test 가 잠근다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/onboarding/onboarding_done.dart';
import 'package:beavertalk/screens/record/record_empty.dart';
import 'package:beavertalk/screens/record/record_list.dart';

class _FakeRepo implements NormalcallRepository {
  @override
  Future<List<CallSummary>> listCalls({int? limit, int? offset}) async => const [];

  @override
  Future<CurMe> getCurMe() async => CurMe.fromJson({
        'lesson': {'no': 1, 'code': 'A1-T01-1', 'level_no': 1},
        'status': 'learning',
        'items_total': 18,
        'items_drilled': 0,
        'open': {'expression': true, 'freetalk': false},
        'next_course': 'expression',
      });

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

/// [home] 을 띄우고 named push 를 [pushed] 에 기록한다.
Widget _host(Widget home, List<RouteSettings> pushed) => ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(_FakeRepo())],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
        onGenerateRoute: (settings) {
          pushed.add(settings);
          return MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink());
        },
      ),
    );

Future<List<RouteSettings>> _tapAndCollect(
  WidgetTester tester,
  Widget screen,
  String buttonText, {
  Size size = const Size(375, 812),
}) async {
  final pushed = <RouteSettings>[];
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_host(screen, pushed));
  await tester.pump(const Duration(milliseconds: 32));
  await tester.pump(const Duration(milliseconds: 32));
  tester.takeException();
  await tester.ensureVisible(find.text(buttonText));
  await tester.tap(find.text(buttonText));
  await tester.pumpAndSettle();
  return pushed.where((s) => s.name == Routes.callLoading).toList();
}

void _expectAuto(List<RouteSettings> call) {
  expect(call, hasLength(1));
  final req = call.single.arguments;
  expect(req, isA<CourseCallRequest>());
  final r = req as CourseCallRequest;
  expect(r.course, CallCourse.auto);
  expect(r.forceCourse, isFalse, reason: '제품 진입점은 잠금을 우회하지 않는다');
  expect(r.planOverride, isNull, reason: '제품 진입점은 플랜을 강제하지 않는다');
}

void main() {
  group('제품 진입점 3곳 → auto', () {
    // 09-24 버튼 문구 「레벨 테스트」(사용자 지시 · P30 번복). 요청은 그대로 auto — 가입 직후
    // 회원은 레벨이 없어 서버가 레벨테스트로 라우팅한다.
    testWidgets('온보딩 완료 「레벨 테스트」', (tester) async {
      final call = await _tapAndCollect(tester, const OnboardingDoneScreen(), '레벨 테스트하기');
      _expectAuto(call);
    });

    testWidgets('기록 빈 화면 「통화 시작」', (tester) async {
      final call = await _tapAndCollect(tester, const RecordEmptyScreen(), '통화 시작');
      _expectAuto(call);
    });

    testWidgets('기록 목록 빈 상태 CTA 「통화 시작」', (tester) async {
      final call = await _tapAndCollect(tester, const RecordListScreen(), '통화 시작');
      _expectAuto(call);
    });
  });

  group('개발자 도구 «플랜 × 코스» 4칸', () {
    // 사장님 지시(2026-09-19): 옛 «Max 로 통화 / Free 로 통화» 2개를 6개로 대체 → 09-23 Premium·Free 4칸.
    // 한 칸이 세 값을 싣는다 — plan_override · call_type(명시) · force_course(프리토킹만).
    // ⛔ 여기 문안은 화면의 칸 이름 그대로다. 라벨을 바꾸면 이 시험이 먼저 빨간불을 낸다.
    Future<CourseCallRequest> tap(WidgetTester tester, String label) async {
      final call = await _tapAndCollect(tester, const MyPageScreen(), label,
          size: const Size(375, 2400));
      expect(call, hasLength(1), reason: '한 번 눌렀으면 한 번만 간다');
      return call.single.arguments as CourseCallRequest;
    }

    testWidgets('Premium · 표현학습 — premium + expression, force 없음', (tester) async {
      final r = await tap(tester, 'Premium · 표현학습');
      expect(r.planOverride, PlanOverride.premium);
      expect(r.course, CallCourse.expression);
      expect(r.forceCourse, isFalse, reason: '표현학습은 원래 안 잠긴다');
    });

    testWidgets('Premium · 프리토킹 — premium + freetalk + force', (tester) async {
      final r = await tap(tester, 'Premium · 프리토킹');
      expect(r.planOverride, PlanOverride.premium);
      expect(r.course, CallCourse.freetalk);
      expect(r.forceCourse, isTrue, reason: '그 차시 표현학습이 안 끝나도 열려야 한다');
    });

    testWidgets('Free · 표현학습 — free + expression, force 없음', (tester) async {
      final r = await tap(tester, 'Free · 표현학습');
      expect(r.planOverride, PlanOverride.free);
      expect(r.course, CallCourse.expression);
      expect(r.forceCourse, isFalse);
    });

    testWidgets('Free · 프리토킹 — free + freetalk + force', (tester) async {
      final r = await tap(tester, 'Free · 프리토킹');
      expect(r.planOverride, PlanOverride.free);
      expect(r.course, CallCourse.freetalk);
      expect(r.forceCourse, isTrue);
    });

    testWidgets('옛 두 버튼은 사라졌다', (tester) async {
      final pushed = <RouteSettings>[];
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_host(const MyPageScreen(), pushed));
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException();

      expect(find.text('Max 로 통화'), findsNothing);
      expect(find.text('Free 로 통화'), findsNothing);
    });

    testWidgets('다른 버튼엔 plan 없음 — 일반 통화는 인자 자체가 없다', (tester) async {
      final call = await _tapAndCollect(tester, const MyPageScreen(), '일반 통화 (normal)',
          size: const Size(375, 2400));
      expect(call.single.arguments, isNull);
    });
  });
}
