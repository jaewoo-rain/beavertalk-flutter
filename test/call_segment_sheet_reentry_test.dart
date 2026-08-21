// 5분 시트가 **다시 열리지 않는가** — 결제하고 돌아온 사람 앞에서.
//
// 통화 화면은 `ref.listen` 으로 [CallPhase.awaitingContinue] 를 보고 시트를 띄운다.
// 조건이 「그 상태인가」이면 **결정을 기다리는 동안의 다른 상태 변화에도** 시트가
// 다시 열린다. [NormalCallController.resumeAfterPaywall] 이 결제 확인 뒤
// `paidCallTime` 을 굳히는 순간이 정확히 그 경우다 — phase 는 아직 `awaitingContinue`
// 라서, 결제를 마치고 돌아온 사람 앞에 방금 닫은 시트가 그대로 다시 뜬다.
//
// `_segmentSheetOpen` 은 이걸 못 막는다. 시트가 닫히면서 이미 풀려 있기 때문이다.
// 그래서 조건이 「그 상태로 **진입**했는가」여야 한다.
//
// ⚠ 이 테스트는 **진짜 경로**를 타야 한다. 시트를 `Navigator.pop` 으로 그냥 닫으면
//   버튼을 누른 게 아니라서 `_showSegmentSheet` 이 "아무 것도 안 골랐다"로 보고
//   `hangUp()` 을 부르고, 그 종료가 `_navigated` 를 세워 **가드와 무관하게** 시트가
//   안 뜬다. 그 상태로는 가드를 지워도 테스트가 통과한다(실제로 그렇게 헛돌았다).
//   그래서 구독 버튼을 **눌러서** 닫는다.
//
// 플랜: docs/2026-08-21_2228_resume-call-after-mid-call-subscribe-plan.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';

/// 바깥에서 상태를 밀어 넣을 수 있는 컨트롤러. 진짜 [NormalCallController] 는
/// 소켓과 오디오를 열어 위젯테스트에서 세울 수 없다.
class _DrivableCallController extends NormalCallController {
  _DrivableCallController(this._initial);

  final CallState _initial;

  @override
  CallState build() => _initial;

  /// 테스트가 상태 전이를 흉내 낸다.
  void emit(CallState next) => state = next;

  /// 결제가 확인된 경우만 흉내 낸다 — **이 한 줄이 문제의 상태 변화다.**
  /// phase 는 `awaitingContinue` 그대로인 채 `paidCallTime` 만 바뀐다.
  @override
  Future<bool> resumeAfterPaywall() async {
    state = state.copyWith(paidCallTime: true);
    return true;
  }

  // 시트의 「End Call」 과 종료 경로가 이걸 부른다 — 소켓을 타지 않게 막아 둔다.
  @override
  Future<void> hangUp() async => state = state.copyWith(phase: CallPhase.ended);
}

/// 시트 애니메이션이 끝날 때까지 민다.
///
/// `pumpAndSettle` 은 쓸 수 없다 — 아바타 이미지가 아직 없는 통화 화면은 스켈레톤을
/// **무한 반복**해서 프레임이 영영 잦아들지 않는다(`call_screen_layout_test` 도 같은
/// 이유로 고정 시간을 민다).
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// 무료 회원이 첫 5분을 다 쓴 직후 — 시트가 떠야 하는 상태.
const _parked = CallState(
  phase: CallPhase.awaitingContinue,
  callId: 'call-1',
  elapsedSec: 300,
  segmentsUsed: 1,
);

Future<_DrivableCallController> _pumpCall(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final controller = _DrivableCallController(
    const CallState(phase: CallPhase.inCall, callId: 'call-1'),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider.overrideWith(() => controller),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // 페이월 자체는 이 테스트의 관심사가 아니다. 통화 화면이 **그 위에 얹고
        // 돌아오는지**만 보므로, 눌러서 닫을 수 있는 자리표시자면 충분하다.
        routes: {
          Routes.paywallProLimit: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('close-paywall'),
                  ),
                ),
              ),
        },
        home: const CallScreen(),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 32));
  return controller;
}

void main() {
  testWidgets('결제하고 돌아와 paidCallTime 이 굳어도 시트가 다시 열리지 않는다',
      (tester) async {
    final controller = await _pumpCall(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final sheetTitle = find.text(l10n.fcEndedTitle);

    // 5분 경과 — 시트가 뜬다.
    controller.emit(_parked);
    await _settle(tester);
    expect(sheetTitle, findsOneWidget, reason: '구간이 끝나면 시트가 떠야 한다');

    // 「Subscribe and keep talking」 — 시트가 닫히고 결제 화면이 통화 화면 **위에** 얹힌다.
    await tester.tap(find.text(l10n.ctaSubscribeKeepTalking));
    await _settle(tester);
    expect(sheetTitle, findsNothing, reason: '시트는 닫혀야 한다');
    expect(find.text('close-paywall'), findsOneWidget,
        reason: '통화 화면을 교체하지 말고 그 위에 얹어야 한다');
    expect(controller.state.phase, CallPhase.awaitingContinue,
        reason: '통화를 끊으면 이어갈 근거(callId)가 사라진다');

    // 결제를 마치고 퍼널이 통화 화면까지 되돌아온다 →
    // `resumeAfterPaywall` 이 `paidCallTime` 을 굳힌다.
    await tester.tap(find.text('close-paywall'));
    // ⚠ 넉넉히 민다. pop 애니메이션(300ms)이 **끝난 뒤에야** `onSubscribe` 의 await 가
    //   풀려 상태가 바뀌고, 시트가 다시 뜬다면 거기서 또 애니메이션이 필요하다.
    //   여기서 아끼면 "시트가 없다"가 아니라 "아직 안 그려졌다"를 통과로 읽는다.
    await _settle(tester);
    await _settle(tester);
    await _settle(tester);
    expect(controller.state.paidCallTime, isTrue, reason: '복귀 판정이 돌아야 한다');

    // ⛔ 여기서 시트가 뜨면, 결제를 마치고 돌아온 사람이 시트를 다시 본다.
    //
    // ⚠ **무료 시트만 찾으면 놓친다.** 이 시점엔 `paidCallTime` 이 true 라
    //   `_showSegmentSheet` 이 무료 시트가 아니라 **「Keep going?」** 을 띄운다.
    //   실제로 그렇게 헛돌았다 — 가드를 지워도 `fcEndedTitle` 은 안 잡혀서
    //   테스트가 통과했다. 두 시트를 **다** 본다.
    expect(sheetTitle, findsNothing,
        reason: '결정 대기 중의 상태 변화는 시트를 다시 열지 않는다');
    expect(find.text(l10n.kgTitle), findsNothing,
        reason: '유료로 바뀌었다고 「Keep going?」 이 재개된 통화 위로 튀어나오면 안 된다');
  });

  testWidgets('구간이 끝나면 시트는 정상적으로 뜬다 — 가드가 기능을 죽이지 않았는가',
      (tester) async {
    final controller = await _pumpCall(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.fcEndedTitle), findsNothing);

    controller.emit(_parked);
    await _settle(tester);

    expect(find.text(l10n.fcEndedTitle), findsOneWidget);
  });
}
