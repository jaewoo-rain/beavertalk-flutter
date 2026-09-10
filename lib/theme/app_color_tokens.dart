import 'package:flutter/material.dart';

/// The Figma `Semantics` colour collection, both modes, verbatim.
///
/// Values were read off the `Color - Semantic` chip page with
/// `get_variable_defs` on 2026-07-17 — Dark `3702:39952`, Light `3702:39951`,
/// 70 tokens each — and every field below is named after its **Figma variable**,
/// not after a role. That is the point of this class: `AppColors` named things
/// `surface` / `text` / `borderSubtle`, and those names quietly fused tokens
/// that only *happen* to share a value in Dark. `Label/Strong`, `Static/White`
/// and `Common/White & Dark` are all `#FFFFFF` in Dark and **#000000 / #FFFFFF
/// / #111111** in Light; one field called `text` cannot survive that.
///
/// Read it through [BuildContext.c]:
///
/// ```dart
/// Container(color: context.c.backgroundElevatedAlternative)
/// ```
///
/// Dark is the source of truth (design's own rule); Light follows it.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  /// Creates a full token set. Prefer [dark] / [light].
  const AppColorTokens({
    required this.primaryNormal,
    required this.primaryStrong,
    required this.primaryHeavy,
    required this.primaryNormal24,
    required this.primaryNormal14,
    required this.primaryNormal10,
    required this.primaryNormal4,
    required this.primaryOnPrimary,
    required this.primaryForeground,
    required this.labelStrong,
    required this.labelNormal,
    required this.labelNeutral,
    required this.labelAlternative,
    required this.labelAssistive,
    required this.labelDisabled,
    required this.backgroundNormalNormal,
    required this.backgroundNormalAlternative,
    required this.backgroundNormalDeep,
    required this.backgroundElevatedNormal,
    required this.backgroundElevatedAlternative,
    required this.backgroundSurfaceAlternative,
    required this.backgroundTransparentNormal,
    required this.backgroundTransparentAlternative,
    required this.gradientLevelStart,
    required this.gradientLevelMid,
    required this.gradientLevelEnd,
    required this.lineNormal,
    required this.lineNeutral,
    required this.lineAlternative,
    required this.lineStrong,
    required this.lineInset,
    required this.lineFlag,
    required this.lineDisabled,
    required this.fillNormal,
    required this.fillStrong,
    required this.fillAlternative,
    required this.fillDisabled,
    required this.fillWordPending,
    required this.fillWordDimmed,
    required this.fillSkeletonEdge,
    required this.fillSkeletonPeak,
    required this.statusPositive,
    required this.statusPositive4,
    required this.statusNegative,
    required this.statusNegative20,
    required this.statusNegative6,
    required this.statusCautionary,
    required this.statusCautionarySurface,
    required this.accentForegroundRed,
    required this.accentForegroundOrange,
    required this.accentForegroundRedOrange,
    required this.accentForegroundLime,
    required this.accentForegroundGreen,
    required this.accentForegroundCyan,
    required this.accentForegroundLightBlue,
    required this.accentForegroundBlue,
    required this.accentForegroundViolet,
    required this.accentForegroundPurple,
    required this.accentForegroundPink,
    required this.accentBackgroundRed,
    required this.accentBackgroundRedOrange,
    required this.accentBackgroundLime,
    required this.accentBackgroundCyan,
    required this.accentBackgroundLightBlue,
    required this.accentBackgroundLightBlue10,
    required this.accentBackgroundViolet,
    required this.accentBackgroundPurple,
    required this.accentBackgroundPink,
    required this.accentActive,
    required this.staticWhite,
    required this.staticBlack,
    required this.commonWhiteAndDark,
    required this.commonDarkAndWhite,
    required this.materialDim,
    required this.materialDimmer,
    required this.materialScrim,
    required this.materialShadow,
  });

  // ── Primary ────────────────────────────────────────────────
  /// `Primary/Normal` — the brand mint. **Dark #00FFB2 / Light #007A55.**
  final Color primaryNormal;

  /// `Primary/Strong` — a *different hue*, not an alpha of [primaryNormal].
  final Color primaryStrong;

  /// `Primary/Heavy`.
  final Color primaryHeavy;

  /// `Primary/Normal-24` / `-14` / `-10` / `-4` — the only primary alphas the
  /// collection ships. If a design asks for another percentage, it is a paint
  /// opacity and will drift; ask for a token.
  ///
  /// `-14` arrived with the subscription components (2026-08-03, measured off
  /// `Badge` `4204:551` / `Mark` `4365:31487` with `get_variable_defs`).
  final Color primaryNormal24, primaryNormal14, primaryNormal10, primaryNormal4;

  /// `Primary/On-Primary` — text/glyphs **on** a primary fill.
  /// Dark #111111 / Light #FFFFFF.
  final Color primaryOnPrimary;

  /// `Primary/Foreground` — 민트를 **글자·글리프 색으로** 쓸 때.
  /// Dark #00FFB2 / Light #00593E.
  ///
  /// Dark 에서는 [primaryNormal] 과 같은 값이지만 Light 에서 갈린다
  /// (#00593E vs #007A55) — 면을 칠하는 [primaryNormal] 을 글자에 돌려 쓰면
  /// 라이트에서 대비가 낮아진다. 숙제 배지·칩·진행 링이 이 토큰을 쓴다.
  final Color primaryForeground;

  // ── Label (text only) ──────────────────────────────────────
  /// `Label/Strong` — **the theme text colour. #FFFFFF in Dark, #000000 in
  /// Light.** Never use it to mean "white": that is [staticWhite].
  final Color labelStrong;

  /// `Label/Normal` · `Label/Neutral` · `Label/Alternative` ·
  /// `Label/Assistive` · `Label/Disabled` — the text ramp, quietest last.
  final Color labelNormal, labelNeutral, labelAlternative;
  final Color labelAssistive, labelDisabled;

  // ── Background ─────────────────────────────────────────────
  /// `Background/Normal/Normal` — the screen.
  final Color backgroundNormalNormal;

  /// `Background/Normal/Alternative` — chips, sunken controls.
  final Color backgroundNormalAlternative;

  /// `Background/Normal/Deep` — deeper than the screen.
  final Color backgroundNormalDeep;

  /// `Background/Elevated/Normal` — buttons on a card.
  final Color backgroundElevatedNormal;

  /// `Background/Elevated/Alternative` — **the card/sheet/dialog surface**.
  final Color backgroundElevatedAlternative;

  /// `Background/Surface/Alternative` — the my-page analysis cards.
  ///
  /// Identical to [backgroundNormalAlternative] in Dark (#252932) but **white**
  /// in Light, where `Background/Normal/Alternative` is a grey (#DBDCE2). The
  /// cards sit on the page background and must read as raised paper, so they
  /// need this token rather than the sunken-control one.
  final Color backgroundSurfaceAlternative;

  final Color backgroundTransparentNormal, backgroundTransparentAlternative;

  // ── Gradient ───────────────────────────────────────────────
  /// `Gradient/Level/Start` · `Mid` · `End` — the 1단계→13단계 level bar,
  /// laid out at stops 0.15 / 0.50 / 0.85 (Figma `4083:3-5`).
  ///
  /// Dark runs Brand/90 → Brand/50 → Light Blue/45 (light mint to blue); Light
  /// darkens the whole ramp (Brand/35 → Brand/20 → Light Blue/30) so it holds
  /// contrast on a white card.
  final Color gradientLevelStart, gradientLevelMid, gradientLevelEnd;

  // ── Line (strokes) ─────────────────────────────────────────
  final Color lineNormal, lineNeutral, lineAlternative;
  final Color lineStrong, lineInset, lineDisabled;

  /// `Line/Flag` — **alpha 0 in Dark.** Only draws in Light, where it edges
  /// the white of flag artwork.
  final Color lineFlag;

  // ── Fill ───────────────────────────────────────────────────
  final Color fillNormal, fillStrong, fillAlternative, fillDisabled;

  /// `Fill/Word-Pending` / `Fill/Word-Dimmed` — the scan animation's pills.
  /// Mode-invariant. Nothing renders these yet: the animation is blocked on
  /// word-boundary data, not on colour.
  final Color fillWordPending, fillWordDimmed;

  /// `Fill/Skeleton-Edge` / `Fill/Skeleton-Peak` — the shimmer ramp's ends and
  /// its midpoint band.
  final Color fillSkeletonEdge, fillSkeletonPeak;

  // ── Status ─────────────────────────────────────────────────
  final Color statusPositive, statusNegative, statusNegative20, statusNegative6;

  /// `Status/Positive-4` — the positive badge's face. Arrived with the
  /// subscription components (`Badge` `4204:551`, measured 2026-08-03).
  final Color statusPositive4;

  /// `Status/Cautionary` — ⚠️ the one status colour that does **not** darken in
  /// Light (#FFA938 → #FFAA00). Design set that value deliberately; do not
  /// "fix" it.
  final Color statusCautionary;
  final Color statusCautionarySurface;

  // ── Accent ─────────────────────────────────────────────────
  final Color accentForegroundRed, accentForegroundOrange;
  final Color accentForegroundRedOrange, accentForegroundLime;
  final Color accentForegroundGreen, accentForegroundCyan;
  final Color accentForegroundLightBlue, accentForegroundBlue;
  final Color accentForegroundViolet, accentForegroundPurple;
  final Color accentForegroundPink;

  /// `Accent/Background/Red` — **the destructive red** (delete). Distinct from
  /// [statusNegative], which is error/promo.
  final Color accentBackgroundRed;
  final Color accentBackgroundRedOrange, accentBackgroundLime;
  final Color accentBackgroundCyan, accentBackgroundLightBlue;
  final Color accentBackgroundLightBlue10, accentBackgroundViolet;
  final Color accentBackgroundPurple, accentBackgroundPink;
  final Color accentActive;

  // ── Static / Common / Material ─────────────────────────────
  /// `Static/White` / `Static/Black` — **mode-invariant.** This is what an icon
  /// that must stay white wants, not [labelStrong].
  final Color staticWhite, staticBlack;

  /// `Common/White & Dark` (#FFF→#111) and `Common/Dark & White` (#111→#FFF) —
  /// the inverting pair.
  final Color commonWhiteAndDark, commonDarkAndWhite;

  final Color materialDim, materialDimmer, materialScrim, materialShadow;

  /// Dark — **the source of truth** (`3702:39952`).
  static const dark = AppColorTokens(
    primaryNormal: Color(0xFF00FFB2),
    primaryStrong: Color(0xFF00E8A2),
    primaryHeavy: Color(0xFF00B57E),
    primaryNormal24: Color(0x3D00FFB2),
    primaryNormal14: Color(0x2400FFB2),
    primaryNormal10: Color(0x1A00FFB2),
    primaryNormal4: Color(0x0A00FFB2),
    primaryOnPrimary: Color(0xFF111111),
    primaryForeground: Color(0xFF00FFB2),
    labelStrong: Color(0xFFFFFFFF),
    labelNormal: Color(0xFF9EA3B2),
    labelNeutral: Color(0xFF777C89),
    labelAlternative: Color(0xFF626877),
    labelAssistive: Color(0xFF676E81),
    labelDisabled: Color(0xFF474C58),
    backgroundNormalNormal: Color(0xFF181A20),
    backgroundNormalAlternative: Color(0xFF252932),
    backgroundNormalDeep: Color(0xFF121217),
    backgroundElevatedNormal: Color(0xFF2F3340),
    backgroundElevatedAlternative: Color(0xFF1F222A),
    backgroundSurfaceAlternative: Color(0xFF252932),
    gradientLevelStart: Color(0xFFB0FFE7),
    gradientLevelMid: Color(0xFF00FFB2),
    gradientLevelEnd: Color(0xFF22A0D0),
    backgroundTransparentNormal: Color(0x9C212225),
    backgroundTransparentAlternative: Color(0x9C212225),
    lineNormal: Color(0xFF70737C),
    lineNeutral: Color(0x1FFFFFFF),
    lineAlternative: Color(0x0FFFFFFF),
    lineStrong: Color(0xFF202026),
    lineInset: Color(0xFF202026),
    lineFlag: Color(0x00FFFFFF),
    lineDisabled: Color(0xFF474C58),
    fillNormal: Color(0x1FFFFFFF),
    fillStrong: Color(0x33FFFFFF),
    fillAlternative: Color(0x0FFFFFFF),
    fillDisabled: Color(0xFF676E81),
    fillWordPending: Color(0x5970737C),
    fillWordDimmed: Color(0x4D70737C),
    fillSkeletonEdge: Color(0x0FFFFFFF),
    fillSkeletonPeak: Color(0x24FFFFFF),
    statusPositive: Color(0xFF1ED45A),
    statusPositive4: Color(0x0A1ED45A),
    statusNegative: Color(0xFFFF7070),
    statusNegative20: Color(0x33FF7070),
    statusNegative6: Color(0x0FFF7070),
    statusCautionary: Color(0xFFFFA938),
    statusCautionarySurface: Color(0x1AFFB548),
    accentForegroundRed: Color(0xFFFF6363),
    accentForegroundOrange: Color(0xFFFF9200),
    accentForegroundRedOrange: Color(0xFFFF7B2E),
    accentForegroundLime: Color(0xFF58CF04),
    accentForegroundGreen: Color(0xFF1ED45A),
    accentForegroundCyan: Color(0xFF00BDDE),
    accentForegroundLightBlue: Color(0xFF00AEFF),
    accentForegroundBlue: Color(0xFF4F95FF),
    accentForegroundViolet: Color(0xFF9E86FC),
    accentForegroundPurple: Color(0xFFD478FF),
    accentForegroundPink: Color(0xFFFA73E3),
    accentBackgroundRed: Color(0xFFE52222),
    accentBackgroundRedOrange: Color(0xFFFF7B2E),
    accentBackgroundLime: Color(0xFF6BE016),
    accentBackgroundCyan: Color(0xFF28D0ED),
    accentBackgroundLightBlue: Color(0xFF3DC2FF),
    accentBackgroundLightBlue10: Color(0x1A3DC2FF),
    accentBackgroundViolet: Color(0xFF7D5EF7),
    accentBackgroundPurple: Color(0xFFD478FF),
    accentBackgroundPink: Color(0xFFFA73E3),
    accentActive: Color(0xFFD17600),
    staticWhite: Color(0xFFFFFFFF),
    staticBlack: Color(0xFF000000),
    commonWhiteAndDark: Color(0xFFFFFFFF),
    commonDarkAndWhite: Color(0xFF111111),
    materialDim: Color(0x80000000),
    materialDimmer: Color(0x80000000),
    materialScrim: Color(0x1A000000),
    materialShadow: Color(0x0F000000),
  );

  /// Light (`3702:39951`).
  static const light = AppColorTokens(
    primaryNormal: Color(0xFF007A55),
    primaryStrong: Color(0xFF007A55),
    primaryHeavy: Color(0xFF006B4B),
    primaryNormal24: Color(0x3D008C62),
    // Light values for -14 / positive-4 follow the collection's own pattern —
    // same alpha byte, the light-mode base colour (as -24/-10/-4 and
    // negative-6 already do). The Dark file is the design's source of truth
    // and get_variable_defs cannot read the Light mode; re-measure if the
    // Light chips ever say otherwise.
    primaryNormal14: Color(0x24008C62),
    primaryNormal10: Color(0x1A008C62),
    primaryNormal4: Color(0x0A008C62),
    primaryOnPrimary: Color(0xFFFFFFFF),
    primaryForeground: Color(0xFF00593E),
    labelStrong: Color(0xFF000000),
    labelNormal: Color(0xFF333333),
    labelNeutral: Color(0xFF505050),
    labelAlternative: Color(0xFF767676),
    labelAssistive: Color(0xFF808080),
    labelDisabled: Color(0xFF999999),
    backgroundNormalNormal: Color(0xFFF1F1F5),
    backgroundNormalAlternative: Color(0xFFF6F6F7),
    backgroundNormalDeep: Color(0xFFE1E2E4),
    backgroundElevatedNormal: Color(0xFFF7F7FB),
    backgroundElevatedAlternative: Color(0xFFFFFFFF),
    backgroundSurfaceAlternative: Color(0xFFFFFFFF),
    gradientLevelStart: Color(0xFF00C88A),
    gradientLevelMid: Color(0xFF008C62),
    gradientLevelEnd: Color(0xFF006796),
    backgroundTransparentNormal: Color(0x14FFFFFF),
    backgroundTransparentAlternative: Color(0xFFF7F7F7),
    lineNormal: Color(0x5270737C),
    lineNeutral: Color(0x2470737C),
    lineAlternative: Color(0x1270737C),
    lineStrong: Color(0xFF111111),
    lineInset: Color(0xFFFFFFFF),
    lineFlag: Color(0xFFE5E5EC),
    lineDisabled: Color(0xFFAEB0B6),
    fillNormal: Color(0x1470737C),
    fillStrong: Color(0x2970737C),
    fillAlternative: Color(0x0D70737C),
    fillDisabled: Color(0xFFE1E2E4),
    fillWordPending: Color(0x5970737C),
    fillWordDimmed: Color(0x4D70737C),
    fillSkeletonEdge: Color(0x2470737C),
    fillSkeletonPeak: Color(0x3D70737C),
    statusPositive: Color(0xFF04B014),
    statusPositive4: Color(0x0A04B014),
    statusNegative: Color(0xFFDC0000),
    statusNegative20: Color(0x33DC0000),
    statusNegative6: Color(0x0FDC0000),
    statusCautionary: Color(0xFFFFAA00),
    statusCautionarySurface: Color(0x1AFFAA00),
    accentForegroundRed: Color(0xFFE52222),
    accentForegroundOrange: Color(0xFF9C5800),
    accentForegroundRedOrange: Color(0xFFF55A00),
    accentForegroundLime: Color(0xFF429E00),
    accentForegroundGreen: Color(0xFF009632),
    accentForegroundCyan: Color(0xFF0098B2),
    accentForegroundLightBlue: Color(0xFF008DCF),
    accentForegroundBlue: Color(0xFF005EEB),
    accentForegroundViolet: Color(0xFF5B37ED),
    accentForegroundPurple: Color(0xFFAD36E3),
    accentForegroundPink: Color(0xFFE846CD),
    accentBackgroundRed: Color(0xFFE52222),
    accentBackgroundRedOrange: Color(0xFFFF5E00),
    accentBackgroundLime: Color(0xFF58CF04),
    accentBackgroundCyan: Color(0xFF00BDDE),
    accentBackgroundLightBlue: Color(0xFF00AEFF),
    accentBackgroundLightBlue10: Color(0x1A3DC2FF),
    accentBackgroundViolet: Color(0xFF6541F2),
    accentBackgroundPurple: Color(0xFFCB59FF),
    accentBackgroundPink: Color(0xFFF553DA),
    accentActive: Color(0xFFFF9200),
    staticWhite: Color(0xFFFFFFFF),
    staticBlack: Color(0xFF000000),
    commonWhiteAndDark: Color(0xFF111111),
    commonDarkAndWhite: Color(0xFFFFFFFF),
    materialDim: Color(0x5C000000),
    materialDimmer: Color(0x5C000000),
    materialScrim: Color(0x1A000000),
    materialShadow: Color(0x1A000000),
  );

  @override
  AppColorTokens copyWith({
    Color? primaryNormal,
    Color? primaryStrong,
    Color? primaryHeavy,
    Color? primaryNormal24,
    Color? primaryNormal14,
    Color? primaryNormal10,
    Color? primaryNormal4,
    Color? primaryOnPrimary,
    Color? primaryForeground,
    Color? labelStrong,
    Color? labelNormal,
    Color? labelNeutral,
    Color? labelAlternative,
    Color? labelAssistive,
    Color? labelDisabled,
    Color? backgroundNormalNormal,
    Color? backgroundNormalAlternative,
    Color? backgroundNormalDeep,
    Color? backgroundElevatedNormal,
    Color? backgroundElevatedAlternative,
    Color? backgroundSurfaceAlternative,
    Color? gradientLevelStart,
    Color? gradientLevelMid,
    Color? gradientLevelEnd,
    Color? backgroundTransparentNormal,
    Color? backgroundTransparentAlternative,
    Color? lineNormal,
    Color? lineNeutral,
    Color? lineAlternative,
    Color? lineStrong,
    Color? lineInset,
    Color? lineFlag,
    Color? lineDisabled,
    Color? fillNormal,
    Color? fillStrong,
    Color? fillAlternative,
    Color? fillDisabled,
    Color? fillWordPending,
    Color? fillWordDimmed,
    Color? fillSkeletonEdge,
    Color? fillSkeletonPeak,
    Color? statusPositive,
    Color? statusPositive4,
    Color? statusNegative,
    Color? statusNegative20,
    Color? statusNegative6,
    Color? statusCautionary,
    Color? statusCautionarySurface,
    Color? accentForegroundRed,
    Color? accentForegroundOrange,
    Color? accentForegroundRedOrange,
    Color? accentForegroundLime,
    Color? accentForegroundGreen,
    Color? accentForegroundCyan,
    Color? accentForegroundLightBlue,
    Color? accentForegroundBlue,
    Color? accentForegroundViolet,
    Color? accentForegroundPurple,
    Color? accentForegroundPink,
    Color? accentBackgroundRed,
    Color? accentBackgroundRedOrange,
    Color? accentBackgroundLime,
    Color? accentBackgroundCyan,
    Color? accentBackgroundLightBlue,
    Color? accentBackgroundLightBlue10,
    Color? accentBackgroundViolet,
    Color? accentBackgroundPurple,
    Color? accentBackgroundPink,
    Color? accentActive,
    Color? staticWhite,
    Color? staticBlack,
    Color? commonWhiteAndDark,
    Color? commonDarkAndWhite,
    Color? materialDim,
    Color? materialDimmer,
    Color? materialScrim,
    Color? materialShadow,
  }) =>
      AppColorTokens(
        primaryNormal: primaryNormal ?? this.primaryNormal,
        primaryStrong: primaryStrong ?? this.primaryStrong,
        primaryHeavy: primaryHeavy ?? this.primaryHeavy,
        primaryNormal24: primaryNormal24 ?? this.primaryNormal24,
        primaryNormal14: primaryNormal14 ?? this.primaryNormal14,
        primaryNormal10: primaryNormal10 ?? this.primaryNormal10,
        primaryNormal4: primaryNormal4 ?? this.primaryNormal4,
        primaryOnPrimary: primaryOnPrimary ?? this.primaryOnPrimary,
        primaryForeground: primaryForeground ?? this.primaryForeground,
        labelStrong: labelStrong ?? this.labelStrong,
        labelNormal: labelNormal ?? this.labelNormal,
        labelNeutral: labelNeutral ?? this.labelNeutral,
        labelAlternative: labelAlternative ?? this.labelAlternative,
        labelAssistive: labelAssistive ?? this.labelAssistive,
        labelDisabled: labelDisabled ?? this.labelDisabled,
        backgroundNormalNormal:
            backgroundNormalNormal ?? this.backgroundNormalNormal,
        backgroundNormalAlternative:
            backgroundNormalAlternative ?? this.backgroundNormalAlternative,
        backgroundNormalDeep: backgroundNormalDeep ?? this.backgroundNormalDeep,
        backgroundElevatedNormal:
            backgroundElevatedNormal ?? this.backgroundElevatedNormal,
        backgroundElevatedAlternative:
            backgroundElevatedAlternative ?? this.backgroundElevatedAlternative,
        backgroundSurfaceAlternative:
            backgroundSurfaceAlternative ?? this.backgroundSurfaceAlternative,
        gradientLevelStart: gradientLevelStart ?? this.gradientLevelStart,
        gradientLevelMid: gradientLevelMid ?? this.gradientLevelMid,
        gradientLevelEnd: gradientLevelEnd ?? this.gradientLevelEnd,
        backgroundTransparentNormal:
            backgroundTransparentNormal ?? this.backgroundTransparentNormal,
        backgroundTransparentAlternative: backgroundTransparentAlternative ??
            this.backgroundTransparentAlternative,
        lineNormal: lineNormal ?? this.lineNormal,
        lineNeutral: lineNeutral ?? this.lineNeutral,
        lineAlternative: lineAlternative ?? this.lineAlternative,
        lineStrong: lineStrong ?? this.lineStrong,
        lineInset: lineInset ?? this.lineInset,
        lineFlag: lineFlag ?? this.lineFlag,
        lineDisabled: lineDisabled ?? this.lineDisabled,
        fillNormal: fillNormal ?? this.fillNormal,
        fillStrong: fillStrong ?? this.fillStrong,
        fillAlternative: fillAlternative ?? this.fillAlternative,
        fillDisabled: fillDisabled ?? this.fillDisabled,
        fillWordPending: fillWordPending ?? this.fillWordPending,
        fillWordDimmed: fillWordDimmed ?? this.fillWordDimmed,
        fillSkeletonEdge: fillSkeletonEdge ?? this.fillSkeletonEdge,
        fillSkeletonPeak: fillSkeletonPeak ?? this.fillSkeletonPeak,
        statusPositive: statusPositive ?? this.statusPositive,
        statusPositive4: statusPositive4 ?? this.statusPositive4,
        statusNegative: statusNegative ?? this.statusNegative,
        statusNegative20: statusNegative20 ?? this.statusNegative20,
        statusNegative6: statusNegative6 ?? this.statusNegative6,
        statusCautionary: statusCautionary ?? this.statusCautionary,
        statusCautionarySurface:
            statusCautionarySurface ?? this.statusCautionarySurface,
        accentForegroundRed: accentForegroundRed ?? this.accentForegroundRed,
        accentForegroundOrange:
            accentForegroundOrange ?? this.accentForegroundOrange,
        accentForegroundRedOrange:
            accentForegroundRedOrange ?? this.accentForegroundRedOrange,
        accentForegroundLime: accentForegroundLime ?? this.accentForegroundLime,
        accentForegroundGreen:
            accentForegroundGreen ?? this.accentForegroundGreen,
        accentForegroundCyan: accentForegroundCyan ?? this.accentForegroundCyan,
        accentForegroundLightBlue:
            accentForegroundLightBlue ?? this.accentForegroundLightBlue,
        accentForegroundBlue: accentForegroundBlue ?? this.accentForegroundBlue,
        accentForegroundViolet:
            accentForegroundViolet ?? this.accentForegroundViolet,
        accentForegroundPurple:
            accentForegroundPurple ?? this.accentForegroundPurple,
        accentForegroundPink: accentForegroundPink ?? this.accentForegroundPink,
        accentBackgroundRed: accentBackgroundRed ?? this.accentBackgroundRed,
        accentBackgroundRedOrange:
            accentBackgroundRedOrange ?? this.accentBackgroundRedOrange,
        accentBackgroundLime: accentBackgroundLime ?? this.accentBackgroundLime,
        accentBackgroundCyan: accentBackgroundCyan ?? this.accentBackgroundCyan,
        accentBackgroundLightBlue:
            accentBackgroundLightBlue ?? this.accentBackgroundLightBlue,
        accentBackgroundLightBlue10:
            accentBackgroundLightBlue10 ?? this.accentBackgroundLightBlue10,
        accentBackgroundViolet:
            accentBackgroundViolet ?? this.accentBackgroundViolet,
        accentBackgroundPurple:
            accentBackgroundPurple ?? this.accentBackgroundPurple,
        accentBackgroundPink: accentBackgroundPink ?? this.accentBackgroundPink,
        accentActive: accentActive ?? this.accentActive,
        staticWhite: staticWhite ?? this.staticWhite,
        staticBlack: staticBlack ?? this.staticBlack,
        commonWhiteAndDark: commonWhiteAndDark ?? this.commonWhiteAndDark,
        commonDarkAndWhite: commonDarkAndWhite ?? this.commonDarkAndWhite,
        materialDim: materialDim ?? this.materialDim,
        materialDimmer: materialDimmer ?? this.materialDimmer,
        materialScrim: materialScrim ?? this.materialScrim,
        materialShadow: materialShadow ?? this.materialShadow,
      );

  @override
  AppColorTokens lerp(covariant AppColorTokens? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorTokens(
      primaryNormal: c(primaryNormal, other.primaryNormal),
      primaryStrong: c(primaryStrong, other.primaryStrong),
      primaryHeavy: c(primaryHeavy, other.primaryHeavy),
      primaryNormal24: c(primaryNormal24, other.primaryNormal24),
      primaryNormal14: c(primaryNormal14, other.primaryNormal14),
      primaryNormal10: c(primaryNormal10, other.primaryNormal10),
      primaryNormal4: c(primaryNormal4, other.primaryNormal4),
      primaryOnPrimary: c(primaryOnPrimary, other.primaryOnPrimary),
      primaryForeground: c(primaryForeground, other.primaryForeground),
      labelStrong: c(labelStrong, other.labelStrong),
      labelNormal: c(labelNormal, other.labelNormal),
      labelNeutral: c(labelNeutral, other.labelNeutral),
      labelAlternative: c(labelAlternative, other.labelAlternative),
      labelAssistive: c(labelAssistive, other.labelAssistive),
      labelDisabled: c(labelDisabled, other.labelDisabled),
      backgroundNormalNormal:
          c(backgroundNormalNormal, other.backgroundNormalNormal),
      backgroundNormalAlternative:
          c(backgroundNormalAlternative, other.backgroundNormalAlternative),
      backgroundNormalDeep: c(backgroundNormalDeep, other.backgroundNormalDeep),
      backgroundElevatedNormal:
          c(backgroundElevatedNormal, other.backgroundElevatedNormal),
      backgroundElevatedAlternative:
          c(backgroundElevatedAlternative, other.backgroundElevatedAlternative),
      backgroundSurfaceAlternative:
          c(backgroundSurfaceAlternative, other.backgroundSurfaceAlternative),
      gradientLevelStart: c(gradientLevelStart, other.gradientLevelStart),
      gradientLevelMid: c(gradientLevelMid, other.gradientLevelMid),
      gradientLevelEnd: c(gradientLevelEnd, other.gradientLevelEnd),
      backgroundTransparentNormal:
          c(backgroundTransparentNormal, other.backgroundTransparentNormal),
      backgroundTransparentAlternative: c(backgroundTransparentAlternative,
          other.backgroundTransparentAlternative),
      lineNormal: c(lineNormal, other.lineNormal),
      lineNeutral: c(lineNeutral, other.lineNeutral),
      lineAlternative: c(lineAlternative, other.lineAlternative),
      lineStrong: c(lineStrong, other.lineStrong),
      lineInset: c(lineInset, other.lineInset),
      lineFlag: c(lineFlag, other.lineFlag),
      lineDisabled: c(lineDisabled, other.lineDisabled),
      fillNormal: c(fillNormal, other.fillNormal),
      fillStrong: c(fillStrong, other.fillStrong),
      fillAlternative: c(fillAlternative, other.fillAlternative),
      fillDisabled: c(fillDisabled, other.fillDisabled),
      fillWordPending: c(fillWordPending, other.fillWordPending),
      fillWordDimmed: c(fillWordDimmed, other.fillWordDimmed),
      fillSkeletonEdge: c(fillSkeletonEdge, other.fillSkeletonEdge),
      fillSkeletonPeak: c(fillSkeletonPeak, other.fillSkeletonPeak),
      statusPositive: c(statusPositive, other.statusPositive),
      statusPositive4: c(statusPositive4, other.statusPositive4),
      statusNegative: c(statusNegative, other.statusNegative),
      statusNegative20: c(statusNegative20, other.statusNegative20),
      statusNegative6: c(statusNegative6, other.statusNegative6),
      statusCautionary: c(statusCautionary, other.statusCautionary),
      statusCautionarySurface:
          c(statusCautionarySurface, other.statusCautionarySurface),
      accentForegroundRed: c(accentForegroundRed, other.accentForegroundRed),
      accentForegroundOrange:
          c(accentForegroundOrange, other.accentForegroundOrange),
      accentForegroundRedOrange:
          c(accentForegroundRedOrange, other.accentForegroundRedOrange),
      accentForegroundLime: c(accentForegroundLime, other.accentForegroundLime),
      accentForegroundGreen:
          c(accentForegroundGreen, other.accentForegroundGreen),
      accentForegroundCyan: c(accentForegroundCyan, other.accentForegroundCyan),
      accentForegroundLightBlue:
          c(accentForegroundLightBlue, other.accentForegroundLightBlue),
      accentForegroundBlue: c(accentForegroundBlue, other.accentForegroundBlue),
      accentForegroundViolet:
          c(accentForegroundViolet, other.accentForegroundViolet),
      accentForegroundPurple:
          c(accentForegroundPurple, other.accentForegroundPurple),
      accentForegroundPink: c(accentForegroundPink, other.accentForegroundPink),
      accentBackgroundRed: c(accentBackgroundRed, other.accentBackgroundRed),
      accentBackgroundRedOrange:
          c(accentBackgroundRedOrange, other.accentBackgroundRedOrange),
      accentBackgroundLime: c(accentBackgroundLime, other.accentBackgroundLime),
      accentBackgroundCyan: c(accentBackgroundCyan, other.accentBackgroundCyan),
      accentBackgroundLightBlue:
          c(accentBackgroundLightBlue, other.accentBackgroundLightBlue),
      accentBackgroundLightBlue10:
          c(accentBackgroundLightBlue10, other.accentBackgroundLightBlue10),
      accentBackgroundViolet:
          c(accentBackgroundViolet, other.accentBackgroundViolet),
      accentBackgroundPurple:
          c(accentBackgroundPurple, other.accentBackgroundPurple),
      accentBackgroundPink: c(accentBackgroundPink, other.accentBackgroundPink),
      accentActive: c(accentActive, other.accentActive),
      staticWhite: c(staticWhite, other.staticWhite),
      staticBlack: c(staticBlack, other.staticBlack),
      commonWhiteAndDark: c(commonWhiteAndDark, other.commonWhiteAndDark),
      commonDarkAndWhite: c(commonDarkAndWhite, other.commonDarkAndWhite),
      materialDim: c(materialDim, other.materialDim),
      materialDimmer: c(materialDimmer, other.materialDimmer),
      materialScrim: c(materialScrim, other.materialScrim),
      materialShadow: c(materialShadow, other.materialShadow),
    );
  }
}

/// `context.c.<token>` — the token set for the current theme.
extension AppColorTokensX on BuildContext {
  /// The Figma `Semantics` tokens for whichever mode is in force, falling back
  /// to [dark] when the theme carries no [AppColorTokens].
  ///
  /// The fallback is deliberate, and it replaced a `!`. Strictness reads safer
  /// than it is here: the app registers both mode sets in exactly one place
  /// ([BeaverTalkApp]), so a missing extension almost never means "wrong mode
  /// in production" — it means **a widget test mounted a bare `MaterialApp`**.
  /// Throwing turned every such test into a crash the moment its widget touched
  /// a colour, which is a tax on every future test for a bug that one file
  /// controls. Dark is design's source of truth, so falling back to it renders
  /// exactly what the app rendered before any of this existed.
  AppColorTokens get c =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.dark;
}
