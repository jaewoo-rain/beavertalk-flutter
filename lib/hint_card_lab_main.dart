// Hint-card LAB — 통화 없이 **힌트 카드만** 브라우저에 띄워 눈으로 본다.
//
// 왜 있나: 실제 힌트 카드는 통화가 붙고(로그인 + WS) 서버가 `hint` 프레임을 보낸
// 뒤에야 화면에 나온다. 게다가 책갈피 버튼은 서버가 `examples[].id` 를 붙여야
// 뜨는데 **아직 안 붙는다** — 그래서 실앱을 띄워도 지금은 볼 수가 없다.
// 이 랩은 `HintCard` 를 실앱과 같은 테마·l10n 위에서 그대로 렌더한다.
//
// ⚠ 서버를 안 탄다. 책갈피 탭은 공유 인메모리 스토어([bookmarkedSentenceIds])만
// 뒤집는다 — 여기서 잘 돌아간다고 `PATCH /sentences/{id}/bookmark` 배선이
// 검증된 것은 아니다. 그건 실통화에서만 확인된다.
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

/// 서버가 `id` 를 붙여 보낸 힌트 — 책갈피 버튼이 뜨는 쪽.
const _withIds = <HintExample>[
  HintExample(
    korean: '화장실이 어디예요?',
    roman: 'hwajangsiri eodiyeyo?',
    native: 'Where is the restroom?',
    sentenceId: 101,
  ),
  HintExample(
    korean: '잠깐 다녀올게요.',
    roman: 'jamkkan danyeoolgeyo.',
    native: "I'll be right back.",
    sentenceId: 102,
  ),
  HintExample(
    korean: '이따가 다시 얘기해요.',
    roman: 'ittaga dasi yaegihaeyo.',
    native: "Let's talk again later.",
    sentenceId: 103,
  ),
];

/// 지금 서버가 실제로 보내는 모양 — `id` 가 없다. 버튼이 없어야 정상이다.
const _withoutIds = <HintExample>[
  HintExample(
    korean: '화장실이 어디예요?',
    roman: 'hwajangsiri eodiyeyo?',
    native: 'Where is the restroom?',
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
                    '책갈피 없음: 아직 "펼쳐 본" 표현이 아니다.',
                    HintCard(
                      examples: _withIds,
                      revealed: _peekRevealed,
                      index: _peekIndex,
                      bookmarked: _isSaved(_withIds[_peekIndex]),
                      onBookmarkTap: () => _toggle(_withIds[_peekIndex]),
                      onReveal: () => setState(() => _peekRevealed = true),
                      onCycle: () => setState(
                          () => _peekIndex = (_peekIndex + 1) % _withIds.length),
                    ),
                  ),
                  _section(
                    context,
                    'full — 서버가 id 를 보낸 뒤 (이번 작업)',
                    '오른쪽 책갈피를 탭 → 채워진다. ↻ 로 예시를 넘기면 '
                        '책갈피도 그 예시 것으로 바뀐다.',
                    HintCard(
                      examples: _withIds,
                      revealed: true,
                      index: _fullIndex,
                      bookmarked: _isSaved(_withIds[_fullIndex]),
                      onBookmarkTap: () => _toggle(_withIds[_fullIndex]),
                      onReveal: () {},
                      onCycle: () => setState(
                          () => _fullIndex = (_fullIndex + 1) % _withIds.length),
                    ),
                  ),
                  _section(
                    context,
                    'full — 지금 서버 (id 없음)',
                    '책갈피 버튼이 아예 없다. 서버 배포 전 화면은 이 모양 그대로다.',
                    HintCard(
                      examples: _withoutIds,
                      revealed: true,
                      index: 0,
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

  bool _isSaved(HintExample ex) =>
      ex.sentenceId != null &&
      bookmarkedSentenceIds.value.contains(ex.sentenceId);

  /// 실화면과 달리 **서버를 안 탄다** — 인메모리 스토어만 뒤집는다.
  void _toggle(HintExample ex) {
    final id = ex.sentenceId;
    if (id == null) return;
    toggleBookmark(id);
    setState(() {});
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
