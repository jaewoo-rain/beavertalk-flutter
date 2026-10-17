// 가입 동의 화면 — 빌드 72 · PM-DEC-735·736 · 명세 `04_동의화면명세.md` §8.
//
// - members/me: consent_required·consent_versions 를 읽는다 · 구서버(키 없음)는 false·빈 맵.
// - AuthGate: consentRequired 면 홈·온보딩보다 동의 화면이 먼저다(신규·기존 회원 공통).
// - 화면: 필수 하나라도 꺼지면 CTA 잠김 · 전체 동의는 개별 상태와 맞물린다.
// - 저장: 서버가 준 버전을 그대로 보낸다 · 실패하면 버튼이 다시 열린다.
// - 뒤로 가기: 로그아웃 확인 시트 · 로그아웃을 고르면 logout() · 계속을 고르면 남는다.

import 'package:beavertalk/app/auth_gate.dart';
import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/components/atoms/checkbox.dart';
import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/auth/data/models/member_dto.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/onboarding/onboarding_consent.dart';
import 'package:beavertalk/screens/onboarding/onboarding_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _versions = {
  'age14': 'v1',
  'terms': '2026-10-16',
  'privacy_collect': '2026-10-16',
  'overseas_transfer': '2026-10-16',
};

const _needsConsent = Member(
  memberId: 7,
  onboardingCompleted: true,
  consentRequired: true,
  consentVersions: _versions,
);

class _FakeAuth implements AuthRepository {
  _FakeAuth({this.fail = false});

  final bool fail;
  final sent = <Map<String, String>>[];

  @override
  Future<Member> submitConsents({
    required Map<String, String> versions,
    String? appVersion,
    String? platform,
    String? locale,
  }) async {
    sent.add(versions);
    if (fail) throw const ConflictFailure();
    return const Member(memberId: 7, onboardingCompleted: true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthedController extends AuthController {
  int logouts = 0;

  @override
  AuthStatus build() => AuthStatus.authenticated;

  @override
  Future<void> bootstrap() async {}

  @override
  Future<void> logout() async => logouts++;
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  Widget home, {
  required _FakeAuth auth,
  required _AuthedController controller,
  Member profile = _needsConsent,
  Locale locale = const Locale('ko'),
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: [
    authRepositoryProvider.overrideWithValue(auth),
    authControllerProvider.overrideWith(() => controller),
    myProfileProvider.overrideWith((ref) async => profile),
  ]);
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  ));
  await tester.pump(const Duration(milliseconds: 50));
  return container;
}

/// 시트·체크 애니메이션을 끝까지 돌린다(통화 화면 규칙상 pumpAndSettle 은 쓰지 않는다).
Future<void> _frames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

bool _ctaEnabled(WidgetTester tester) {
  return !tester.widget<Button>(find.byKey(const ValueKey('consent-cta'))).disabled;
}

Future<void> _tapCheck(WidgetTester tester, String key) async {
  await tester.tap(find.descendant(
    of: find.byKey(ValueKey(key)),
    matching: find.byType(GestureDetector),
  ).first);
  await _frames(tester);
}

void main() {
  setUp(() => PackageInfo.setMockInitialValues(
        appName: 'BeaverTalk',
        packageName: 'im.beavertalk',
        version: '1.0.0',
        buildNumber: '72',
        buildSignature: '',
      ));

  group('members/me 응답', () {
    test('consent_required·consent_versions 를 읽는다', () {
      final m = MemberDto.fromJson({
        'member_id': 1,
        'consent_required': true,
        'consent_versions': _versions,
      }).toEntity();
      expect(m.consentRequired, isTrue);
      expect(m.consentVersions, _versions);
    });

    test('구서버(키 없음)는 동의 화면을 띄우지 않는다', () {
      final m = MemberDto.fromJson({'member_id': 1}).toEntity();
      expect(m.consentRequired, isFalse);
      expect(m.consentVersions, isEmpty);
    });
  });

  group('AuthGate', () {
    testWidgets('동의가 남은 기존 회원(온보딩 완료)은 홈보다 동의 화면이 먼저', (tester) async {
      await _pump(tester, const AuthGate(), auth: _FakeAuth(), controller: _AuthedController());
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(OnboardingConsentScreen), findsOneWidget);
    });

    testWidgets('동의를 마친 신규 회원은 온보딩으로', (tester) async {
      await _pump(
        tester,
        const AuthGate(),
        auth: _FakeAuth(),
        controller: _AuthedController(),
        profile: const Member(memberId: 7, consentVersions: _versions),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(OnboardingConsentScreen), findsNothing);
      expect(find.byType(OnboardingLanguageScreen), findsOneWidget);
    });
  });

