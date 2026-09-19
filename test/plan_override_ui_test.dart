// 플랜 흉내(plan_override) 화면 규칙 — 사장님 지시(2026-09-13).
//
// plan_override=max 는 영상통화 UI(16:9 밴드), free·pro 는 음성 전용(원형 스틸).
// 서버는 이미 override 플랜대로 엔진을 고르므로 **화면만** 그 선택에 맞춘다 — 구독
// 티어가 무엇이든. override 가 없으면 종전대로 구독 티어를 본다.
//
// 그리고 이어하기 조회(`GET /calls/{id}/resume-status`)에 같은 plan_override 를 쿼리로
// 싣는다 — 서버(admin 만)가 그 플랜의 조각 상한으로 can_resume 을 답하게.
//
// 하네스는 call_screen_layout_test 와 같다(고정 CallState 스텁).

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/data/datasources/normalcall_remote_data_source.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';

class _StubCallController extends NormalCallController {
  _StubCallController(this._state);
  final CallState _state;
  @override
  CallState build() => _state;
}

const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);
const _free = SubscriptionStatus(
  state: SubscriptionState.free,
  tier: SubscriptionTier.free,
);

Future<void> _pump(
  WidgetTester tester, {
  required SubscriptionStatus subscription,
  PlanOverride? override,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final state = CallState(
    phase: CallPhase.inCall,
    beaverSubtitle: '안녕하세요.',
    planOverride: override,
  );
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider
            .overrideWith(() => _StubCallController(state)),
        subscriptionStatusProvider.overrideWithValue(subscription),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CallScreen(),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 32));
}

/// 영상통화 밴드는 16:9 [AspectRatio] 로 그려진다. 원형 스틸에는 그것이 없다.
Finder get _videoBand => find.byWidgetPredicate(
      (w) => w is AspectRatio && (w.aspectRatio - 16 / 9).abs() < 1e-6,
    );

/// 이어하기 조회의 **요청 URL** 만 잡는 어댑터.
class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _, Future<void>? _) async {
    last = options;
    return ResponseBody.fromString(
      jsonEncode({'ready': true, 'can_resume': true, 'fragment_count': 1, 'max_fragments': 3}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('영상/음성 UI — override 가 구독 티어를 이긴다', () {
    testWidgets('Free 계정 + Max 강제 → 영상 밴드', (tester) async {
      await _pump(tester, subscription: _free, override: PlanOverride.max);
      expect(_videoBand, findsOneWidget, reason: '서버가 Max 엔진(영상)으로 열었다');
    });

    testWidgets('Max 계정 + Free 강제 → 원형 스틸(영상 없음)', (tester) async {
      await _pump(tester, subscription: _max, override: PlanOverride.free);
      expect(_videoBand, findsNothing, reason: '서버가 Free 엔진(음성)으로 열었다');
    });

    testWidgets('override 없음 — 종전대로 구독 티어: Max 는 영상', (tester) async {
      await _pump(tester, subscription: _max);
      expect(_videoBand, findsOneWidget);
    });

    testWidgets('override 없음 — 종전대로 구독 티어: Free 는 원형', (tester) async {
      await _pump(tester, subscription: _free);
      expect(_videoBand, findsNothing);
    });

    testWidgets('pro 강제는 음성 — 지금 Pro 구독이 그렇듯', (tester) async {
      await _pump(tester, subscription: _max, override: PlanOverride.pro);
      expect(_videoBand, findsNothing);
    });
  });

  group('resume-status 의 plan_override 쿼리', () {
    test('override 통화면 ?plan_override=max 가 붙는다', () async {
      final adapter = _CaptureAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://h.run.app/api/v1'))
        ..httpClientAdapter = adapter;
      await NormalcallRemoteDataSource(dio).getResumeStatus(1182, planOverride: 'max');

      expect(adapter.last!.path, '/calls/1182/resume-status');
      expect(adapter.last!.queryParameters, {'plan_override': 'max'});
    });

    test('⭐ override 가 없으면 쿼리 자체가 없다 — 제품 통화는 종전 그대로', () async {
      final adapter = _CaptureAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://h.run.app/api/v1'))
        ..httpClientAdapter = adapter;
      await NormalcallRemoteDataSource(dio).getResumeStatus(1182);

      expect(adapter.last!.queryParameters, isEmpty);
    });
  });
}
