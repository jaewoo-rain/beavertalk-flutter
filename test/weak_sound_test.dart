/// 취약 발음 학습 — 자동 연습 상태기계 + DTO 파싱.
///
/// 시계·네트워크·위젯 없이 돈다. 여기서 고정하는 불변식은 실기기에서 재현하기 가장
/// 어려운 것들이다 — 중복 완료 콜백, 화면 이탈 후 재개, 「점수 0」과 「표본 없음」의 구분.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/weak_sound/data/models/weak_sound_dto.dart';
import 'package:beavertalk/features/weak_sound/domain/auto_practice.dart';

void main() {
  group('AutoPracticeMachine', () {
    test('재생 → 따라 말하기 → 다음 항목 순으로 돈다', () {
      final m = AutoPracticeMachine(4);
      expect(m.state.phase, AutoPracticePhase.idle);

      expect(m.start().phase, AutoPracticePhase.playing);
      expect(m.state.index, 0);
      expect(m.onPlaybackComplete().phase, AutoPracticePhase.repeating);

      final next = m.onRepeatComplete();
      expect(next.phase, AutoPracticePhase.playing);
      expect(next.index, 1);
    });

    test('마지막 항목을 따라 말하면 done — 점수 단계가 없다', () {
      final m = AutoPracticeMachine(2)..start();
      for (var i = 0; i < 2; i++) {
        m.onPlaybackComplete();
        m.onRepeatComplete();
      }
      expect(m.state.phase, AutoPracticePhase.done);
      expect(m.state.index, 1); // 마지막 항목을 가리킨 채 끝난다
    });

    test('완료 콜백이 두 번 와도 항목을 건너뛰지 않는다', () {
      // 오디오 플러그인은 완료를 중복으로 알릴 수 있다. 그때 index 가 두 칸 뛰면
      // 단어 하나가 조용히 사라진다 — 화면에는 「2/4」 다음에 「4/4」 로만 보인다.
      final m = AutoPracticeMachine(4)..start();
      m.onPlaybackComplete();
      m.onPlaybackComplete(); // 무시돼야 한다
      expect(m.state.phase, AutoPracticePhase.repeating);
      m.onRepeatComplete();
      m.onRepeatComplete(); // 재생 중이라 무시
      expect(m.state.index, 1);
      expect(m.state.phase, AutoPracticePhase.playing);
    });

    test('항목이 0개면 start 가 곧바로 done — 빈 화면에 갇히지 않는다', () {
      expect(AutoPracticeMachine(0).start().phase, AutoPracticePhase.done);
    });

    test('이탈 후 재개는 보던 항목의 재생부터 — 처음으로 되돌아가지 않는다', () {
      final m = AutoPracticeMachine(4)..start();
      m.onPlaybackComplete();
      m.onRepeatComplete(); // index 1, playing
      m.onPlaybackComplete(); // index 1, repeating

      expect(m.pause().phase, AutoPracticePhase.idle);
      expect(m.state.index, 1); // 인덱스는 유지

      // 따라 말하기에서 멈췄어도 재생부터 — 돌아온 사용자는 방금 들은 것을 기억하지 못한다.
      expect(m.resume().phase, AutoPracticePhase.playing);
      expect(m.state.index, 1);
    });

    test('done 이후 pause·resume 는 아무것도 하지 않는다', () {
      final m = AutoPracticeMachine(1)..start();
      m.onPlaybackComplete();
      m.onRepeatComplete();
      expect(m.state.phase, AutoPracticePhase.done);
      expect(m.pause().phase, AutoPracticePhase.done);
      expect(m.resume().phase, AutoPracticePhase.done);
    });

    test('displayIndex 는 1부터 — 화면의 「1 / 4」 표기', () {
      final m = AutoPracticeMachine(4)..start();
      expect(m.state.displayIndex, 1);
      expect(m.state.total, 4);
    });
  });

  group('repeatWindow', () {
    test('음성 길이에 비례하고 하한이 있다', () {
      // 고정 초를 쓰면 짧은 단어는 지루하고 긴 문장은 잘린다.
      final short = repeatWindow(const Duration(milliseconds: 400));
      final long = repeatWindow(const Duration(seconds: 3));
      expect(short, const Duration(milliseconds: 1200)); // 하한
      expect(long.inMilliseconds, 4300); // 3000 × 1.3 + 400
      expect(long > short, isTrue);
    });

    test('반응 시간은 더하고 발화 시간만 곱한다', () {
      // 입을 떼기까지의 시간은 문장 길이와 무관하다. 곱셈에만 맡기면 짧은 단어가
      // 유독 빠듯해진다 — 실측 「까치」 984ms 는 1.35배면 0.34초밖에 안 남았다.
      final w = repeatWindow(const Duration(milliseconds: 984));
      expect(w.inMilliseconds, 1679); // 984 × 1.3 + 400
      // 곱셈만 썼다면 1,279ms 였다. 덧셈 항이 실제로 일하고 있는지 본다.
      expect(w.inMilliseconds, greaterThan((984 * 1.3).round()));
    });

    test('길이를 모르면 하한을 쓴다 — 0 이 아니다', () {
      expect(repeatWindow(null), const Duration(milliseconds: 1200));
      expect(repeatWindow(Duration.zero), const Duration(milliseconds: 1200));
    });
  });

  group('목록 파싱', () {
    test('점수 없음(null)과 0점을 섞지 않는다', () {
      final list = WeakSoundListDto.parse({
        'national': {
          'country': 'Vietnam',
          'items': [
            {'sound_key': 'coda_ㄹ', 'label': '받침 ㄹ', 'card_desc': 'x',
             'type': 'sound', 'score': 0, 'share': 41},
            {'sound_key': 'rule_연음', 'label': '연음', 'card_desc': 'y',
             'type': 'rule', 'score': null, 'share': 33},
          ],
        },
        'mine': [],
        'recommended': 'coda_ㄹ',
      });
      expect(list.national.country, 'Vietnam');
      expect(list.national.items[0].score, 0); // 0점은 0점
      expect(list.national.items[1].score, isNull); // 표본 없음은 null
      expect(list.recommended, 'coda_ㄹ');
    });

    test('국적 섹션이 비어도 파싱이 성공한다 — 통계에 없는 나라', () {
      final list = WeakSoundListDto.parse({
        'national': {'country': 'Narnia', 'items': []},
        'mine': [],
      });
      expect(list.national.items, isEmpty);
      expect(list.recommended, isNull);
    });

    test('sound_key 에서 자모·받침 여부를 뽑는다 — 서버 도해 이름을 안 쓴다', () {
      final list = WeakSoundListDto.parse({
        'national': {'items': [
          {'sound_key': 'coda_ㄹ', 'label': '', 'card_desc': '', 'type': 'sound'},
          {'sound_key': 'onset_ㅅ', 'label': '', 'card_desc': '', 'type': 'sound'},
          {'sound_key': 'rule_연음', 'label': '', 'card_desc': '', 'type': 'rule'},
        ]},
        'mine': [],
      });
      final items = list.national.items;
      expect(items[0].jamoTarget, (jamo: 'ㄹ', isCoda: true));
      expect(items[1].jamoTarget, (jamo: 'ㅅ', isCoda: false));
      expect(items[2].jamoTarget, isNull); // 규칙은 도해가 없다
      expect(items[2].isRule, isTrue);
    });

    test('집계가 소수로 와도 정수로 반올림한다', () {
      final list = WeakSoundListDto.parse({
        'national': {'items': []},
        'mine': [
          {'sound_key': 'coda_ㄱ', 'label': '', 'card_desc': '', 'type': 'sound',
           'score': 55.6},
        ],
      });
      expect(list.mine[0].score, 56);
    });
  });

  group('과(lesson) 파싱', () {
    Map<String, dynamic> soundJson() => {
          'sound_key': 'onset_ㄱ',
          'label': '초성 ㄱ',
          'type': 'sound',
          'card_desc': '혀뿌리로 막았다 살짝 떼요',
          'jamo': 'ㄱ',
          'position': 'onset',
          'score': 62,
          'learned': false,
          'payload': {
            'rep_syllable': '가',
            'how_to': ['a', 'b', 'c'],
            'words': [
              {'text': '가방', 'meaning_en': 'bag'},
              {'text': '고기', 'meaning_en': 'meat'},
              {'text': '구두', 'meaning_en': 'shoes'},
              {'text': '기차', 'meaning_en': 'train'},
            ],
            'sentence': {
              'text': '그 가방에 고기가 가득 있어요',
              'translation_en': 'That bag is full of meat.',
              'chunks': ['가득 있어요', '고기가 가득 있어요', '그 가방에 고기가 가득 있어요'],
            },
            'test': {'text': '가게에서 과자를 골라요', 'translation_en': 'x'},
          },
        };

    test('payload 를 한 겹 풀어 4단계를 채운다', () {
      final l = SoundLessonDto.parse(soundJson());
      expect(l.howTo.length, 3);
      expect(l.words.length, 4);
      expect(l.words.first.text, '가방');
      expect(l.sentence.chunks.length, 3);
      expect(l.test.text, '가게에서 과자를 골라요');
      expect(l.test.chunks, isEmpty); // 평가 문장은 조각이 없다
      expect(l.repSyllable, '가');
      expect(l.jamoTarget, (jamo: 'ㄱ', isCoda: false));
      expect(l.isRule, isFalse);
    });

    test('규칙 항목은 변환 도식과 [발음] 줄을 갖는다', () {
      final l = SoundLessonDto.parse({
        'sound_key': 'rule_연음',
        'label': '연음',
        'type': 'rule',
        'card_desc': '받침을 뒤로 넘겨요',
        'payload': {
          'symbol': '연음',
          'how_to': ['a', 'b', 'c'],
          'formula': [
            {'spelling': '한국이', 'pronunciation': '한구기'},
          ],
          'words': [
            {'text': '한국어', 'pronunciation': '한구거', 'meaning_en': 'Korean'},
          ],
          'sentence': {
            'text': '한국어 음악을 들어요',
            'pronunciation': '한구거 으마글 드러요',
            'chunks': ['들어요'],
          },
          'test': {'text': '옷을 입어 봐요', 'pronunciation': '오슬 이버 봐요'},
        },
      });
      expect(l.isRule, isTrue);
      expect(l.jamoTarget, isNull);
      expect(l.symbol, '연음');
      expect(l.formula.single.spelling, '한국이');
      expect(l.formula.single.pronunciation, '한구기');
      expect(l.words.single.pronunciation, '한구거');
      expect(l.sentence.pronunciation, '한구거 으마글 드러요');
      expect(l.test.pronunciation, '오슬 이버 봐요');
    });

    test('payload 가 비어도 터지지 않는다 — 빈 과로 내려앉는다', () {
      final l = SoundLessonDto.parse({'sound_key': 'coda_ㄹ', 'type': 'sound'});
      expect(l.howTo, isEmpty);
      expect(l.words, isEmpty);
      expect(l.sentence.text, '');
      expect(l.test.text, '');
    });
  });

  group('채점 결과 파싱', () {
    test('학습 전/후·하락 여부를 가른다', () {
      final r = SoundResultDto.parse({
        'sound_key': 'coda_ㄹ', 'label': '받침 ㄹ',
        'before': 62, 'after': 84, 'delta': 22,
        'best_score': 84, 'attempts': 1, 'text': '평가 문장',
        'char_scores': [{'char': '평', 'score': 84, 'grade': '상'}],
        'phoneme_misses': [{'char_index': 0, 'expected': 'ㅍ'}],
      });
      expect(r.delta, 22);
      expect(r.dropped, isFalse);
      expect(r.isFirstMeasure, isFalse);
      expect(r.charScores.single.grade, '상');
      expect(r.phonemeMisses.single.expected, 'ㅍ');
    });

    test('첫 측정은 before·delta 가 null', () {
      final r = SoundResultDto.parse({
        'sound_key': 'rule_연음', 'label': '연음', 'after': 77,
        'best_score': 77, 'attempts': 1, 'text': 'x',
      });
      expect(r.isFirstMeasure, isTrue);
      expect(r.delta, isNull);
      expect(r.dropped, isFalse); // delta 가 null 이면 하락이 아니다
      expect(r.phonemeMisses, isEmpty);
    });

    test('점수 하락을 잡는다', () {
      final r = SoundResultDto.parse({
        'sound_key': 'coda_ㄹ', 'label': '받침 ㄹ',
        'before': 84, 'after': 80, 'delta': -4,
        'best_score': 84, 'attempts': 2, 'text': 'x',
      });
      expect(r.dropped, isTrue);
      expect(r.bestScore, 84); // 최고점은 남는다
    });
  });
}
