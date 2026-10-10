// 국적 선택(모국어와 별개) — 2026-10-10 PM-DEC-487·490·495·498·502.
//
// - 국가 표: 249개 · 영어 국가명 · 서버·웹과 같은 표(국적 모델 라벨 41개는 모델 표기).
// - 온보딩 2/4: 처음엔 미선택 · 고르기 전 「다음으로」 비활성 · 고른 값은 초안에만.
// - 마이페이지: 현재 값에서 바뀌어야 Save 활성 · 저장만(전송은 다음 통화 끝 서버 몫).
// - 통화 소켓 쿼리에 기기 값(client_session · os · …)이 붙는다.

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/components/molecules/country_select.dart';
import 'package:beavertalk/components/organisms/nationality_list.dart';
import 'package:beavertalk/core/device/client_info.dart';
import 'package:beavertalk/core/i18n/countries.g.dart';
import 'package:beavertalk/core/network/ws_url.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/auth/presentation/providers/signup_draft_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/nationality.dart';
import 'package:beavertalk/screens/onboarding/onboarding_nationality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuth implements AuthRepository {
  final saved = <String>[];

  @override
  Future<Member> updateActualNationality(String iso) async {
    saved.add(iso);
    return Member(memberId: 1, actualNationality: iso);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 국적 열이 없는 구서버 — PATCH 는 200 이지만 응답에 actual_nationality 가 없다.
class _OldServerAuth implements AuthRepository {
  int calls = 0;

  @override
  Future<Member> updateActualNationality(String iso) async {
    calls++;
    return const Member(memberId: 1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  Widget screen, {
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: screen,
      routes: {Routes.onboardingName: (_) => const Text('NAME_STEP')},
    ),
  ));
  await tester.pump(const Duration(milliseconds: 50));
  return container;
}

Finder get _primaryButton => find.byWidgetPredicate(
      (w) => w is Semantics && (w.properties.button ?? false),
    );

Future<void> _search(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField).first, text);
  await tester.pump();
}

