import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 화면의 국가/언어 선택 시트를 **이번 앱 실행에서 이미 띄웠는지** 여부.
///
/// 시트는 "앱 최초 진입" 신호다. 그런데 그 판단을 [signupDraftProvider] 의 `language`
/// 하나로만 하면 안 된다 — 로그아웃 시 `AuthController._clearUserScopedState()` 가
/// 드래프트를 통째로 비우기 때문(사용자 A 의 언어/이름/사유가 B 의 온보딩에 프리필되는 걸
/// 막는, 그 자체로는 옳은 보호다). 그래서 로그아웃 직후 새로 마운트되는 LoginScreen 이
/// 매번 "최초 진입"으로 착각해 시트를 띄웠고, 곧이어 `logout()` 의 `_popToRoot()` 가
/// 그 시트 라우트를 pop 해 **올라오다 마는 시트**가 보였다.
///
/// 이 플래그는 **사용자 스코프가 아니라 앱 실행 스코프다.** `_clearUserScopedState()` 의
/// invalidate 목록에 절대 넣지 말 것 — 넣는 순간 위 증상이 그대로 돌아온다.
final languageSheetShownProvider =
    NotifierProvider<LanguageSheetShownNotifier, bool>(
  LanguageSheetShownNotifier.new,
);

class LanguageSheetShownNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 시트를 띄웠음을 기록한다(이번 실행 동안 다시 뜨지 않는다).
  void markShown() => state = true;
}
