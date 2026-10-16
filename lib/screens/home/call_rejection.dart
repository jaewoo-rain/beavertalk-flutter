import 'package:flutter/material.dart';

import '../../core/analytics/app_analytics.dart';
import '../../core/config/store_flags.dart';
import '../../features/normalcall/domain/entities/call_allowance.dart';
import '../overlays/subscription_overlays.dart';

/// 서버가 통화를 거절했을 때(`error` 프레임) 화면을 떠나며 코드별 안내를 띄운다.
///
/// 연결 화면([CallLoadingScreen])과 통화 화면([CallScreen]) 둘 다 이 함수 하나로 간다 —
/// 거절은 첫 연결에도, 5분 구간 재연결에도 온다.
///
/// - `HOMEWORK_TIME_LIMIT`(과제 5분 소진 · PM-DEC-551): 결제 유도 없이 「숙제는 5분 통화만
///   가능해요.」를 띄우고 **숙제 화면으로** 한 칸 돌아간다(숙제 통화는 숙제 상세에서 연다).
///   b2b 가 회화를 끝낸 과제(`HOMEWORK_CONVERSATION_COMPLETED`)도 같다.
/// - `DAILY_LIMIT` + 무료 회원(오늘 무료 5분 소진 · PM-DEC-560): 홈으로 가서 한도
///   시트([SubscriptionOverlay.freeLimitCall])를 띄운다.
/// - 그 밖(유료 회원의 하루 15분 소진 포함): 종전대로 문구 스낵바 뒤 홈.
/// - [homework] 통화의 거절은 코드와 무관하게 결제 유도 없이 숙제 화면으로 돌아간다
///   (QA F004·F008 · 2026-10-14). 과제 마감·자료 오류에도 홈까지 밀려 나가던 것을 막는다.
///
/// [message] 는 이미 현지화된 문구다(`serverErrorMessage`).
void leaveAfterCallRejection(
  BuildContext context, {
  required String? code,
  required String message,
  required bool paidAccess,
  bool homework = false,
}) {
  final navigator = Navigator.of(context);
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  void snack() => ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));

  final homeworkTimeLimit = code == 'HOMEWORK_TIME_LIMIT' ||
      code == 'HOMEWORK_CONVERSATION_COMPLETED' ||
      (homework && code == 'DAILY_LIMIT');
  if (homeworkTimeLimit || homework) {
    if (homeworkTimeLimit) {
      AppAnalytics.instance.log(AppEvent.freeLimitHit, {'kind': 'homework'});
    }
    snack();
    navigator.pop();
    return;
  }
  navigator.popUntil((r) => r.isFirst);
  // 심사 빌드(PAYMENTS_ENABLED=false)는 구독 시트 없이 아래 기본 안내로(T-20261016-07).
  if (code == 'DAILY_LIMIT' && !paidAccess && paymentsEnabled) {
    AppAnalytics.instance.log(AppEvent.freeLimitHit, {'kind': 'daily'});
    final seconds = CallAllowance.limitFor(paidAccess: false).inSeconds;
    final limit =
        '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    showSubscriptionOverlay(
      rootNavigator.context,
      SubscriptionOverlay.freeLimitCall,
      usage: (used: limit, limit: limit),
    );
    return;
  }
  snack();
}
