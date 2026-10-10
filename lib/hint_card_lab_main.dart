// Hint-card LAB — 통화 없이 **힌트 카드만** 브라우저에 띄워 눈으로 본다.
//
// 왜 있나: 실제 힌트 카드는 통화가 붙고(로그인 + WS) 서버가 `hint` 프레임을 보낸
// 뒤에야 화면에 나온다 — 통화 없이는 눈으로 볼 방법이 없다.
// 이 랩은 `HintCard` 를 실앱과 같은 테마·l10n 위에서 그대로 렌더한다.
//
// ⚠ 서버를 안 탄다. 실앱은 🔖 첫 탭에서 `POST /sentences/from-hint` 로 문장을 만들고
// 그 뒤 `PATCH /sentences/{id}/bookmark` 로 토글하는데, 랩은 그 자리를 가짜 id 와
// 인메모리 스토어로 대신한다 — 여기가 초록이어도 **배선이 검증된 것은 아니다.**
//
//   flutter run -d chrome --target lib/hint_card_lab_main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/molecules/hint_card.dart';
import 'features/normalcall/domain/entities/call_hint.dart';
import 'l10n/app_localizations.dart';
import 'mock/mock_data.dart';
import 'theme/app_color_tokens.dart';
import 'theme/app_spacing.dart';
import 'theme/app_typography.dart';

/// 서버가 보내는 그대로의 힌트 — **문장 id 가 없다.** 담는 순간에야 생긴다.
const _examples = <HintExample>[
  HintExample(
    korean: '화장실이 어디예요?',
    roman: 'hwajangsiri eodiyeyo?',
    native: 'Where is the restroom?',
  ),
  HintExample(
    korean: '잠깐 다녀올게요.',
    roman: 'jamkkan danyeoolgeyo.',
    native: "I'll be right back.",
  ),
  HintExample(
    korean: '이따가 다시 얘기해요.',
    roman: 'ittaga dasi yaegihaeyo.',
    native: "Let's talk again later.",
  ),
];

/// `native` 가 빈 예시 — 서버 담기 API 가 이걸 **필수(1자 이상)** 로 받아서 담을 수 없다.
/// 드물지만 모델이 뜻을 빼먹으면 실제로 생긴다.
const _noNative = <HintExample>[
  HintExample(
    korean: '화장실이 어디예요?',
    roman: 'hwajangsiri eodiyeyo?',
    native: '',
  ),
];

void main() => runApp(const ProviderScope(child: _App()));

class _App extends StatefulWidget {
  const _App();
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  ThemeMode _mode = ThemeMode.dark;
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        theme: _theme(Brightness.light, AppColorTokens.light),
        darkTheme: _theme(Brightness.dark, AppColorTokens.dark),
        themeMode: _mode,
        home: _Lab(
          mode: _mode,
          locale: _locale,
          onMode: (m) => setState(() => _mode = m),
          onLocale: (l) => setState(() => _locale = l),
        ),
      );

  /// `main.dart` 의 테마 빌더와 같은 구성 — 카드가 실앱과 같은 색으로 서야 한다.
  static ThemeData _theme(Brightness brightness, AppColorTokens tokens) {
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      platform: TargetPlatform.android,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.backgroundNormalDeep,
      fontFamily: kFontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.primaryNormal,
        brightness: brightness,
        primary: tokens.primaryNormal,
        onPrimary: tokens.primaryOnPrimary,
        surface: tokens.backgroundNormalNormal,
        onSurface: tokens.labelStrong,
        error: tokens.statusNegative,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: tokens.labelStrong,
        displayColor: tokens.labelStrong,
        fontFamily: kFontFamily,
      ),
      extensions: [tokens],
    );
  }
}

class _Lab extends StatefulWidget {
  const _Lab({
    required this.mode,
    required this.locale,
    required this.onMode,
    required this.onLocale,
  });

  final ThemeMode mode;
  final Locale locale;
  final ValueChanged<ThemeMode> onMode;
  final ValueChanged<Locale> onLocale;

  @override
  State<_Lab> createState() => _LabState();
}

