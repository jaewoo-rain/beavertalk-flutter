// 홈의 전화 버튼은 «자동(auto)» 코스로 건다 — 사장님 결정(2026-09-13).
//
// 서버가 진도로 이번 통화의 코스를 정하고 `call_started.course` 로 알린다. 홈 학습 현황
// 블록의 «이번 통화»(`/cur/me`.`next_course`)와 같은 판정이다. 개발자 도구의 셋째 버튼은
// 그 자리를 옛 «일반 통화(normal)» — call_type 미전송 — 에 내준다.
//
// 세 진입점의 **라우트 인자**를 잠근다. 인자 → `call_loading` → `start(callCourse)` →
// `buildStartFrame` 의 나머지 사슬은 call_start_frame_test 가 잠근다(여기서 한 칸만 더
// 이어 붙여 인자와 와이어 값을 맞춰 본다).
//
// 그리고 한 가지 더 — 통화가 끝나면 학습 현황을 다시 읽는다. 홈은 첫 라우트라 통화 내내
// 살아 있어 autoDispose 가 안 걸리고, 그러면 «이번 통화» 가 옛 값을 보여 준다.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/home.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';

/// 진도 조회만 답한다(횟수를 센다). 나머지는 이 시험에 없다.
class _FakeRepo implements NormalcallRepository {
  int curMeCalls = 0;

  @override
  Future<CurMe> getCurMe() async {
    curMeCalls++;
    return CurMe.fromJson({
      'lesson': {'no': 1, 'code': 'A1-T01-1', 'level_no': 1},
      'status': 'learning',
      'items_total': 18,
      'items_drilled': 2,
      'open': {'expression': true, 'freetalk': false},
      'next_course': 'expression',
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

/// 상태를 밖에서 밀어 넣을 수 있는 컨트롤러 — 통화 종료 전이를 흉내낸다.
class _StubCallController extends NormalCallController {
  @override
  CallState build() => const CallState();

  void emit(CallState s) => state = s;
}

/// permission_handler 를 «허용» 으로 목한다(마이크 = 7, granted = 1).
void _grantMic() {
  const ch = MethodChannel('flutter.baseflow.com/permissions/methods');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(ch, (call) async {
    switch (call.method) {
      case 'requestPermissions':
        return <int, int>{7: 1};
      case 'checkPermissionStatus':
        return 1;
      default:
        return null;
    }
  });
  addTearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(ch, null));
}

/// [home] 을 띄우고 named push 를 전부 [pushed] 에 기록한다.
Widget _host(Widget home, List<RouteSettings> pushed, {List<Override> overrides = const []}) =>
    ProviderScope(
      overrides: overrides,
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

void main() {
  testWidgets('홈 전화 버튼 → callLoading 에 CourseCallRequest(auto), force 없음', (tester) async {
    _grantMic();
    final pushed = <RouteSettings>[];
    final repo = _FakeRepo();
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_host(const HomeScreen(), pushed,
        overrides: [normalcallRepositoryProvider.overrideWithValue(repo)]));
    await tester.pump(const Duration(milliseconds: 32));
    tester.takeException(); // 캐릭터 카탈로그 등은 여기서 목이 없다

    await tester.tap(find.bySemanticsLabel(RegExp('통화')).first);
    await tester.pumpAndSettle();

    final call = pushed.where((s) => s.name == Routes.callLoading).toList();
    expect(call, hasLength(1));
    final arg = call.single.arguments;
    expect(arg, isA<CourseCallRequest>());
    final req = arg as CourseCallRequest;
    expect(req.course, CallCourse.auto);
    expect(req.forceCourse, isFalse, reason: '제품 진입점은 잠금을 우회하지 않는다');
    // 인자 → 와이어 한 칸: 이 요청이 start 프레임에서 auto 가 된다.
    expect(
      buildStartFrame(
        aec: const {}, sampleRate: 16000, numChannels: 1,
        callType: req.course.wireValue, forceCourse: req.forceCourse,
      )['call_type'],
      'auto',
    );
  });

  testWidgets('통화가 끝나면 학습 현황(/cur/me)을 다시 읽는다 — 표시와 실제 코스를 맞춘다',
      (tester) async {
    final repo = _FakeRepo();
    final ctrl = _StubCallController();
    final pushed = <RouteSettings>[];
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_host(const HomeScreen(), pushed, overrides: [
      normalcallRepositoryProvider.overrideWithValue(repo),
      normalCallControllerProvider.overrideWith(() => ctrl),
    ]));
    await tester.pump(const Duration(milliseconds: 32));
    tester.takeException();
    final before = repo.curMeCalls;
    expect(before, greaterThan(0), reason: '홈이 처음에 한 번 읽는다');

    // 통화 중 → 끝. 홈은 첫 라우트라 이 사이 계속 살아 있다.
    ctrl.emit(const CallState(phase: CallPhase.inCall));
    await tester.pump();
    expect(repo.curMeCalls, before, reason: '통화 중엔 다시 읽지 않는다');
    ctrl.emit(const CallState(phase: CallPhase.ended));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 32));

    expect(repo.curMeCalls, greaterThan(before),
        reason: '통화가 끝나야 진도가 바뀌고, 그때 «이번 통화» 를 다시 정해야 한다');
  });

  group('개발자 도구 세 버튼의 라우트 인자', () {
    Future<List<RouteSettings>> pumpAndTap(WidgetTester tester, String title) async {
      final pushed = <RouteSettings>[];
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_host(const MyPageScreen(), pushed,
          overrides: [normalcallRepositoryProvider.overrideWithValue(_FakeRepo())]));
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException();
      await tester.ensureVisible(find.text(title));
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      return pushed.where((s) => s.name == Routes.callLoading).toList();
    }

    testWidgets('«일반 통화 (normal)» — 인자 없음 = call_type 키 없음', (tester) async {
      final call = await pumpAndTap(tester, '일반 통화 (normal)');
      expect(call, hasLength(1));
      expect(call.single.arguments, isNull);
      expect(
        buildStartFrame(aec: const {}, sampleRate: 16000, numChannels: 1)
            .containsKey('call_type'),
        isFalse,
        reason: '서버 D11 이 라우팅한다',
      );
      expect(find.text('자동 통화 (auto)'), findsNothing, reason: 'auto 는 홈으로 갔다');
    });

    testWidgets('«표현학습 통화» — 무변경: CallCourse.expression', (tester) async {
      final call = await pumpAndTap(tester, '표현학습 통화');
      expect(call.single.arguments, CallCourse.expression);
    });

    testWidgets('«프리토킹 통화» — 무변경: freetalk + QA 우회', (tester) async {
      final call = await pumpAndTap(tester, '프리토킹 통화');
      final req = call.single.arguments as CourseCallRequest;
      expect(req.course, CallCourse.freetalk);
      expect(req.forceCourse, isTrue);
    });
  });
}
