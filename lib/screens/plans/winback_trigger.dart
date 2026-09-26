import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/subscription/domain/entities/subscription.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/domain/subscription_status_resolver.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import 'winback_offer_sheet.dart';
import 'winback_survey.dart';

/// 구독 만료를 감지하면 **그 회원 · 그 만료에 한 번** 윈백 설문을 띄운다(PM-DEC-034 · 052 ·
/// 가치 사다리 완성안 §8-4 「윈백 설문을 해지·만료 흐름에 배선」).
///
/// 홈에 크기 0 으로 둔다 — 홈은 로그인 뒤 첫 화면이라 「만료 뒤 첫 실행」 이 곧 이 위젯이
/// 처음 만료 상태를 보는 때다. 해지 예약(ending) 화면은 스토어 관리 링크만 두고 여기서 다루지
/// 않는다 — 아직 유효한 구독에 「Your Premium plan ended」 설문은 맞지 않는다.
///
/// 띄우는 조건 — 셋 다 맞아야 한다([shouldOfferWinback]):
/// 1. **서버 판정**(`GET /subscriptions/status`)이 expired. 행 목록 추론값으로는 띄우지 않는다
///    — 서버 응답 전에 추론값이 먼저 와서 띄우고 기록까지 끝낸 뒤 서버가 다른 답을 줄 수 있었다
///    (QA F059). 서버가 답을 안 주면(구서버 · 실패) 띄우지 않는다
/// 2. **한 번이라도 활성화된 구독 행**이 있다(`is_activate` 가 true·false). null 만 있는 회원은
///    결제한 적이 없는데, 앱 추론과 서버 모두 그 행을 만료로 본다 — 원래 Free 회원에게 「Premium
///    끝남」 이 떴다(QA F058 · 서버 요청서 §16)
/// 3. 이 회원의 기록([winbackPrefKeyFor])이 이 만료가 아니다. 회원 id 를 모르면(프로필 실패)
///    띄우지도 기록하지도 않는다 — id 없이 기록하면 다음 실행의 기록과 안 맞아 다시 떴다(QA F061)
///
/// 기록은 회원별 키다(PM-DEC-052) — 한 기기에서 만료 회원 A → B 로 바꿔도 A 의 기록이 남는다.
/// 표시 **전에** 기록한다 — 설문 도중 앱이 죽어도 되풀이하지 않는다. 기기를 바꾸거나 다시 깔면
/// 기록이 없어 다시 뜬다 — 서버 기록 전까지의 한계(서버 요청서 §16).
///
/// 설문 결과: 「Too expensive」 → 홈 위 윈백 오퍼 시트([showWinbackOfferSheet]) · 그 밖의 사유와
/// Skip · Not now → 홈(PM-DEC-035·036).
class WinbackTrigger extends ConsumerStatefulWidget {
  /// Creates the trigger. Renders nothing.
  const WinbackTrigger({super.key});

  @override
  ConsumerState<WinbackTrigger> createState() => _WinbackTriggerState();
}

class _WinbackTriggerState extends ConsumerState<WinbackTrigger> {
  /// 이 세션에서 이미 판단했다 — 상태가 다시 알려 와도 두 번 띄우지 않는다.
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<SubscriptionStatus?>>(
      serverSubscriptionStatusProvider,
      (_, next) {
        final status = next.valueOrNull;
        if (status != null) _maybeShow(status);
      },
      fireImmediately: true,
    );
  }

  Future<void> _maybeShow(SubscriptionStatus status) async {
    if (_handled || status.state != SubscriptionState.expired) return;
    _handled = true;
    final int memberId;
    final List<Subscription> rows;
    try {
      memberId = (await ref.read(myProfileProvider.future)).memberId;
      rows = await ref.read(subscriptionsProvider.future);
    } catch (_) {
      return; // 회원·구독 행을 모르면 띄우지 않는다.
    }
    if (!mounted) return;
    if (!shouldOfferWinback(status: status, rows: rows)) return;
    final key = winbackPrefKeyFor(memberId);
    final mark = winbackMark(status.expiresAt);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(key) == mark) return;
      await prefs.setString(key, mark);
    } catch (_) {
      // 기록을 못 하면 띄우지 않는다 — 매 실행 설문이 뜨는 쪽이 더 나쁘다.
      return;
    }
    // 리스너 안이라 빌드 중일 수 있다 — 다음 프레임에 민다.
    SchedulerBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    if (!mounted) return;
    // 타입 없는 pushNamed — 라우트 표가 `MaterialPageRoute<dynamic>` 을 만들어
    // `pushNamed<WinbackReason>` 은 형 변환에서 던진다(시험에서 잡음).
    final result = await Navigator.of(context).pushNamed(Routes.winbackSurvey);
    if (!mounted || result != WinbackReason.expensive) return;
    await showWinbackOfferSheet(context);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 윈백을 권할 회원인가 — 서버 판정 expired **이고** 한 번이라도 활성화된 구독 행이 있다.
///
/// `is_activate` 가 null 인 행은 「활성화된 적 없음」이다 — 결제가 끝나지 않은 행이라 그 회원은
/// Premium 을 쓴 적이 없다(QA F058). true·false 는 한 번은 활성이었다는 뜻이다(해지는 false 로
/// 바꾼다).
@visibleForTesting
bool shouldOfferWinback({
  required SubscriptionStatus status,
  required List<Subscription> rows,
}) =>
    status.state == SubscriptionState.expired &&
    rows.any((s) => s.isActivate != null);

/// 회원별 「이 만료에 이미 띄웠다」 기록 키(PM-DEC-052).
@visibleForTesting
String winbackPrefKeyFor(int memberId) => 'winback_survey_shown_for_$memberId';

/// 기록 값 — 만료 시각. 다시 구독했다가 또 만료되면 값이 달라 다시 띄운다.
@visibleForTesting
String winbackMark(DateTime? expiresAt) =>
    expiresAt?.toUtc().toIso8601String() ?? '-';
