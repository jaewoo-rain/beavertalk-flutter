import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../core/i18n/countries.g.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';
import '../molecules/country_select.dart';
import '../molecules/input_field.dart';
import 'bottom_sheet_country_select.dart';

/// 국적 선택 목록의 공용 조각 — 온보딩 2/4(`6645:58395`)와 마이페이지 국적 화면(`6645:59501`)이 같이 쓴다.
///
/// 국가는 [kCountries](249개 · 영어 국가명 · 알파벳순 · 서버·웹과 같은 표)다. 국가명은 UI 언어와
/// 무관하게 영어다(PM-DEC-490). 추천 없음 · 처음엔 미선택(명세 §2).

/// [query] 가 국가명(대소문자 무시) 또는 ISO 코드와 맞는 국가만. 빈 검색어면 전부.
List<(String, String)> filterCountries(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return kCountries;
  return [
    for (final c in kCountries)
      if (c.$2.toLowerCase().contains(q) || c.$1.toLowerCase() == q) c,
  ];
}

/// ISO → 영어 국가명. 표에 없으면 null.
String? countryNameFor(String? iso) {
  if (iso == null) return null;
  final code = iso.toUpperCase();
  for (final c in kCountries) {
    if (c.$1 == code) return c.$2;
  }
  return null;
}

/// 목록 행 사이 간격 — 모바일 8 · 태블릿 20(명세 §4.1). 기기를 묻지 않고 가용 폭으로 가른다
/// (콘텐츠가 캡 600 에 닿는 폭부터 태블릿 배치 · `AppLayout`).
double nationalityRowGap(double availableWidth) =>
    availableWidth >= AppLayout.content + 2 * AppLayout.gutter
        ? AppSpacing.s20
        : AppSpacing.s8;

/// 검색창 — `InputField` size 56 · 왼쪽 돋보기 20(`Icon/Normal` = labelNormal · Dark 대비 · 명세 §4.4).
class NationalitySearchField extends StatelessWidget {
  const NationalitySearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => InputField(
        hintText: hintText,
        onChanged: onChanged,
        leftIcon: AppIcons.search(size: AppSpacing.s20, color: context.c.labelNormal),
      );
}

/// 국가 한 줄 — `CountrySelect`(국기 36×24 + 영어 국가명 · 선택 시 초록 테두리 + 체크).
class NationalityRow extends StatelessWidget {
  const NationalityRow({
    super.key,
    required this.iso,
    required this.name,
    required this.selected,
    required this.onSelect,
  });

  final String iso;
  final String name;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) => CountrySelect(
        name: name,
        flag: countryFlag(iso),
        selected: selected,
        onSelect: onSelect,
      );
}

/// 목록 묶음 라벨(「전체 국가 (알파벳순)」 · 「Current」 · 「All countries」) — `MO/Label 1/Normal - Medium` ·
/// `Label/Alternative`.
class NationalitySectionLabel extends StatelessWidget {
  const NationalitySectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppType.label1.m.copyWith(color: context.c.labelAlternative),
      );
}

/// 활용 안내 「번역이나 학습 환경 개선에 활용되어요」(PM-DEC-503) — `MO/Caption 1/Regular` · `Label/Alternative`.
class NationalityUsageNotice extends StatelessWidget {
  const NationalityUsageNotice(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppType.caption1.r.copyWith(color: context.c.labelAlternative),
      );
}

/// 검색 결과 0건 안내.
class NationalitySearchEmpty extends StatelessWidget {
  const NationalitySearchEmpty(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: context.c.labelNeutral),
        ),
      );
}
