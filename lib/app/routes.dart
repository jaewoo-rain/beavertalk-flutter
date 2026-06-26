import 'package:flutter/material.dart';
import '../preview/gallery_screen.dart';
import 'placeholder_screen.dart';
import '../screens/onboarding/onboarding_language.dart';
import '../screens/onboarding/onboarding_name.dart';
import '../screens/onboarding/onboarding_reason.dart';
import '../screens/onboarding/onboarding_done.dart';
import '../screens/auth/login.dart';
import '../screens/auth/login_form.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/password_method.dart';
import '../screens/auth/password_code.dart';
import '../screens/auth/password_complete.dart';
import '../screens/auth/terms.dart';
import '../screens/auth/privacy.dart';
import '../screens/home/home.dart';
import '../screens/home/call_loading.dart';
import '../screens/home/call.dart';
import '../screens/home/call_finish.dart';
import '../screens/home/analysis_loading.dart';
import '../screens/home/analysis.dart';
import '../screens/home/learning_intro.dart';
import '../screens/home/learning_next.dart';
import '../screens/home/learning_main.dart';
import '../screens/payment/payment.dart';
import '../screens/payment/payment_complete.dart';
import '../screens/payment/payment_failed.dart';
import '../screens/system/permission.dart';
import '../screens/system/mic_denied.dart';
import '../screens/mypage/mypage.dart';
import '../screens/mypage/subscription_info.dart';
import '../screens/mypage/avatar.dart';
import '../screens/mypage/share.dart';
import '../screens/alarm/alarm_list.dart';
import '../screens/alarm/alarm_add.dart';
import '../screens/alarm/alarm_empty.dart';
import '../screens/record/record_list.dart';
import '../screens/record/record_archive.dart';
import '../screens/record/record_empty.dart';

/// Route names for the design_app flows.
abstract final class Routes {
  static const onboarding = '/onboarding';
  static const onboardingName = '/onboarding/name';
  static const onboardingReason = '/onboarding/reason';
  static const onboardingDone = '/onboarding/done';

  static const login = '/login';
  static const loginForm = '/login/form';
  static const signup = '/signup';
  static const passwordMethod = '/password/method';
  static const passwordCode = '/password/code';
  static const passwordComplete = '/password/complete';
  static const terms = '/terms';
  static const privacy = '/privacy';

  static const home = '/home';
  static const callLoading = '/call/loading';
  static const call = '/call';
  static const callFinish = '/call/finish';
  static const analysisLoading = '/analysis/loading';
  static const analysis = '/analysis';
  static const learningIntro = '/learning/intro';
  static const learningNext = '/learning/next';
  static const learningMain = '/learning/main';

  // ── My page / subscription / avatar / share ──
  static const mypage = '/mypage';
  static const subscription = '/mypage/subscription';
  static const avatar = '/mypage/avatar';
  static const share = '/mypage/share';

  // ── Alarms ──
  static const alarms = '/alarms';
  static const alarmAdd = '/alarms/add';
  static const alarmEmpty = '/alarms/empty';

  // ── Records ──
  static const records = '/records';
  static const recordsArchive = '/records/archive';
  static const recordsEmpty = '/records/empty';

  // ── Payment / permission / error ──
  static const payment = '/payment';
  static const paymentComplete = '/payment/complete';
  static const paymentFailed = '/payment/failed';
  static const permission = '/permission';
  static const permissionMicDenied = '/permission/mic-denied';

  static const gallery = '/gallery';
}

/// Central route table. Screens are swapped for real ones flow-by-flow; until
/// then a [PlaceholderScreen] keeps every route navigable.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final builders = <String, WidgetBuilder>{
    Routes.gallery: (_) => const GalleryScreen(),
    Routes.onboarding: (_) => const OnboardingLanguageScreen(),
    Routes.onboardingName: (_) => const OnboardingNameScreen(),
    Routes.onboardingReason: (_) => const OnboardingReasonScreen(),
    Routes.onboardingDone: (_) => const OnboardingDoneScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.loginForm: (_) => const LoginFormScreen(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.passwordMethod: (_) => const PasswordMethodScreen(),
    Routes.passwordCode: (_) => const PasswordCodeScreen(),
    Routes.passwordComplete: (_) => const PasswordCompleteScreen(),
    Routes.terms: (_) => const TermsScreen(),
    Routes.privacy: (_) => const PrivacyScreen(),
    Routes.home: (_) => const HomeScreen(),
    Routes.callLoading: (_) => const CallLoadingScreen(),
    Routes.call: (_) => const CallScreen(),
    Routes.callFinish: (_) => const CallFinishScreen(),
    Routes.analysisLoading: (_) => const AnalysisLoadingScreen(),
    Routes.analysis: (_) => const AnalysisScreen(),
    Routes.learningIntro: (_) => const LearningIntroScreen(),
    Routes.learningNext: (_) => const LearningNextScreen(),
    Routes.learningMain: (_) => const LearningMainScreen(),
    Routes.payment: (_) => const PaymentScreen(),
    Routes.paymentComplete: (_) => const PaymentCompleteScreen(),
    Routes.paymentFailed: (_) => const PaymentFailedScreen(),
    Routes.permission: (_) => const PermissionScreen(),
    Routes.permissionMicDenied: (_) => const MicDeniedScreen(),
    Routes.mypage: (_) => const MyPageScreen(),
    Routes.subscription: (_) => const SubscriptionInfoScreen(),
    Routes.avatar: (_) => const AvatarScreen(),
    Routes.share: (_) => const ShareScreen(),
    Routes.alarms: (_) => const AlarmListScreen(),
    Routes.alarmAdd: (_) => const AlarmAddScreen(),
    Routes.alarmEmpty: (_) => const AlarmEmptyScreen(),
    Routes.records: (_) => const RecordListScreen(),
    Routes.recordsArchive: (_) => const RecordArchiveScreen(),
    Routes.recordsEmpty: (_) => const RecordEmptyScreen(),
  };

  final names = <String, String>{
    Routes.onboarding: '온보딩 · 언어 선택',
    Routes.onboardingName: '온보딩 · 이름',
    Routes.onboardingReason: '온보딩 · 이유',
    Routes.onboardingDone: '온보딩 · 완료',
    Routes.login: '로그인',
    Routes.loginForm: '로그인 폼',
    Routes.signup: '회원가입',
    Routes.passwordMethod: '비밀번호 찾기',
    Routes.passwordCode: '인증코드',
    Routes.passwordComplete: '비밀번호 재설정 완료',
    Routes.terms: '이용약관',
    Routes.privacy: '개인정보처리방침',
    Routes.home: '홈',
    Routes.callLoading: '통화 연결',
    Routes.call: '통화',
    Routes.callFinish: '통화 종료',
    Routes.analysisLoading: '분석 중',
    Routes.analysis: '통화 분석',
    Routes.learningIntro: '학습 인트로',
    Routes.learningNext: '학습 비교',
    Routes.learningMain: '학습 결과',
    Routes.mypage: '마이페이지',
    Routes.alarms: '알림',
    Routes.payment: '결제',
  };

  final name = settings.name ?? Routes.onboarding;
  final builder = builders[name] ??
      (_) => PlaceholderScreen(names[name] ?? name);
  return MaterialPageRoute(builder: builder, settings: settings);
}
