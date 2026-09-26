import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 앱 GA4 계측 — 이벤트를 보내는 **유일한 입구**.
///
/// 정본: `claude_code/_shared/비버톡_GA4_계측_인수인계_2026-09-21.md` 4장.
/// 웹(accent)과는 **다른 GA4 속성**이다. 같은 개념은 웹과 같은 이벤트 이름을 쓴다
/// (`call_started`·`call_ended`).
///
/// ## 수집 스위치 — 기본은 꺼짐
///
/// `--dart-define=GA_COLLECT=true` 로 구운 빌드에서만 수집한다. 그 외(디버그 실행,
/// 내부 테스트용 릴리스, dogfood)는 **한 건도 안 보낸다**(2026-09-26 사장님 결정
/// 「디버그랑 dogfood 둘다 차단」). 이 앱은 flavor 가 없어 dogfood 와 운영이 같은
/// 패키지·같은 릴리스 빌드이므로, 빌드 모드로는 둘을 못 가른다 — 그래서 스위치가
/// 컴파일 시점 값이다. ⚠ 스토어 **운영 트랙** 빌드에는 반드시 넣는다.
///
/// 매니페스트가 `firebase_analytics_collection_enabled=false` 로 SDK 자동 수집
/// (first_open·session_start 등)까지 막아 두고, [start] 가 스위치가 켜진 빌드에서만
/// 런타임에 연다. 꺼진 빌드는 [start] 가 명시적으로 `false` 를 다시 쓴다 — 이 설정은
/// 기기에 **저장돼 다음 실행까지 남기** 때문에, 수집 빌드 위에 덮어 설치한 비수집
/// 빌드가 이전 값을 물려받지 않게 하려는 것이다.
///
/// ## 초기화 순서
///
/// Firebase 초기화 위치는 **옮기지 않는다.** `main()` 에서 await 하면 콜드스타트마다
/// 수신 콜 구독(`attach()`)이 밀려 CallKit 수락이 소멸한다(`lib/main.dart` 주석,
/// `push_bootstrap.dart` 46~53). [start] 는 푸시 부트스트랩의 `firebase init` 단계
/// **뒤에서** 불린다. 그 전에 들어온 이벤트·화면은 [_queue] 에 모았다가 보낸다.
///
/// iOS 는 `ios/Runner/GoogleService-Info.plist`(gitignore, 2026-09-26 등록 앱
/// `1:333511894671:ios:e6acb87a8fff3f845932fa`)가 있어야 초기화된다. 없으면 조용히 꺼진다.
/// IDFA 제외는 SPM 빌드에서 환경변수 `FIREBASE_ANALYTICS_WITHOUT_ADID=true` 로 한다.
const bool kAnalyticsCollect = bool.fromEnvironment('GA_COLLECT');

/// 커스텀 이벤트 이름 — 여기 말고 다른 곳에 문자열로 쓰지 않는다.
abstract final class AppEvent {
  /// GA4 권장 이벤트. 파라미터 `method`(email·google·kakao·facebook·apple).
  static const login = 'login';

  /// GA4 권장 이벤트. 온보딩 제출 = 가입 완료. 파라미터 `method`.
  static const signUp = 'sign_up';

  /// 서버가 통화 시작을 확정(`call_started`). 파라미터 `course`. 웹과 같은 이름.
  static const callStarted = 'call_started';

  /// 통화 종료. 파라미터 `seconds`. 웹과 같은 이름.
  static const callEnded = 'call_ended';

  /// 통화 분석 결과 화면 표시.
  static const analysisViewed = 'analysis_viewed';

  /// 발음 챌린지 결과 표시. 파라미터 `score`, `ended_by`(game_over·user).
  static const challengeCompleted = 'challenge_completed';
}

class AppAnalytics {
  AppAnalytics._();

  static final AppAnalytics instance = AppAnalytics._();

  FirebaseAnalytics? _fa;
  bool _started = false;

  /// [start] 전에 들어온 호출. 부팅 중 첫 화면이 여기 쌓인다.
  final List<Future<void> Function(FirebaseAnalytics)> _queue = [];
  static const _queueCap = 50;

  /// 로그인 버튼을 누른 방법. OAuth 는 브라우저를 거쳐 비동기로 끝나므로
  /// `signedIn` 이벤트가 올 때 이 값을 붙여 `login` 을 한 번 보낸다.
  String? _pendingLoginMethod;

  StreamSubscription<AuthState>? _authSub;

  bool get _enabled => kAnalyticsCollect && !kIsWeb;

