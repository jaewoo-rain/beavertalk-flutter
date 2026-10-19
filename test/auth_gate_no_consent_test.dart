// 가입 동의 화면 제거(10-19 사용자 지시 · PM-DEC-816) — 서버가 consent_required 를 보내도
// AuthGate 는 동의 화면 없이 온보딩·홈으로 간다. 동의는 가입·로그인 화면의 약관·처리방침 안내로 받는다.

import 'package:beavertalk/app/auth_gate.dart';
import 'package:beavertalk/features/auth/data/models/member_dto.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/onboarding/onboarding_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _AuthedController extends AuthController {
  @override
  AuthStatus build() => AuthStatus.authenticated;

  @override
  Future<void> bootstrap() async {}
}

void main() {
  testWidgets('consent_required=true 회원도 동의 화면 없이 온보딩으로 간다', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final member = MemberDto.fromJson({
      'member_id': 7,
      'onboarding_completed': false,
      'consent_required': true,
      'consent_versions': {'terms': '2026-10-16'},
    }).toEntity();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(_AuthedController.new),
        myProfileProvider.overrideWith((ref) async => member),
      ],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AuthGate(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(OnboardingLanguageScreen), findsOneWidget);
    expect(find.text('서비스 이용을 위해 동의해 주세요'), findsNothing);
  });
}
