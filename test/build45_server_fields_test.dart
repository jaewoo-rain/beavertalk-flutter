import 'package:beavertalk/features/alarm/data/models/alarm_dto.dart';
import 'package:beavertalk/features/review/data/models/review_feedback_dto.dart';
import 'package:beavertalk/features/subscription/data/models/subscription_status_dto.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/weak_sound/data/models/weak_sound_dto.dart';
import 'package:beavertalk/screens/home/learning_summary.dart';
import 'package:beavertalk/screens/plans/winback_survey.dart';
import 'package:flutter_test/flutter_test.dart';

/// 빌드 45 — 서버 새 필드·계약 반영(§22-⑤⑦ · §17 · F008 · F099~F101).
void main() {
  group('§22-⑤⑦ 구독 상태 새 필드', () {
    Map<String, dynamic> body(Map<String, dynamic> extra) => {
          'state': 'active_premium',
          'plan': 'premium',
          'subscribe_id': 7,
          'end_date': '2099-10-28T00:00:00Z',
          ...extra,
        };

    test('billing_period → annual · 구서버(필드 없음)는 null', () {
      expect(SubscriptionStatusDto.fromJson(body({'billing_period': 'yearly'}))
          .toStatus()!.annual, isTrue);
      expect(SubscriptionStatusDto.fromJson(body({'billing_period': 'monthly'}))
          .toStatus()!.annual, isFalse);
      final old = SubscriptionStatusDto.fromJson(body({})).toStatus()!;
      expect(old.annual, isNull);
      expect(old.isTrial, isNull);
      expect(old.state, SubscriptionState.activeMax, reason: '구서버는 지금 동작 그대로');
    });

    test('체험 중(is_trial · 종료일 미래) → 앱 체험 상태 · 만료일은 체험 종료일', () {
      final s = SubscriptionStatusDto.fromJson(body({
        'is_trial': true,
        'trial_ends_at': '2099-10-05T00:00:00Z',
      })).toStatus()!;
      expect(s.state, SubscriptionState.trial);
      expect(s.expiresAt, DateTime.parse('2099-10-05T00:00:00Z').toLocal());
    });

    test('체험 종료일이 지났으면 서버가 체험이라 해도 활성 Premium(09-28 실기기)', () {
      final s1 = SubscriptionStatusDto.fromJson(body({
        'is_trial': true,
        'trial_ends_at': '2020-01-01T00:00:00Z',
      })).toStatus()!;
      expect(s1.state, SubscriptionState.activeMax);
      final s2 = SubscriptionStatusDto.fromJson({
        ...body({'trial_ends_at': '2020-01-01T00:00:00Z'}),
        'state': 'trial',
      }).toStatus()!;
      expect(s2.state, SubscriptionState.activeMax);
    });

    test('만료 + is_trial 은 체험 만료로 안다', () {
      final s = SubscriptionStatusDto.fromJson({
        'state': 'expired',
        'is_trial': true,
      }).toStatus()!;
      expect(s.state, SubscriptionState.expired);
      expect(s.isTrial, isTrue);
    });
  });

  test('§17 — 해지 사유 와이어 코드(other_app 만 이름이 다르다)', () {
    expect({for (final r in WinbackReason.values) r.wire},
        {'expensive', 'unused', 'missing', 'other_app', 'other'});
    expect(WinbackReason.otherApp.wire, 'other_app');
  });

  test('F008 — 알람 저장에 IANA tz 를 싣는다 · tz_offset_min 은 안 보낸다', () {
    final alarm = AlarmDto.fromJson(const {
      'alarm_id': 1,
      'time': '2000-01-01T07:30:00',
      'is_activate': true,
      'days_of_week': ['MON'],
      'character': {'character_id': 1},
    }).toEntity();
    final create = AlarmDto.createBody(alarm, tz: 'Asia/Ho_Chi_Minh');
    final update = AlarmDto.updateBody(alarm, tz: 'Asia/Ho_Chi_Minh');
    expect(create['tz'], 'Asia/Ho_Chi_Minh');
    expect(update['tz'], 'Asia/Ho_Chi_Minh');
    expect(create.containsKey('tz_offset_min'), isFalse);
    expect(AlarmDto.createBody(alarm).containsKey('tz'), isFalse,
        reason: '모르면 키를 뺀다');
    expect(
        AlarmDto.fromJson(const {
          'alarm_id': 1,
          'days_of_week': <String>[],
          'tz': 'Asia/Seoul',
        }).tz,
        'Asia/Seoul');
  });

  group('F099 · F100 · F101 — null 은 0 이 아니다 · 스텁은 점수가 아니다', () {
    test('취약 발음 결과 after null → null · is_stub 이면 score null', () {
      final r = SoundResultDto.parse(const {
        'sound_key': 'onset_ㄱ',
        'after': null,
        'best_score': 80,
        'attempts': 2,
        'char_scores': <dynamic>[],
      });
      expect(r.after, isNull);
      expect(r.score, isNull);
      final stub = SoundResultDto.parse(const {
        'sound_key': 'onset_ㄱ',
        'after': 88,
        'is_stub': true,
        'best_score': 80,
        'attempts': 2,
        'char_scores': <dynamic>[],
      });
      expect(stub.after, 88);
      expect(stub.score, isNull, reason: '스텁 점수는 보이지 않는다');
    });

    test('학습 요약 점수 null 은 null 로 남는다(개수는 0 기본 그대로)', () {
      final s = LearningSummary.fromJson(const {
        'passed': 1,
        'total': 2,
        'overall': null,
        'pronunciation': 70,
        'fluency': null,
        'rhythm': null,
        'sentences': [
          {'sentence': '안녕', 'pronunciation': null, 'fluency': 60, 'rhythm': null},
        ],
      });
      expect(s.overall, isNull);
      expect(s.pronunciation, 70);
      expect(s.fluency, isNull);
      expect(s.sentences.single.pronunciation, isNull);
      expect(s.sentences.single.fluency, 60);
    });

    test('복습 is_stub → 점수·글자 판정을 버린다(미채점과 같이)', () {
      final dto = ReviewFeedbackDto.fromJson(const {
        'review_id': 1,
        'sentence_id': 2,
        'evaluation': {'total_score': 90, 'pronunciation': 90, 'fluency': 90, 'rhythm': 90},
        'char_scores': [
          {'char': '가', 'score': 90, 'grade': '상'},
        ],
        'is_stub': true,
      });
      expect(dto.evaluation, isNull);
      expect(dto.charScores, isEmpty);
      final real = ReviewFeedbackDto.fromJson(const {
        'review_id': 1,
        'sentence_id': 2,
        'evaluation': {'total_score': 90, 'pronunciation': 90, 'fluency': 90, 'rhythm': 90},
        'char_scores': <dynamic>[],
      });
      expect(real.evaluation, isNotNull);
    });
  });
}