  /// Firebase 초기화 뒤 한 번. 여러 번 불려도 된다. 실패해도 앱을 막지 않는다.
  Future<void> start() async {
    if (kIsWeb || _started) return;
    _started = true;
    try {
      // 푸시 부트스트랩이 이미 초기화했으면 기존 기본 앱을 돌려주는 no-op 이다.
      await Firebase.initializeApp();
      final fa = FirebaseAnalytics.instance;
      if (!kAnalyticsCollect) {
        await fa.setAnalyticsCollectionEnabled(false);
        return;
      }
      // 광고 동의는 전 항목 거부 — 처리방침 제13조 ⑤(맞춤형 광고 행태정보 미수집).
      await fa.setConsent(
        adStorageConsentGranted: false,
        adUserDataConsentGranted: false,
        adPersonalizationSignalsConsentGranted: false,
        analyticsStorageConsentGranted: true,
      );
      await fa.setAnalyticsCollectionEnabled(true);
      _fa = fa;
      _watchAuth();
      final pending = List.of(_queue);
      _queue.clear();
      for (final send in pending) {
        await _guard(send(fa));
      }
    } catch (e) {
      _queue.clear();
      if (kDebugMode) debugPrint('[analytics] 시작 실패(무시): $e');
    }
  }

  /// 커스텀 이벤트 1건. 이름은 [AppEvent] 에서만 가져온다.
  void log(String name, [Map<String, Object>? params]) =>
      _send((fa) => fa.logEvent(name: name, parameters: params));

  /// 화면 조회 1건. [AnalyticsRouteObserver] 가 라우트 이름으로 부른다.
  void screen(String name) =>
      _send((fa) => fa.logScreenView(screenName: name, screenClass: name));

  /// 로그인 시도 방법을 적어 둔다. 성공(`signedIn`) 시 `login` 에 실린다.
  void noteLoginMethod(String method) {
    if (_enabled) _pendingLoginMethod = method;
  }

  /// 가입 완료(온보딩 제출). 방법은 Supabase 계정의 공급자에서 읽는다.
  void logSignUp() {
    if (!_enabled) return;
    final provider = Supabase
        .instance.client.auth.currentUser?.appMetadata['provider'] as String?;
    log(AppEvent.signUp, {'method': provider ?? 'unknown'});
  }

  void _send(Future<void> Function(FirebaseAnalytics) call) {
    if (!_enabled) return;
    final fa = _fa;
    if (fa == null) {
      if (_queue.length < _queueCap) _queue.add(call);
      return;
    }
    unawaited(_guard(call(fa)));
  }

  Future<void> _guard(Future<void> f) => f.catchError((Object e) {
        if (kDebugMode) debugPrint('[analytics] 전송 실패(무시): $e');
      });

  /// user_id = Supabase 사용자 UUID. 이메일 등 신원이 드러나는 값은 쓰지 않는다
  /// (Google 정책). 로그아웃·탈퇴는 `signedOut` 으로 해제된다.
  void _watchAuth() {
    _authSub ??=
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final fa = _fa;
      if (fa == null) return;
      switch (data.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          final id = data.session?.user.id;
          if (id != null) unawaited(_guard(fa.setUserId(id: id)));
          if (data.event == AuthChangeEvent.signedIn) {
            final method = _pendingLoginMethod;
            _pendingLoginMethod = null;
            if (method != null) log(AppEvent.login, {'method': method});
          }
        case AuthChangeEvent.signedOut:
          _pendingLoginMethod = null;
          unawaited(_guard(fa.setUserId(id: null)));
        default:
          break;
      }
    });
  }
}

/// 이름 있는 페이지 라우트를 화면 조회로 보고한다.
///
/// `FirebaseAnalyticsObserver` 를 쓰지 않는 이유: 그 옵저버는 생성 인자로
/// `FirebaseAnalytics.instance` 를 받는데, `MaterialApp` 이 만들어지는 시점에는
/// Firebase 가 아직 초기화 전이라 `[core/no-app]` 으로 죽는다. 이 옵저버는
/// Firebase 를 건드리지 않고 [AppAnalytics] 큐로만 넘긴다.
///
/// 이름 없는 라우트(`MaterialPageRoute` 직접 push)·다이얼로그·시트는 건너뛴다.
/// 이름 없는 화면을 추적하려면 push 할 때 `RouteSettings(name:)` 을 준다.
class AnalyticsRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  void _report(Route<dynamic>? route) {
    if (route is! PageRoute) return;
    final name = route.settings.name;
    if (name == null || name.isEmpty) return;
    AppAnalytics.instance.screen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _report(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _report(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // 뒤로 가서 드러난 화면도 조회로 센다(GA4 앱 화면 추적 관례).
    // 닫힌 것이 다이얼로그·시트면 화면은 바뀌지 않았다 — 세지 않는다
    // (2026-09-26 실기기: 통화 중 시트가 닫힐 때 `/call` → `/call` 이 찍혔다).
    if (route is! PageRoute) return;
    _report(previousRoute);
  }
}