void main() {
  group('국가 표', () {
    test('249개 · 모델 라벨 표기 · 알파벳 머리', () {
      expect(kCountries.length, 249);
      expect(countryNameFor('KR'), 'Korea');
      expect(countryNameFor('ru'), 'Russia');
      expect(countryNameFor('US'), 'United States');
      expect(countryNameFor('XX'), isNull);
      expect(kCountries.first, ('AF', 'Afghanistan'));
    });

    test('검색 — 이름 일부(대소문자 무시) 또는 ISO', () {
      expect(filterCountries('phil').map((c) => c.$1), ['PH']);
      expect(filterCountries('KR').map((c) => c.$1), contains('KR'));
      expect(filterCountries(''), kCountries);
      expect(filterCountries('zzzz'), isEmpty);
    });
  });

  group('기기 값(통화 소켓 쿼리)', () {
    setUp(() => dotenv.testLoad(fileInput: 'API_BASE_URL=https://example.test\n'));
    tearDown(() {
      ClientInfo.debugSet(const {});
      dotenv.clean();
    });

    test('device_type 은 짧은 변 600 기준 · 모르면 null', () {
      expect(ClientInfo.deviceTypeFor(375), 'phone');
      expect(ClientInfo.deviceTypeFor(810), 'tablet');
      expect(ClientInfo.deviceTypeFor(null), isNull);
    });

    test('일반 통화 소켓 주소에 기기 값이 붙는다 · 비면 토큰만', () {
      ClientInfo.debugSet(const {});
      expect(normalcallWsUrl('tok'), endsWith('/calls/stream?token=tok'));
      ClientInfo.debugSet(const {
        'client_session': 'abc-1',
        'os': 'android',
        'app_version': '1.0.1+55',
      });
      final url = normalcallWsUrl('tok');
      expect(url, contains('token=tok&client_session=abc-1&os=android'));
      expect(url, contains('app_version=1.0.1%2B55'));
    });
  });

  group('온보딩 2/4', () {
    testWidgets('미선택으로 시작 · 고르기 전 「다음으로」 비활성 · 고르면 초안에 담고 이름 단계로',
        (tester) async {
      final container = await _pump(tester, const OnboardingNationalityScreen());
      final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingNationalityScreen)));
      expect(find.text(l10n.nationalityUsageNotice), findsOneWidget);
      expect(find.text('2/4'), findsOneWidget);

      await tester.tap(find.text(l10n.continueLabel));
      await tester.pump();
      expect(find.text('NAME_STEP'), findsNothing, reason: '미선택이면 넘어가지 않는다');

      await _search(tester, 'Philipp');
      await tester.tap(find.widgetWithText(CountrySelect, 'Philippines'));
      await tester.pump();
      await tester.tap(find.text(l10n.continueLabel));
      await tester.pumpAndSettle();
      expect(container.read(signupDraftProvider).actualNationality, 'PH');
      expect(find.text('NAME_STEP'), findsOneWidget);
    });

    testWidgets('목록을 스크롤해도 검색창은 위에 고정된다(사용자 10-10)', (tester) async {
      await _pump(tester, const OnboardingNationalityScreen());
      final before = tester.getRect(find.byType(TextField).first);
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.getRect(find.byType(TextField).first), before);
      expect(find.text('Afghanistan'), findsNothing, reason: '목록은 실제로 스크롤됐다');
    });

    testWidgets('검색 결과가 없으면 안내', (tester) async {
      await _pump(tester, const OnboardingNationalityScreen());
      final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingNationalityScreen)));
      await _search(tester, 'zzzz');
      expect(find.text(l10n.nationalitySearchEmpty), findsOneWidget);
      expect(find.byType(CountrySelect), findsNothing);
    });
  });

  group('마이페이지 국적 화면', () {
    testWidgets('현재 국적이 「Current」 에 선택 표시 · 같은 나라면 Save 비활성 · 바꾸면 저장만',
        (tester) async {
      final auth = _FakeAuth();
      await _pump(
        tester,
        const MyPageNationalityScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          myProfileProvider.overrideWith(
            (ref) async => const Member(memberId: 1, actualNationality: 'VN'),
          ),
        ],
      );
      await tester.pump(const Duration(milliseconds: 50));
      final l10n = AppLocalizations.of(tester.element(find.byType(MyPageNationalityScreen)));
      expect(find.text(l10n.nationalityCurrent), findsOneWidget);
      final current = tester.widget<CountrySelect>(find.widgetWithText(CountrySelect, 'Vietnam').first);
      expect(current.selected, isTrue);

      await tester.tap(find.text(l10n.ctaSave));
      await tester.pump();
      expect(auth.saved, isEmpty, reason: '바뀌기 전에는 저장하지 않는다');

      await _search(tester, 'Japan');
      expect(find.text(l10n.nationalityCurrent), findsNothing, reason: '검색 중에는 「Current」 를 숨긴다');
      await tester.tap(find.widgetWithText(CountrySelect, 'Japan'));
      await tester.pump();
      await tester.tap(find.text(l10n.ctaSave));
      await tester.pump(const Duration(milliseconds: 100));
      expect(auth.saved, ['JP']);
    });

    testWidgets('구서버(국적 필드를 무시하고 돌려줌)여도 Save 뒤 오류 없이 화면을 닫는다', (tester) async {
      final auth = _OldServerAuth();
      await tester.pumpWidget(const SizedBox.shrink());
      final container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        myProfileProvider.overrideWith((ref) async => const Member(memberId: 1)),
      ]);
      addTearDown(container.dispose);
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const MyPageNationalityScreen()),
              ),
              child: const Text('OPEN'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('OPEN'));
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(MyPageNationalityScreen)));
      await _search(tester, 'Japan');
      await tester.tap(find.widgetWithText(CountrySelect, 'Japan'));
      await tester.pump();
      await tester.tap(find.text(l10n.ctaSave));
      await tester.pumpAndSettle();
      expect(auth.calls, 1);
      expect(find.byType(MyPageNationalityScreen), findsNothing, reason: '오류 스낵바 없이 설정으로 돌아간다');
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('미선택 회원 — 「Current」 묶음 없이 시작 · 지우는 버튼 없음', (tester) async {
      await _pump(
        tester,
        const MyPageNationalityScreen(),
        overrides: [
          myProfileProvider.overrideWith((ref) async => const Member(memberId: 1)),
        ],
      );
      await tester.pump(const Duration(milliseconds: 50));
      final l10n = AppLocalizations.of(tester.element(find.byType(MyPageNationalityScreen)));
      expect(find.text(l10n.nationalityCurrent), findsNothing);
      expect(find.text(l10n.nationalityNotSet), findsNothing, reason: 'Not set 으로 되돌리는 길은 없다(PM-DEC-502)');
      expect(_primaryButton, findsWidgets);
    });
  });
}
