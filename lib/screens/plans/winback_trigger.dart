import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/domain/subscription_status_resolver.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import 'winback_offer_sheet.dart';
import 'winback_survey.dart';

/// 구독 만료를 감지하면 **그 만료에 한 번** 윈백 설문을 띄운다(PM-DEC-034 · 가치 사다리
/// 완성안 §8-4 「윈백 설문을 해지·만료 흐름에 배선」).
///
/// 홈에 크기 0 으로 둔다 — 홈은 로그인 뒤 첫 화면이라 「만료 뒤 첫 실행」 이 곧 이 위젯이
/// 처음 만료 상태를 보는 때다. 해지 예약(ending) 화면은 스토어 관리 링크만 두고 여기서 다루지
/// 않는다 — 아직 유효한 구독에 「Your Premium plan ended」 설문은 맞지 않는다.
///
/// 한 번의 기준은 [winbackMark](회원 · 만료 시각)다. 같은 만료면 다시 안 띄우고, 다시 구독했다가
/// 또 만료되면 새 만료라 다시 띄운다. 표시 **전에** 기록한다 — 설문 도중 앱이 죽어도 되풀이하지
/// 않는다.
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
    ref.listenManual<SubscriptionStatus>(
      subscriptionStatusProvider,
      (_, next) => _maybeShow(next),
      fireImmediately: true,
    );
  }

  Future<void> _maybeShow(SubscriptionStatus status) async {
    if (_handled || status.state != SubscriptionState.expired) return;
    _handled = true;
    // 회원 id 는 기다려서 읽는다 — 구독 상태가 프로필보다 먼저 오면 id 없이 기록돼, 다음 실행의
    // 기록과 안 맞아 같은 만료에 설문이 또 떴다(시험에서 잡음).
    int? memberId;
    try {
      memberId = (await ref.read(myProfileProvider.future)).memberId;
    } catch (_) {}
    if (!mounted) return;
    final mark = winbackMark(memberId: memberId, expiresAt: status.expiresAt);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(winbackPrefKey) == mark) return;
      await prefs.setString(winbackPrefKey, mark);
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

/// 「이 만료에 이미 띄웠다」 기록의 SharedPreferences 키.
@visibleForTesting
const String winbackPrefKey = 'winback_survey_shown_for';

/// 한 번의 기준 — 같은 기기에서 다른 회원이 만료돼도, 같은 회원이 다시 만료돼도 새로 띄운다.
@visibleForTesting
String winbackMark({int? memberId, DateTime? expiresAt}) =>
    '${memberId ?? '-'}|${expiresAt?.toUtc().toIso8601String() ?? '-'}';