class _LabState extends State<_Lab> {
  // 카드 3장이 각자 자기 상태를 갖는다 — 실화면에서 CallScreen 이 쥐고 있는 그것.
  bool _peekRevealed = false;
  int _peekIndex = 0;
  int _fullIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s32,
            vertical: AppSpacing.s24,
          ),
          child: Center(
            child: ConstrainedBox(
              // 통화 화면의 카드 폭(모바일 폭 - s32 좌우)에 맞춰 둔다. 데스크톱
              // 브라우저 전폭으로 늘어나면 실기기와 다른 줄바꿈을 보게 된다.
              constraints: const BoxConstraints(maxWidth: 390 - AppSpacing.s32 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _controls(context),
                  const SizedBox(height: AppSpacing.s24),
                  _section(
                    context,
                    'peek — 접힌 상태 (탭하면 펼쳐진다)',
                    '스피커·책갈피가 여기에도 있다. 버튼을 눌러도 카드는 안 펼쳐진다.',
                    HintCard(
                      examples: _examples,
                      revealed: _peekRevealed,
                      index: _peekIndex,
                      bookmarked: _isSaved(_examples[_peekIndex]),
                      onSpeak: () => _speak(_examples[_peekIndex]),
                      onBookmarkTap: () => _toggle(_examples[_peekIndex]),
                      onReveal: () => setState(() => _peekRevealed = true),
                      onCycle: () => setState(
                          () => _peekIndex = (_peekIndex + 1) % _examples.length),
                    ),
                  ),
                  _section(
                    context,
                    'full — 펼친 상태',
                    '책갈피를 탭 → 그 순간 문장이 만들어지고 채워진다. ↻ 로 예시를 '
                        '넘기면 책갈피도 그 예시 것으로 바뀐다.',
                    HintCard(
                      examples: _examples,
                      revealed: true,
                      index: _fullIndex,
                      bookmarked: _isSaved(_examples[_fullIndex]),
                      onSpeak: () => _speak(_examples[_fullIndex]),
                      onBookmarkTap: () => _toggle(_examples[_fullIndex]),
                      onReveal: () {},
                      onCycle: () => setState(
                          () => _fullIndex = (_fullIndex + 1) % _examples.length),
                    ),
                  ),
                  _section(
                    context,
                    'full — native(뜻)가 빈 예시',
                    '서버 담기 API 가 뜻을 필수로 받아 담을 수 없다. 버튼은 **그대로 '
                        '다 있고** 눌러 보면 이유를 말한다 — 숨지 않는다.',
                    HintCard(
                      examples: _noNative,
                      revealed: true,
                      index: 0,
                      onSpeak: () => _speak(_noNative[0]),
                      onBookmarkTap: () => _toggle(_noNative[0]),
                      onReveal: () {},
                      onCycle: () {},
                    ),
                  ),
                  _savedLine(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 랩의 가짜 통화 id — 실앱은 서버가 준 `call_id` 를 쓴다.
  static const _labCallId = 9999;

  /// 담아 본 힌트 → 문장 id. 실앱과 같은 구조다(실앱은 서버가 id 를 준다).
  final Map<String, int> _savedIds = <String, int>{};
  int _nextFakeId = 500;

  String _key(HintExample ex) => '$_labCallId|${ex.korean.trim()}';

  bool _isSaved(HintExample ex) {
    final id = _savedIds[_key(ex)];
    return id != null && bookmarkedSentenceIds.value.contains(id);
  }

  /// 실화면과 달리 **서버를 안 탄다** — 첫 담기에서 서버가 문장을 만들어 주는 자리를
  /// 가짜 id 로 대신하고, 그 뒤 토글만 인메모리 스토어로 흉내 낸다.
  ///
  /// 실앱은 여기서 `POST /sentences/from-hint` → `PATCH /sentences/{id}/bookmark` 로 간다.
  void _toggle(HintExample ex) {
    final l10n = AppLocalizations.of(context);
    // 서버가 native 를 필수로 받는다 — 실앱과 같은 안내를 낸다.
    if (ex.native.trim().isEmpty) {
      _snack(l10n.saveSentenceFailed);
      return;
    }
    final key = _key(ex);
    final id = _savedIds[key] ?? (_savedIds[key] = _nextFakeId++);
    toggleBookmark(id);
    setState(() {});
  }

  /// 실앱은 `POST /tts/speech` 로 캐릭터 목소리 mp3 를 받아 재생한다. 랩은 서버를 안
  /// 타므로 **무엇이 재생될지만** 알린다.
  void _speak(HintExample ex) => _snack('재생: ${ex.korean}');

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _controls(BuildContext context) {
    final dark = widget.mode == ThemeMode.dark;
    final ko = widget.locale.languageCode == 'ko';
    return Row(
      children: [
        _chip(context, dark ? 'Dark' : 'Light',
            () => widget.onMode(dark ? ThemeMode.light : ThemeMode.dark)),
        const SizedBox(width: AppSpacing.s8),
        _chip(context, ko ? '한국어' : 'English',
            () => widget.onLocale(Locale(ko ? 'en' : 'ko'))),
      ],
    );
  }

  Widget _chip(BuildContext context, String text, VoidCallback onTap) {
    return Material(
      color: context.c.backgroundElevatedNormal,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(text,
              style:
                  AppType.caption1.sb.copyWith(color: context.c.labelStrong)),
        ),
      ),
    );
  }

  Widget _section(
      BuildContext context, String title, String note, Widget card) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  AppType.caption1.sb.copyWith(color: context.c.accentActive)),
          const SizedBox(height: AppSpacing.s2),
          Text(note,
              style:
                  AppType.caption2.r.copyWith(color: context.c.labelNormal)),
          const SizedBox(height: AppSpacing.s8),
          card,
        ],
      ),
    );
  }

  /// 저장된 id 를 그대로 보여준다 — 어느 문장이 보관함으로 갈지 눈으로 확인하는 줄.
  Widget _savedLine(BuildContext context) {
    final ids = bookmarkedSentenceIds.value.toList()..sort();
    return Text(
      'bookmarkedSentenceIds: ${ids.isEmpty ? '(비어 있음)' : ids.join(', ')}',
      style: AppType.caption2.r.copyWith(color: context.c.labelNormal),
    );
  }
}
