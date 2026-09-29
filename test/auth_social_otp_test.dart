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

/// 브라우저 SNS 로그인이 딥링크로 돌아와 세션이 선 것처럼 — 부른 뒤 authenticated 가 된다.
class _LandingAuth extends AuthController {
  @override
  AuthStatus build() => AuthStatus.unauthenticated;

  @override
  Future<void> signInWithKakao() async {
    _calls.add('kakao');
    state = AuthStatus.authenticated;
  }
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

  testWidgets('F120 — 가입 화면에서 브라우저 SNS 로그인이 끝나면 인증 흐름을 닫는다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    _calls.clear();
    await tester.pumpWidget(ProviderScope(
      overrides: [authControllerProvider.overrideWith(_LandingAuth.new)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SignupScreen())),
            child: const Text('ROOT'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('ROOT'));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    await tester.tap(find.byType(KakaoIcon));
    await tester.pumpAndSettle();
    expect(_calls, ['kakao']);
    expect(find.byType(SignupScreen), findsNothing, reason: 'Google 처럼 닫혀야 한다');
    expect(find.text('ROOT'), findsOneWidget);
  });

  group('OtpInput — 숨은 입력칸 1개 + 칸 6개', () {
    Future<List<String>> pump(WidgetTester tester) async {
      final values = <String>[];
      await tester.pumpWidget(_app(Scaffold(
        body: OtpInput(length: 6, onChanged: values.add),
      )));
      return values;
    }

    final field = find.byType(TextField);

    /// 키보드로 한 글자씩 친 것처럼 — 입력칸 값이 한 단계씩 바뀐다.
    Future<void> typeSeq(WidgetTester tester, List<String> steps) async {
      for (final v in steps) {
        await tester.enterText(field, v);
      }
      await tester.pump();
    }

    /// 칸에 그려진 숫자(보이는 것).
    List<String> boxes(WidgetTester tester) => [
          for (final t in tester.widgetList<Text>(find.descendant(
              of: find.byType(OtpInput), matching: find.byType(Text))))
            t.data ?? '',
        ];

    testWidgets('입력칸은 하나 · 칸마다 숫자를 차례로 그린다', (tester) async {
      final values = await pump(tester);
      expect(field, findsOneWidget);
      await typeSeq(tester, ['1', '12', '123']);
      expect(values.last, '123');
      expect(boxes(tester), ['1', '2', '3', '', '', '']);
    });

    testWidgets('F118 — 백스페이스는 마지막 숫자부터 지운다(빈 칸 키 이벤트 불필요)', (tester) async {
      final values = await pump(tester);
      await typeSeq(tester, ['1', '12', '123', '1234', '12345', '123456']);
      await typeSeq(tester, ['12345', '1234', '123']);
      expect(values.last, '123');
      expect(boxes(tester), ['1', '2', '3', '', '', '']);
    });

    testWidgets('F122 — 지운 자리에 다시 친 숫자가 들어간다(앞 칸을 덮지 않는다)', (tester) async {
      final values = await pump(tester);
      await typeSeq(tester, ['1', '12', '123', '1234']);
      await typeSeq(tester, ['123', '1237']);
      expect(values.last, '1237');
      expect(boxes(tester).take(4), ['1', '2', '3', '7']);
    });

    testWidgets('F121 — 5번째를 고쳐 쳐도 한 글자는 한 칸 · 6번째를 덮지 않는다', (tester) async {
      final values = await pump(tester);
      await typeSeq(tester, ['1', '12', '123', '1234', '12345', '123456']);
      // 5번째를 9로: 두 번 지우고 9, 6.
      await typeSeq(tester, ['12345', '1234', '12349', '123496']);
      expect(values.last, '123496');
    });

    testWidgets('F119 — 붙여넣기·코드 추천은 차례로 채우고 길이에서 자른다', (tester) async {
      final values = await pump(tester);
      await typeSeq(tester, ['6543210']);
      expect(values.last, '654321');
      await typeSeq(tester, ['12a34']);
      expect(values.last, '1234', reason: '숫자만');
    });

    testWidgets('캐럿은 늘 끝 — 가운데로 옮겨도 다음 숫자는 첫 빈 칸', (tester) async {
      await pump(tester);
      await typeSeq(tester, ['1', '12', '123']);
      final c = tester.widget<TextField>(field).controller!;
      c.selection = const TextSelection.collapsed(offset: 1);
      expect(c.selection.baseOffset, 3);
    });
  });
}
