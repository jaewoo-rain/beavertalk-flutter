import 'package:beavertalk/features/character/data/character_tag_labels.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// 캐릭터 성격 태그 임시 번역표(QA F054 · PM-DEC-038).
void main() {
  const tags = [
    'Savage', 'Blunt', 'Tsundere', 'Excited', 'Sweet', 'Dramatic',
    'Chill', 'Goofy', 'Easygoing', 'Warm', 'Tender', 'Emotional',
    'Hyper', 'Cheerful', 'Energetic',
  ];

  test('영어 외 지원 언어 전부 · 태그 15개 전부에 이름이 있다', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final lang = locale.languageCode;
      if (lang == 'en') continue;
      for (final t in tags) {
        final label = localizedCharacterTag(t, lang);
        expect(label.trim(), isNotEmpty, reason: '$lang/$t');
      }
      // 한국어·일본어처럼 원문과 달라야 할 언어에서 원문이 그대로 새면 표가 빠진 것이다.
      if (lang == 'ko' || lang == 'ja' || lang == 'zh' || lang == 'ru') {
        for (final t in tags) {
          expect(localizedCharacterTag(t, lang), isNot(t), reason: '$lang/$t');
        }
      }
    }
  });

  test('한국어 예 · 대소문자 무시 · 모르는 태그와 영어는 원문', () {
    expect(localizedCharacterTag('Tsundere', 'ko'), '츤데레');
    expect(localizedCharacterTag('savage', 'ko'), '독설');
    expect(localizedCharacterTag('Brave', 'ko'), 'Brave');
    expect(localizedCharacterTag('Warm', 'en'), 'Warm');
  });
}
