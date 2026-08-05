import 'package:flutter/material.dart';
import '../preview/echo_rig_screen.dart';
import '../preview/gallery_screen.dart';
import '../theme/app_motion.dart';
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
import '../screens/auth/password_new.dart';
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
import '../features/pronunciation_challenge/presentation/pronunciation_challenge_screen.dart';
import '../screens/home/learning_call_main.dart';
import '../screens/home/learning_call_main_loading.dart';
import '../screens/home/learning_sentence_main.dart';
import '../screens/payment/payment_history.dart';
import '../screens/system/permission.dart';
import '../screens/system/mic_denied.dart';
import '../screens/mypage/mypage.dart';
import '../screens/mypage/edit_nickname.dart';
import '../screens/mypage/settings.dart';
import '../screens/mypage/subscription_manage.dart';
import '../screens/plans/paywall.dart';
import '../screens/plans/plan_change.dart';
import '../screens/plans/plans_compare.dart';
import '../screens/plans/purchase_flow.dart';
import '../features/subscription/domain/entities/subscription_state.dart';
import '../screens/mypage/avatar.dart';
import '../screens/mypage/share.dart';
import '../screens/alarm/alarm_list.dart';
import '../screens/alarm/alarm_add.dart';
import '../screens/alarm/alarm_empty.dart';
import '../screens/record/record_list.dart';
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
  static const passwordNew = '/password/new';
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
  static const learningSentenceMain = '/learning/sentence-main';
  static const learningCallMain = '/learning/call-main';
  static const learningCallMainLoading = '/learning/call-main/loading';
  static const pronunciationChallenge = '/pronunciation-challenge';

  // ── My page / subscription / avatar / share ──
  static const mypage = '/mypage';

  /// Settings, split out of my page by the redesign (Figma
  /// `screen/main_mypage_settings`).
  static const mypageSettings = '/mypage/settings';

  /// Nickname editor behind the Account card's Nickname row (Figma
  /// `depth/edit_nickname_depth3`).
  static const editNickname = '/mypage/settings/nickname';
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

  // ── Subscription redesign (P3) ──
  static const plansCompare = '/plans/compare';
  static const planChangeUpgrade = '/plans/change-upgrade';
  static const planChangeDowngrade = '/plans/change-downgrade';
  static const paywallPro = '/paywall/pro';
  static const paywallProLimit = '/paywall/pro-limit';
  static const paywallMax = '/paywall/max';
  static const purchaseProcessing = '/purchase/processing';
  static const purchaseSuccessPro = '/purchase/success-pro';
  static const purchaseSuccessMax = '/purchase/success-max';
  static const plansError = '/plans/error';
  static const winbackSurvey = '/winback-survey';

  // ── Payment / permission / error ──
  //
  // The in-house checkout trio (`/payment`, `/complete`, `/failed`) is gone —
  // v2 §2-3: IAP is the only rail, the OS sheet is the checkout. History
  // stays: it lists both product types (§6-5).
  static const paymentHistory = '/payment/history';
  static const permission = '/permission';
  static const permissionMicDenied = '/permission/mic-denied';

  static const gallery = '/gallery';

  /// 개발자 전용 계측 도구. 서버 에코 게이트 상수를 정하기 위한 실측 리그다.
  /// [gallery] 와 같은 부류(제품 플로우에서 도달하지 않는 진입점)라 여기 둔다 —
  /// 컴포넌트 갤러리에 끼워 넣지 않은 건 그쪽이 컴포넌트 미리보기 전용이기 때문이다.
  static const echoRig = '/dev/echo-rig';
}

