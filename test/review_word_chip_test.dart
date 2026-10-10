import 'package:beavertalk/features/pronunciation/presentation/articulation_sheet.dart';
import 'package:beavertalk/features/pronunciation/presentation/review_word_chip.dart';
import 'package:beavertalk/features/review/data/models/review_feedback_dto.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cases = <String, Map<String, dynamic>>{
    'array missing': {},
    'array null': {'phoneme_misses': null},
    'array empty': {'phoneme_misses': []},
    'expected missing': {
      'phoneme_misses': [
        {'char_index': 0},
      ],
    },
    'expected null': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': null},
      ],
    },
    'expected empty': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': ''},
      ],
    },
    'expected whitespace': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': ' '},
      ],
    },
    'expected only': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': 'ㄴ'},
      ],
    },
    'expected and actual': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': 'ㄴ', 'actual': 'ㅁ'},
      ],
    },
    'expected differs from spelling': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': 'ㅌ'},
      ],
    },
    'different index': {
      'phoneme_misses': [
        {'char_index': 1, 'expected': 'ㄴ'},
      ],
    },
    'unmapped expected': {
      'phoneme_misses': [
        {'char_index': 0, 'expected': 'unsupported'},
      ],
    },
  };
  for (final entry in cases.entries) {
    testWidgets(
      '${entry.key}: word and feedback survive; only actual goal opens',
      (tester) async {
        final feedback = ReviewFeedbackDto.fromJson({
          'review_id': 1,
          'sentence_id': 1,
          'voice_url': 'native-voice-reference',
          'evaluation': {
            'total_score': 60,
            'pronunciation': 60,
            'fluency': 70,
            'rhythm': 80,
          },
          'char_scores': [
            {'char': '나', 'score': 60, 'grade': '하'},
          ],
          ...entry.value,
        }).toEntity();
        var opened = 0;
        var played = 0;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ko'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ReviewWordChip(
                    word: '나',
                    worst: feedback.charScores.single,
                    charIndex: 0,
                    misses: feedback.phonemeMisses,
                    onOpen: (target, current) {
                      opened++;
                      showArticulationSheet(
                        context,
                        data: ArticulationSheetData(
                          word: '나',
                          target: target,
                          current: current,
                        ),
                        onPlayNative: () => played++,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.text('나'), findsOneWidget);
        await tester.tap(find.text('나'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        final opens =
            entry.key == 'expected only' ||
            entry.key == 'expected and actual' ||
            entry.key == 'expected differs from spelling';
        expect(opened, opens ? 1 : 0);
        expect(find.byType(BottomSheet), opens ? findsOneWidget : findsNothing);
        if (opens) {
          expect(find.text('목표'), findsOneWidget);
          expect(
            find.text(
              entry.key == 'expected differs from spelling' ? 'ㅌ' : 'ㄴ',
            ),
            findsOneWidget,
          );
          expect(
            find.text('ㅁ'),
            entry.key == 'expected and actual' ? findsOneWidget : findsNothing,
          );
          await tester.tap(find.bySemanticsLabel('원어민'));
          expect(played, 1);
        }
        expect(feedback.evaluation!.totalScore, 60);
        expect(feedback.charScores.single.score, 60);
        expect(feedback.voiceUrl, 'native-voice-reference');
        expect(tester.takeException(), isNull);
      },
    );
  }
}
