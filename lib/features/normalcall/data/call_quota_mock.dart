import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../subscription/presentation/providers/subscription_state_providers.dart';
import '../domain/entities/call_quota.dart';

/// ⚠ **목이다. 서버가 붙으면 이 파일을 통째로 지운다.**
///
/// ## 왜 파일을 따로 뺐나
///
/// 목을 화면이나 컨트롤러 안에 흩뿌리면 나중에 **무엇이 진짜인지 못 가린다.** 한 파일에
/// 가둬 두면 교체가 「이 파일을 지우고 데이터소스를 물린다」로 끝난다.
///
/// ## 무엇이 가짜인가
///
/// 값 전부다. `GET /calls/quota` 가 아직 없다(서버질문지 B). 지금은 확정된 정책을
/// 상수로 흉내 낸다:
///   - 무료 — 1일 1통화 · 통화당 5분
///   - 유료 — 통화 수 무제한 · 5분마다 확인
///
/// [CallQuota.usedToday] 는 **항상 0** 이다. 실제 사용량을 세는 곳이 없어서다. 그래서
/// 「오늘 다 썼다」 상태는 이 목으로 재현되지 않는다 — 그 화면을 검증하려면 서버가
/// 필요하다.
///
/// [CallQuota.resetsAt] 도 null 이다. **클라가 자정을 계산하지 않는다**는 규칙을
/// 목에서도 지킨다. 여기서 계산해 두면 서버를 붙일 때 그 코드가 남아 기기 시간대를
/// 타는 버그로 되살아난다.
final callQuotaProvider = Provider.autoDispose<CallQuota>((ref) {
  final paid = ref.watch(subscriptionStatusProvider).grantsPaidAccess;
  return CallQuota(
    dailyLimit: paid ? null : 1,
    usedToday: 0,
    maxDurationSec: kMockCallLimitSec,
    resetsAt: null,
  );
});

/// 통화 한 번의 상한(초). 무료·유료 공통으로 5분마다 확인을 받는다.
///
/// ⚠ 목 상수다. 서버의 `max_duration_sec` 로 교체된다.
const int kMockCallLimitSec = 300;
