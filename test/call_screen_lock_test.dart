// 통화 화면 잠금 — 2026-10-10 사용자 확정 · PM-DEC-480·485.
//
// - 잠그기·풀기 모두 **길게 누르기 1초**. 탭은 아무 일도 없다.
// - 잠긴 동안 종료 버튼을 포함한 **모든 조작**과 시스템 뒤로 가기가 막힌다.
// - 해제 버튼은 화면 가로 가운데(태블릿도 같은 규칙).
//
// 하네스는 call_course_hint_test 와 같다(고정 [CallState] 스텁 · Max 플랜).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/call_lock.dart';
import 'package:beavertalk/components/organisms/dialog_basic.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';

/// 끊기 호출 수 — 노티파이어 공개 필드는 riverpod_lint 지적 대상이라 밖에 둔다.
int _hangUps = 0;

class _StubCallController extends NormalCallController {
  _StubCallController(this._state);
  final CallState _state;
  @override
  CallState build() => _state;
  @override
  Future<void> hangUp() async => _hangUps++;
}

const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);

Future<void> _pump(WidgetTester tester, {Size size = const Size(375, 812)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  _hangUps = 0;
  final controller = _StubCallController(
    const CallState(phase: CallPhase.inCall, beaverSubtitle: '안녕하세요.'),
  );
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider.overrideWith(() => controller),
        subscriptionStatusProvider.overrideWithValue(_max),
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

Finder get _lockButton => find.byType(CallLockButton);
Finder get _release => find.byType(CallLockRelease);

/// [target] 가운데를 [hold] 동안 누르고 뗀다.
Future<void> _hold(WidgetTester tester, Finder target, Duration hold) async {
  final g = await tester.startGesture(tester.getCenter(target));
  await tester.pump();
  await tester.pump(hold);
  await g.up();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// 시트 등장 모션(≈300ms)을 흘린다 — 통화 화면은 음성 막대가 계속 돌아 `pumpAndSettle` 이 끝나지 않는다.
Future<void> _flush(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('잠금 버튼은 GNB 오른쪽 — 원 40 의 끝이 화면 끝에서 20(상자 52 · 위 14)', (tester) async {
    await _pump(tester);
    final r = tester.getRect(_lockButton);
    expect(r.size, const Size(52, 52));
    expect(375 - r.right, 14);
  });

  testWidgets('태블릿 810 에서도 화면 끝 기준 — 본문 캡 600 을 따르지 않는다', (tester) async {
    await _pump(tester, size: const Size(810, 1080));
    expect(810 - tester.getRect(_lockButton).right, 14);
  });

  testWidgets('탭(짧게 누르기)으로는 잠기지 않는다', (tester) async {
    await _pump(tester);
    await _hold(tester, _lockButton, const Duration(milliseconds: 500));
    expect(_release, findsNothing);
  });

  testWidgets('1초 길게 누르면 잠기고, 잠긴 동안 종료·뒤로 가기가 막힌다', (tester) async {
    await _pump(tester);
    await _hold(tester, _lockButton, const Duration(milliseconds: 1050));
    expect(_release, findsOneWidget);

    // 종료 버튼(오른쪽 아래 빨간 원) 자리를 눌러도 확인 대화상자가 안 뜬다.
    await tester.tapAt(const Offset(375 - 32 - 28, 812 - 16 - 28));
    await _flush(tester);
    expect(find.byType(DialogBasic), findsNothing);

    // 시스템 뒤로 가기 → 끊지 않는다.
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(_hangUps, 0);
    expect(_release, findsOneWidget);
  });

  testWidgets('해제 버튼은 짧게 누르면 그대로, 1초 누르면 풀린다', (tester) async {
    await _pump(tester);
    await _hold(tester, _lockButton, const Duration(milliseconds: 1050));

    final l10n = AppLocalizations.of(tester.element(_release));
    await _hold(
      tester,
      find.bySemanticsLabel(l10n.callUnlockA11y),
      const Duration(milliseconds: 400),
    );
    expect(_release, findsOneWidget, reason: '중간에 떼면 링이 비워지고 잠김 유지');

    await _hold(
      tester,
      find.bySemanticsLabel(l10n.callUnlockA11y),
      const Duration(milliseconds: 1050),
    );
    expect(_release, findsNothing);

    // 풀린 뒤에는 뒤로 가기가 다시 통화를 끊는다(종전 동작).
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(_hangUps, 1);
  });

  testWidgets('해제 버튼은 가로 가운데 — 폰·태블릿 모두', (tester) async {
    for (final size in const [Size(375, 812), Size(810, 1080)]) {
      await _pump(tester, size: size);
      await _hold(tester, _lockButton, const Duration(milliseconds: 1050));
      expect(tester.getCenter(_release).dx, size.width / 2);
    }
  });
}
