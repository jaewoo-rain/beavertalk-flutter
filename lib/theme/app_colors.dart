import 'package:flutter/painting.dart';

/// Design system color tokens from the BeaverTalk Figma file.
///
/// Token names mirror the Figma color tokens, converted to Dart camelCase.
/// All values are `const Color` (ARGB). Where the Figma token defines an
/// alpha channel, it is encoded in the leading byte; otherwise `0xFF`.
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------
  static const Color labelStrong = Color(0xFF000000);
  static const Color labelNormal = Color(0xFF171719);
  static const Color labelAlternative = Color(0x9C37383C); // alpha 9C
  static const Color lineNormalNormal = Color(0x3870737C); // alpha 38
  static const Color backgroundNormalNormal = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Common
  // ---------------------------------------------------------------------------
  static const Color common0 = Color(0xFF000000);
  static const Color common100 = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Neutral
  // ---------------------------------------------------------------------------
  static const Color neutral99 = Color(0xFFF7F7F7);
  static const Color neutral95 = Color(0xFFDCDCDC);
  static const Color neutral90 = Color(0xFFC4C4C4);
  static const Color neutral80 = Color(0xFFB0B0B0);
  static const Color neutral70 = Color(0xFF9B9B9B);
  static const Color neutral60 = Color(0xFF8A8A8A);
  static const Color neutral50 = Color(0xFF737373);
  static const Color neutral40 = Color(0xFF5C5C5C);
  static const Color neutral30 = Color(0xFF474747);
  static const Color neutral22 = Color(0xFF303030);
  static const Color neutral20 = Color(0xFF2A2A2A);
  static const Color neutral15 = Color(0xFF1C1C1C);
  static const Color neutral10 = Color(0xFF171717);
  static const Color neutral5 = Color(0xFF0F0F0F);

  // ---------------------------------------------------------------------------
  // Cool Neutral
  // ---------------------------------------------------------------------------
  static const Color coolNeutral99 = Color(0xFFF7F7F8);
  static const Color coolNeutral98 = Color(0xFFF4F4F5);
  static const Color coolNeutral97 = Color(0xFFEAEBEC);
  static const Color coolNeutral96 = Color(0xFFE1E2E4);
  static const Color coolNeutral95 = Color(0xFFDBDCDF);
  static const Color coolNeutral90 = Color(0xFFC2C4C8);
  static const Color coolNeutral80 = Color(0xFFAEB0B6);
  static const Color coolNeutral70 = Color(0xFF989BA2);
  static const Color coolNeutral60 = Color(0xFF878A93);
  static const Color coolNeutral50 = Color(0xFF70737C);
  static const Color coolNeutral40 = Color(0xFF5A5C63);
  static const Color coolNeutral30 = Color(0xFF46474C);
  static const Color coolNeutral25 = Color(0xFF37383C);
  static const Color coolNeutral23 = Color(0xFF333438);
  static const Color coolNeutral22 = Color(0xFF2E2F33);
  static const Color coolNeutral20 = Color(0xFF292A2D);
  static const Color coolNeutral17 = Color(0xFF212225);
  static const Color coolNeutral15 = Color(0xFF1B1C1E);
  static const Color coolNeutral10 = Color(0xFF171719);
  static const Color coolNeutral7 = Color(0xFF141415);
  static const Color coolNeutral5 = Color(0xFF0F0F10);

  // ---------------------------------------------------------------------------
  // Blue
  // ---------------------------------------------------------------------------
  static const Color blue99 = Color(0xFFF7FBFF);
  static const Color blue95 = Color(0xFFEAF2FE);
  static const Color blue90 = Color(0xFFC9DEFE);
  static const Color blue80 = Color(0xFF9EC5FF);
  static const Color blue70 = Color(0xFF69A5FF);
  static const Color blue65 = Color(0xFF4F95FF);
  static const Color blue60 = Color(0xFF3385FF);
  static const Color blue55 = Color(0xFF1A75FF);
  static const Color blue50 = Color(0xFF0066FF);
  static const Color blue45 = Color(0xFF005EEB);
  static const Color blue40 = Color(0xFF0054D1);
  static const Color blue30 = Color(0xFF003E9C);
  static const Color blue20 = Color(0xFF002966);
  static const Color blue10 = Color(0xFF001536);

  // ---------------------------------------------------------------------------
  // Red
  // ---------------------------------------------------------------------------
  static const Color red99 = Color(0xFFFFFAFA);
  static const Color red95 = Color(0xFFFEECEC);
  static const Color red90 = Color(0xFFFED5D5);
  static const Color red80 = Color(0xFFFFB5B5);
  static const Color red70 = Color(0xFFFF8C8C);
  static const Color red60 = Color(0xFFFF6363);
  static const Color red50 = Color(0xFFFF4242);
  static const Color red40 = Color(0xFFE52222);
  static const Color red30 = Color(0xFFB00C0C);
  static const Color red20 = Color(0xFF730303);
  static const Color red10 = Color(0xFF3B0101);

  // ---------------------------------------------------------------------------
  // Green
  // ---------------------------------------------------------------------------
  static const Color green99 = Color(0xFFF2FFF6);
  static const Color green95 = Color(0xFFD9FFE6);
  static const Color green90 = Color(0xFFACFCC7);
  static const Color green80 = Color(0xFF7DF5A5);
  static const Color green70 = Color(0xFF49E57D);
  static const Color green60 = Color(0xFF1ED45A);
  static const Color green50 = Color(0xFF00BF40);
  static const Color green40 = Color(0xFF009632);
  static const Color green30 = Color(0xFF006E25);
  static const Color green20 = Color(0xFF004517);
  static const Color green10 = Color(0xFF00240C);

  // ---------------------------------------------------------------------------
  // Orange
  // ---------------------------------------------------------------------------
  static const Color orange99 = Color(0xFFFFFCF7);
  static const Color orange95 = Color(0xFFFEF4E6);
  static const Color orange90 = Color(0xFFFEE6C6);
  static const Color orange80 = Color(0xFFFFD49C);
  static const Color orange70 = Color(0xFFFFC06E);
  static const Color orange60 = Color(0xFFFFA938);
  static const Color orange50 = Color(0xFFFF9200);
  static const Color orange40 = Color(0xFFD47800);
  static const Color orange39 = Color(0xFFD17600);
  static const Color orange30 = Color(0xFF9C5800);
  static const Color orange20 = Color(0xFF663A00);
  static const Color orange10 = Color(0xFF361E00);

  // ---------------------------------------------------------------------------
  // Red Orange
  // ---------------------------------------------------------------------------
  static const Color redOrange99 = Color(0xFFFFFAF7);
  static const Color redOrange95 = Color(0xFFFEEEE5);
  static const Color redOrange90 = Color(0xFFFED9C4);
  static const Color redOrange80 = Color(0xFFFFBD96);
  static const Color redOrange70 = Color(0xFFFF9B61);
  static const Color redOrange60 = Color(0xFFFF7B2E);
  static const Color redOrange50 = Color(0xFFFF5E00);
  static const Color redOrange48 = Color(0xFFF55A00);
  static const Color redOrange40 = Color(0xFFC94A00);
  static const Color redOrange30 = Color(0xFF913500);
  static const Color redOrange20 = Color(0xFF592100);
  static const Color redOrange10 = Color(0xFF290F00);

  // ---------------------------------------------------------------------------
  // Lime
  // ---------------------------------------------------------------------------
  static const Color lime99 = Color(0xFFF8FFF2);
  static const Color lime95 = Color(0xFFE6FFD4);
  static const Color lime90 = Color(0xFFCCFCA9);
  static const Color lime80 = Color(0xFFAEF779);
  static const Color lime70 = Color(0xFF88F03E);
  static const Color lime60 = Color(0xFF6BE016);
  static const Color lime50 = Color(0xFF58CF04);
  static const Color lime40 = Color(0xFF48AD00);
  static const Color lime37 = Color(0xFF429E00);
  static const Color lime30 = Color(0xFF347D00);
  static const Color lime20 = Color(0xFF225200);
  static const Color lime10 = Color(0xFF112900);

  // ---------------------------------------------------------------------------
  // Cyan
  // ---------------------------------------------------------------------------
  static const Color cyan99 = Color(0xFFF7FEFF);
  static const Color cyan95 = Color(0xFFDEFAFF);
  static const Color cyan90 = Color(0xFFB5F4FF);
  static const Color cyan80 = Color(0xFF8AEDFF);
  static const Color cyan70 = Color(0xFF57DFF7);
  static const Color cyan60 = Color(0xFF28D0ED);
  static const Color cyan50 = Color(0xFF00BDDE);
  static const Color cyan40 = Color(0xFF0098B2);
  static const Color cyan30 = Color(0xFF006F82);
  static const Color cyan20 = Color(0xFF004854);
  static const Color cyan10 = Color(0xFF00252B);

  // ---------------------------------------------------------------------------
  // Light Blue
  // ---------------------------------------------------------------------------
  static const Color lightBlue99 = Color(0xFFF7FDFF);
  static const Color lightBlue95 = Color(0xFFE5F6FE);
  static const Color lightBlue90 = Color(0xFFC4ECFE);
  static const Color lightBlue80 = Color(0xFFA1E1FF);
  static const Color lightBlue70 = Color(0xFF70D2FF);
  static const Color lightBlue60 = Color(0xFF3DC2FF);
  static const Color lightBlue50 = Color(0xFF00AEFF);
  static const Color lightBlue40 = Color(0xFF008DCF);
  static const Color lightBlue30 = Color(0xFF006796);
  static const Color lightBlue20 = Color(0xFF004261);
  static const Color lightBlue10 = Color(0xFF002130);

  // ---------------------------------------------------------------------------
  // Violet
  // ---------------------------------------------------------------------------
  static const Color violet99 = Color(0xFFFBFAFF);
  static const Color violet95 = Color(0xFFF0ECFE);
  static const Color violet90 = Color(0xFFDBD3FE);
  static const Color violet80 = Color(0xFFC0B0FF);
  static const Color violet70 = Color(0xFF9E86FC);
  static const Color violet60 = Color(0xFF7D5EF7);
  static const Color violet50 = Color(0xFF6541F2);
  static const Color violet45 = Color(0xFF5B37ED);
  static const Color violet40 = Color(0xFF4F29E5);
  static const Color violet30 = Color(0xFF3A16C9);
  static const Color violet20 = Color(0xFF23098F);
  static const Color violet10 = Color(0xFF11024D);

  // ---------------------------------------------------------------------------
  // Purple
  // ---------------------------------------------------------------------------
  static const Color purple99 = Color(0xFFFEFBFF);
  static const Color purple95 = Color(0xFFF9EDFF);
  static const Color purple90 = Color(0xFFF2D6FF);
  static const Color purple80 = Color(0xFFE9BAFF);
  static const Color purple70 = Color(0xFFDE96FF);
  static const Color purple60 = Color(0xFFD478FF);
  static const Color purple50 = Color(0xFFCB59FF);
  static const Color purple40 = Color(0xFFAD36E3);
  static const Color purple30 = Color(0xFF861CB8);
  static const Color purple20 = Color(0xFF580A7D);
  static const Color purple10 = Color(0xFF290247);

  // ---------------------------------------------------------------------------
  // Pink
  // ---------------------------------------------------------------------------
  static const Color pink99 = Color(0xFFFFFAFE);
  static const Color pink95 = Color(0xFFFEECFB);
  static const Color pink90 = Color(0xFFFED3F7);
  static const Color pink80 = Color(0xFFFFB8F3);
  static const Color pink70 = Color(0xFFFF94ED);
  static const Color pink60 = Color(0xFFFA73E3);
  static const Color pink50 = Color(0xFFF553DA);
  static const Color pink46 = Color(0xFFE846CD);
  static const Color pink40 = Color(0xFFD331B8);
  static const Color pink30 = Color(0xFFA81690);
  static const Color pink20 = Color(0xFF730560);
  static const Color pink10 = Color(0xFF3D0133);

  // ---------------------------------------------------------------------------
  // Semantic — dark theme & accents (used by the 01_Atoms components)
  //
  // The atoms are designed on the dark theme, so these resolve to dark-theme
  // values that differ from the light-theme semantics above (e.g.
  // [backgroundNormalNormal] is white in light theme, #181A20 in dark).
  // ---------------------------------------------------------------------------
  static const Color primaryNormal = Color(0xFF00FFB2);
  static const Color primaryHeavy = Color(0xFF00B57E);
  static const Color commonWhite = Color(0xFFFFFFFF);
  static const Color commonBlack = Color(0xFF111111);

  static const Color backgroundNormalNormalDark = Color(0xFF181A20);
  static const Color backgroundNormalAlternative = Color(0xFF252932);
  static const Color backgroundElevatedAlternative = Color(0xFF1F222A);
  static const Color backgroundElevatedNormal = Color(0xFF2F3340);

  static const Color textSecondary = Color(0xFF9EA3B2);
  static const Color textTertiary = Color(0xFF777C89);
  static const Color labelAssistive = Color(0xFF676E81);
  static const Color labelDisabled = Color(0xFF969CAD);

  static const Color accentForegroundLime = Color(0xFF429E00);

  static const Color lineAlternativeDark = Color(0x0FFFFFFF); // white 6%
  static const Color fillNormalDark = Color(0x1FFFFFFF); // white 12%

  static const Color primaryNormal10 = Color(0x1A00FFB2); // primary 10%
  static const Color primaryNormal24 = Color(0x3D00FFB2); // primary 24%
  static const Color materialDim = Color(0x66222531); // dim scrim, #222531 40%

  static const Color statusNegative = Color(0xFFFF7070);
  static const Color statusPositive = Color(0xFF1ED45A);
  static const Color statusWarning = Color(0xFFFFA938);
}
