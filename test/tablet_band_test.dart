// 화면이 태블릿 폭에서 **콘텐츠 밴드 안에** 그려지는지 본다.
//
// `adaptive_layout_test.dart` 는 규칙(여백 20→105, 콘텐츠 600)이 맞는지 검사한다.
// 이 파일은 다른 걸 묻는다 — **화면이 그 규칙을 실제로 쓰는가.** 둘은 다른
// 질문이고, 실제로 갈렸다: 규칙과 부품은 맞는데 화면 여섯 장이 변환에서 빠져
// 폰 여백 20을 그대로 쓰고 있었고, 태블릿 렌더를 픽셀로 재고 나서야 드러났다.
//
// 그래서 여기서는 화면마다 세 가지만 본다.
//
//   1. [ContentColumn] 을 하나라도 쓰는가 — 안 쓰면 변환에서 빠진 화면이다.
//   2. 그 컬럼의 캡이 정본 셋(600·480·700) 중 하나인가 — 폭을 발명했는가.
//   3. 자식이 그 캡이 약속한 자리에 정확히 놓였는가.
//
// 전폭이어야 하는 것(상태바·헤더 배경·바텀시트 표면·히어로 이미지·하단 셸프
// 보더)은 [ContentColumn] 바깥이라 애초에 검사 대상이 아니다. 그게 이 구조를
// 고른 이유다 — 「무엇이 전폭이어도 되는가」를 목록으로 관리하지 않아도 된다.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/adaptive.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

import 'package:beavertalk/screens/alarm/alarm_empty.dart';
import 'package:beavertalk/screens/alarm/alarm_list.dart';
import 'package:beavertalk/screens/auth/login.dart';
import 'package:beavertalk/screens/auth/login_form.dart';
import 'package:beavertalk/screens/auth/password_code.dart';
import 'package:beavertalk/screens/auth/password_complete.dart';
import 'package:beavertalk/screens/auth/password_method.dart';
import 'package:beavertalk/screens/auth/signup.dart';
import 'package:beavertalk/screens/home/call_finish.dart';
import 'package:beavertalk/screens/mypage/edit_nickname.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:beavertalk/screens/onboarding/onboarding_done.dart';
import 'package:beavertalk/screens/onboarding/onboarding_language.dart';
import 'package:beavertalk/screens/onboarding/onboarding_name.dart';
import 'package:beavertalk/screens/onboarding/onboarding_reason.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/screens/plans/plan_change.dart';
import 'package:beavertalk/screens/plans/plans_compare.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:beavertalk/screens/record/record_empty.dart';
import 'package:beavertalk/screens/record/record_list.dart';
import 'package:beavertalk/screens/system/mic_denied.dart';
import 'package:beavertalk/screens/system/network_error.dart';
import 'package:beavertalk/screens/system/permission.dart';

void main() {
  final screens = <String, Widget Function()>{
    'Login': () => const LoginScreen(),
    'LoginForm': () => const LoginFormScreen(),
    'Signup': () => const SignupScreen(),
    'PasswordMethod': () => const PasswordMethodScreen(),
    'PasswordCode': () => const PasswordCodeScreen(),
    'PasswordComplete': () => const PasswordCompleteScreen(),
    'OnboardingLanguage': () => const OnboardingLanguageScreen(),
    'OnboardingName': () => const OnboardingNameScreen(),
    'OnboardingReason': () => const OnboardingReasonScreen(),
    'OnboardingDone': () => const OnboardingDoneScreen(),
    'RecordList': () => const RecordListScreen(),
    'RecordArchive': () => const RecordListScreen(initialTab: 1),
    'RecordEmpty': () => const RecordEmptyScreen(),
    'MyPage': () => const MyPageScreen(),
    'MyPageSettings': () => const MyPageSettingsScreen(),
    'EditNickname': () => const EditNicknameScreen(),
    'SubscriptionManage': () => const SubscriptionManageScreen(),
    'PaywallPro': () => const PaywallScreen(variant: PaywallVariant.pro),
    'PlansCompare': () => const PlansCompareScreen(),
    'PlanChange': () =>
        const PlanChangeScreen(direction: PlanChangeDirection.upgrade),
    'WinbackSurvey': () => const WinbackSurveyScreen(),
    'AlarmList': () => const AlarmListScreen(),
    'AlarmEmpty': () => const AlarmEmptyScreen(),
    'CallFinish': () => const CallFinishScreen(),
    'Permission': () => const PermissionScreen(),
    'MicDenied': () => const MicDeniedScreen(),
    'NetworkError': () => const NetworkErrorScreen(),
  };

  // 실제 안드로이드 태블릿 세로 폭. 에뮬레이터(2560×1600 @ dpr 2.0)의 세로가
  // 정확히 이 값이라 여기서 잰 수치를 기기에서 그대로 확인할 수 있다.
  // 정본 810 에서는 본문 여백이 105 인데, 800 에서는 같은 식이 100 을 낸다.
  const width = 800.0;
  const tolerance = 0.5;

  /// 정본이 허용하는 캡. 여기 없는 값이 나오면 규격에 없는 폭을 발명한 것이다.
  ///
  /// `double` 은 원시 상등이 없어 `const Set` 을 못 만든다 — 리스트로 둔다.
  final allowedCaps = <double>[
    AppLayout.content, // 600 — 본문
    AppLayout.narrow, // 480 — 안내문·오버레이
    AppLayout.document, // 700 — 법률 문서
  ];

  for (final entry in screens.entries) {
    testWidgets('${entry.key} — 태블릿 폭에서 콘텐츠가 자기 캡을 지킨다',
        (tester) async {
      tester.view.physicalSize = const Size(width, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('ko'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: entry.value(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      final columns = find.byType(ContentColumn);
      expect(
        columns,
        findsWidgets,
        reason: '${entry.key} 이 ContentColumn 을 안 쓴다 — 적응형 변환에서 빠졌다. '
            '폰 여백 20 이 태블릿에서도 그대로 남는다.',
      );

      // 화면 폭을 통째로 받는 컬럼만 본다. 시트·카드 안에 중첩된 컬럼은 자기
      // 부모 폭을 기준으로 계산하므로 화면 밴드와 비교할 대상이 아니다.
      var checked = 0;
      for (final element in columns.evaluate()) {
        final box = element.renderObject! as RenderContentColumn;
        if ((box.size.width - width).abs() > tolerance) continue;
        final child = box.child;
        if (child == null) continue;

        expect(
          allowedCaps,
          contains(box.maxWidth),
          reason: '${entry.key}: 캡 ${box.maxWidth} 은 정본에 없는 폭이다.',
        );

        // 컬럼이 스스로 약속한 값 — 폰 여백은 gutter, 넓어지면 캡이 이긴다.
        final inset = box.gutter > (width - box.maxWidth) / 2
            ? box.gutter
            : (width - box.maxWidth) / 2;
        final left =
            box.localToGlobal(Offset.zero).dx +
                (child.parentData! as BoxParentData).offset.dx;

        expect(
          left,
          closeTo(inset + box.extra.left, tolerance),
          reason: '${entry.key}: 콘텐츠 왼쪽이 $left — '
              '캡 ${box.maxWidth} 이면 ${inset + box.extra.left} 이어야 한다.',
        );
        expect(
          left + child.size.width,
          closeTo(width - inset - box.extra.right, tolerance),
          reason: '${entry.key}: 콘텐츠 오른쪽이 밴드를 벗어난다.',
        );
        checked++;
      }
      expect(
        checked,
        greaterThan(0),
        reason: '${entry.key}: 화면 폭을 받는 ContentColumn 이 없다.',
      );
    });
  }
}
