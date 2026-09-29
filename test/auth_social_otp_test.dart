import 'package:beavertalk/components/icons/brand_icons.dart';
import 'package:beavertalk/components/molecules/otp_input.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/auth/login_form.dart';
import 'package:beavertalk/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 09-29 iPhone build 46 — 회원가입 SNS 버튼 무반응(F117) · 코드 칸 지우기(F118) · 코드 오류(F119).

/// 부른 SNS 흐름 — 노티파이어 공개 필드는 riverpod_lint 가 막아 바깥에 둔다.
final _calls = <String>[];

class _RecordingAuth extends AuthController {
  @override
  AuthStatus build() => AuthStatus.unauthenticated;

  @override
  Future<void> signInWithKakao() async => _calls.add('kakao');

  @override
  Future<void> signInWithFacebook() async => _calls.add('facebook');

  @override
  Future<void> signInWithApple() async => _calls.add('apple');
}

Widget _app(Widget home, {List<Override> overrides = const []}) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );

void main() {
  testWidgets('F117 — 회원가입 SNS 버튼이 로그인과 같은 흐름을 부른다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    _calls.clear();
    await tester.pumpWidget(_app(const SignupScreen(),
        overrides: [authControllerProvider.overrideWith(_RecordingAuth.new)]));
    await tester.pump();
    for (final icon in [KakaoIcon, FacebookIcon, AppleIcon]) {
      await tester.tap(find.byType(icon));
      await tester.pump();
    }
    expect(_calls, ['kakao', 'facebook', 'apple']);
  });

  testWidgets('F117 — 이메일 로그인 폼의 SNS 아이콘은 가입 화면이 아니라 바로 로그인', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    _calls.clear();
    await tester.pumpWidget(_app(const LoginFormScreen(),
        overrides: [authControllerProvider.overrideWith(_RecordingAuth.new)]));
    await tester.pump();
    for (final icon in [KakaoIcon, AppleIcon]) {
      await tester.tap(find.byType(icon));
      await tester.pump();
    }
    expect(_calls, ['kakao', 'apple']);
    expect(find.byType(SignupScreen), findsNothing);
  });

  group('OtpInput — 소프트 키보드', () {
    Future<List<String>> pump(WidgetTester tester) async {
      final values = <String>[];
      await tester.pumpWidget(_app(Scaffold(
        body: OtpInput(length: 6, onChanged: values.add),
      )));
      return values;
    }

    Finder box(int i) => find.byType(TextField).at(i);
    EditableText editable(WidgetTester t, int i) =>
        t.widget<EditableText>(find.byType(EditableText).at(i));

    testWidgets('F119 — 채워진 칸에 새 숫자를 치면 바뀐다(옛 숫자가 남지 않는다)', (tester) async {
      final values = await pump(tester);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(box(i), '${i + 1}');
      }
      expect(values.last, '123456');
      // 3번째 칸을 눌러 9를 친다 — 칸에는 「3」 뒤에 「9」가 붙어 들어온다.
      await tester.enterText(box(2), '39');
      expect(values.last, '129456');
    });

    testWidgets('F119 — 코드 전체가 한 번에 오면 칸마다 나눠 담는다', (tester) async {
      final values = await pump(tester);
      await tester.enterText(box(0), '654321');
      await tester.pump();
      expect(values.last, '654321');
    });

    testWidgets('F118 — 칸의 숫자를 지우면 앞 칸으로 가서 이어서 지운다', (tester) async {
      final values = await pump(tester);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(box(i), '${i + 1}');
      }
      await tester.enterText(box(5), '');
      await tester.pump();
      expect(editable(tester, 4).focusNode.hasFocus, isTrue);
      await tester.enterText(box(4), '');
      await tester.pump();
      expect(editable(tester, 3).focusNode.hasFocus, isTrue);
      expect(values.last, '1234');
    });
  });
}