  group('동의 화면', () {
    testWidgets('필수 하나라도 꺼지면 잠김 · 전체 동의가 개별과 맞물린다', (tester) async {
      await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
          auth: _FakeAuth(), controller: _AuthedController());
      expect(_ctaEnabled(tester), isFalse);

      for (final i in ConsentItem.values.take(3)) {
        await _tapCheck(tester, 'consent-${i.code}');
      }
      expect(_ctaEnabled(tester), isFalse, reason: '3개만 켜짐');
      await _tapCheck(tester, 'consent-overseas_transfer');
      expect(_ctaEnabled(tester), isTrue, reason: '4개 모두 켜짐');
      expect(
        tester.widget<AppCheckbox>(find.byKey(const ValueKey('consent-all'))).value,
        isTrue,
        reason: '개별 4개가 다 켜지면 전체 동의도 켜짐',
      );

      await _tapCheck(tester, 'consent-terms');
      expect(_ctaEnabled(tester), isFalse);
      expect(
        tester.widget<AppCheckbox>(find.byKey(const ValueKey('consent-all'))).value,
        isFalse,
        reason: '하나를 끄면 전체 동의도 꺼짐',
      );

      await _tapCheck(tester, 'consent-all');
      expect(_ctaEnabled(tester), isTrue, reason: '전체 동의가 4개를 모두 켠다');
      await _tapCheck(tester, 'consent-all');
      expect(_ctaEnabled(tester), isFalse, reason: '전체 동의를 끄면 4개 모두 꺼진다');
    });

    testWidgets('서버가 준 버전을 그대로 보낸다', (tester) async {
      final auth = _FakeAuth();
      await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
          auth: auth, controller: _AuthedController());
      await _tapCheck(tester, 'consent-all');
      await tester.tap(find.byKey(const ValueKey('consent-cta')));
      await _frames(tester);
      expect(auth.sent, [_versions]);
    });

    testWidgets('저장이 실패하면 안내하고 버튼이 다시 열린다', (tester) async {
      final auth = _FakeAuth(fail: true);
      await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
          auth: auth, controller: _AuthedController());
      await _tapCheck(tester, 'consent-all');
      await tester.tap(find.byKey(const ValueKey('consent-cta')));
      await _frames(tester);
      expect(find.text('동의를 저장하지 못했어요. 다시 시도해 주세요.'), findsOneWidget);
      expect(_ctaEnabled(tester), isTrue);
    });

    testWidgets('뒤로 가기 → 로그아웃 시트 → 계속이면 남고, 로그아웃이면 logout()', (tester) async {
      final controller = _AuthedController();
      await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
          auth: _FakeAuth(), controller: controller);

      // GNB 뒤로 가기
      await tester.tap(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_BackButton'));
      await _frames(tester);
      expect(find.text('동의하지 않으면 로그아웃돼요'), findsOneWidget);
      await tester.tap(find.text('계속 동의하기'));
      await _frames(tester);
      expect(find.text('동의하지 않으면 로그아웃돼요'), findsNothing);
      expect(controller.logouts, 0);

      // 시스템 뒤로 가기
      await tester.binding.handlePopRoute();
      await _frames(tester);
      expect(find.text('동의하지 않으면 로그아웃돼요'), findsOneWidget, reason: '시스템 뒤로 가기도 같은 시트');
      await tester.tap(find.text('로그아웃'));
      await _frames(tester);
      expect(controller.logouts, 1);
    });

    testWidgets('국외 이전 시트 — 5행 · 거부 안내', (tester) async {
      await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
          auth: _FakeAuth(), controller: _AuthedController());
      await tester.tap(find.descendant(
        of: find.byKey(const ValueKey('consent-overseas_transfer')),
        matching: find.text('보기'),
      ));
      await _frames(tester);
      expect(find.textContaining('Google LLC'), findsNWidgets(4));
      expect(find.textContaining('Apple Inc.'), findsOneWidget);
      await tester.scrollUntilVisible(find.textContaining('contact@beavertalk.im'), 200,
          scrollable: find.byType(Scrollable).last);
      expect(find.textContaining('contact@beavertalk.im'), findsOneWidget);
    });
  });

  group('30개 언어 잘림(명세 §8-6)', () {
    for (final locale in AppLocalizations.supportedLocales) {
      testWidgets('${locale.toLanguageTag()} — 320 폭 · 화면과 두 시트 넘침 없음 · 항목 줄임표 없음', (tester) async {
        await _pump(tester, const OnboardingConsentScreen(member: _needsConsent),
            auth: _FakeAuth(), controller: _AuthedController(), locale: locale);
        tester.view.physicalSize = const Size(320, 640);
        await _frames(tester);
        final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingConsentScreen)));
        for (final label in [l10n.consentAge14, l10n.consentTerms, l10n.consentPrivacyCollect, l10n.consentOverseasTransfer]) {
          final text = tester.widget<Text>(find.text(label));
          expect(text.maxLines, isNull, reason: '항목 문구는 줄 수 제한 없이 감싼다');
          expect(text.overflow, isNot(TextOverflow.ellipsis));
        }
        for (final key in ['consent-privacy_collect', 'consent-overseas_transfer']) {
          final view = find.descendant(of: find.byKey(ValueKey(key)), matching: find.text(l10n.consentView));
          await tester.ensureVisible(view);
          await _frames(tester);
          await tester.tap(view);
          await _frames(tester);
          expect(tester.takeException(), isNull);
          final ok = find.text(l10n.confirm).last;
          await tester.ensureVisible(ok);
          await tester.tap(ok);
          await _frames(tester);
        }
        expect(tester.takeException(), isNull);
      });
    }
  });
}