/// Central route table. Screens are swapped for real ones flow-by-flow; until
/// then a [PlaceholderScreen] keeps every route navigable.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Supabase OAuth (Kakao/Apple) returns through the deep link
  // `im.beavertalk.beavertalk://login-callback?code=…`, which the OS delivers to
  // the already-running app and Flutter surfaces here as a route name like
  // `/?code=…`. supabase_flutter's own app_links listener ALREADY handles this
  // link (PKCE code exchange → session → onAuthStateChange → AuthGate re-routes),
  // so rendering it as an unknown route showed the "화면 준비 중" placeholder on
  // top of everything. Intercept it with a transient splash that pops itself,
  // revealing the AuthGate root which flips to home/onboarding once the session
  // lands. (`flutter_deeplinking_enabled=false` in the manifest covers the
  // cold-start initial-link case; this covers the running/onNewIntent case.)
  final rawName = settings.name ?? '';
  if (rawName.contains('code=') ||
      rawName.contains('access_token=') ||
      rawName.contains('error_description=')) {
    return _AppPageRoute<dynamic>(
      builder: (_) => const _OAuthCallbackScreen(),
      settings: settings,
    );
  }

  final builders = <String, WidgetBuilder>{
    Routes.gallery: (_) => const GalleryScreen(),
    Routes.echoRig: (_) => const EchoRigScreen(),
    Routes.onboarding: (_) => const OnboardingLanguageScreen(),
    Routes.onboardingName: (_) => const OnboardingNameScreen(),
    Routes.onboardingReason: (_) => const OnboardingReasonScreen(),
    Routes.onboardingDone: (_) => const OnboardingDoneScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.loginForm: (_) => const LoginFormScreen(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.passwordMethod: (_) => const PasswordMethodScreen(),
    Routes.passwordCode: (_) => const PasswordCodeScreen(),
    Routes.passwordNew: (_) => const PasswordNewScreen(),
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
    Routes.learningSentenceMain: (_) => const LearningSentenceMainScreen(),
    Routes.learningCallMain: (_) => const LearningCallMainScreen(),
    Routes.learningCallMainLoading: (_) =>
        const LearningCallMainLoadingScreen(),
    Routes.pronunciationChallenge: (_) =>
        const PronunciationChallengeScreen(),
    Routes.paymentHistory: (_) => const PaymentHistoryScreen(),
    Routes.permission: (_) => const PermissionScreen(),
    Routes.permissionMicDenied: (_) => const MicDeniedScreen(),
    Routes.mypage: (_) => const MyPageScreen(),
    Routes.mypageSettings: (_) => const MyPageSettingsScreen(),
    Routes.editNickname: (_) => const EditNicknameScreen(),
    Routes.subscription: (_) => const SubscriptionManageScreen(),
    Routes.plansCompare: (_) => const PlansCompareScreen(),
    Routes.paywallPro: (_) =>
        const PaywallScreen(variant: PaywallVariant.pro),
    Routes.paywallProLimit: (_) =>
        const PaywallScreen(variant: PaywallVariant.proLimit),
    Routes.paywallMax: (_) =>
        const PaywallScreen(variant: PaywallVariant.max),
    Routes.planChangeUpgrade: (_) =>
        const PlanChangeScreen(direction: PlanChangeDirection.upgrade),
    Routes.planChangeDowngrade: (_) =>
        const PlanChangeScreen(direction: PlanChangeDirection.downgrade),
    Routes.purchaseProcessing: (_) => const PurchaseProcessingScreen(),
    Routes.purchaseSuccessPro: (_) =>
        const PurchaseSuccessScreen(tier: SubscriptionTier.pro),
    Routes.purchaseSuccessMax: (_) =>
        const PurchaseSuccessScreen(tier: SubscriptionTier.max),
    Routes.plansError: (_) => const PlansErrorScreen(),
    Routes.winbackSurvey: (_) => const WinbackSurveyScreen(),
    Routes.avatar: (_) => const AvatarScreen(),
    Routes.share: (_) => const ShareScreen(),
    Routes.alarms: (_) => const AlarmListScreen(),
    Routes.alarmAdd: (_) => const AlarmAddScreen(),
    Routes.alarmEmpty: (_) => const AlarmEmptyScreen(),
    Routes.records: (_) => const RecordListScreen(),
    // Archive is now an in-page tab of RecordListScreen; the route is kept for
    // deep links and opens the same page pre-selected on the 보관 tab.
    Routes.recordsArchive: (_) => const RecordListScreen(initialTab: 1),
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
    Routes.passwordNew: '새 비밀번호 설정',
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
    Routes.learningSentenceMain: '문장 결과',
    Routes.learningCallMain: '학습 결과',
    Routes.learningCallMainLoading: '학습 결과 로딩',
    Routes.pronunciationChallenge: '발음 챌린지',
    Routes.mypage: '마이페이지',
    Routes.mypageSettings: '마이페이지 · 설정',
    Routes.alarms: '알림',
    Routes.paymentHistory: '결제 내역',
  };

  final name = settings.name ?? Routes.onboarding;
  final builder = builders[name] ??
      (_) => PlaceholderScreen(names[name] ?? name);
  return _AppPageRoute<dynamic>(builder: builder, settings: settings);
}

/// Transient screen for the Supabase OAuth deep-link callback
/// (`…://login-callback?code=…`). supabase_flutter completes the PKCE code
/// exchange in the background (its app_links listener); this screen just pops
/// itself on the first frame so the AuthGate root shows through and re-routes to
/// home/onboarding when `onAuthStateChange` lands the session. A spinner covers
/// the brief gap. See the interception at the top of [onGenerateRoute].
class _OAuthCallbackScreen extends StatefulWidget {
  const _OAuthCallbackScreen();

  @override
  State<_OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends State<_OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// The app's page transition — a shared-axis style slide + fade.
///
/// Every route in the table above flows through here, so this is the single
/// place the app's navigation feel is defined. It replaces [MaterialPageRoute],
/// whose Android default is a full vertical slide that reads heavier than this
/// product wants and differs per platform.
///
/// The outgoing page dims and drifts slightly against the incoming one, giving
/// depth without a full-width slide. Durations and curves come from [AppMotion]
/// so pages match the component layer.
class _AppPageRoute<T> extends PageRoute<T> {
  _AppPageRoute({required this.builder, required RouteSettings settings})
      : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => AppMotion.page;

  @override
  Duration get reverseTransitionDuration => AppMotion.page;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final enter = CurvedAnimation(parent: animation, curve: AppMotion.pageCurve);
    // The page being covered drifts back and dims, so the incoming page reads
    // as stacked on top rather than sliding in beside it.
    final exit = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppMotion.pageCurve,
    );
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(exit),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.06, 0),
        ).animate(exit),
        child: FadeTransition(
          opacity: enter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(enter),
            child: child,
          ),
        ),
      ),
    );
  }
}
