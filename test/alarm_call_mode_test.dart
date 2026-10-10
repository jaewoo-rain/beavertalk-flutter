import 'package:beavertalk/features/alarm/data/models/alarm_dto.dart';
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';
import 'package:flutter_test/flutter_test.dart';

/// 알람별 통화 모드 — 서버 `Alarm.call_type`("auto" | "chat", dev·운영 09-24 배포).
/// 그 밖의 값은 서버가 422 다 — 앱은 두 값만 보낸다.
void main() {
  Map<String, dynamic> json({Object? callType = _absent}) => {
        'alarm_id': 34,
        'time': '2000-01-01T08:00:00Z',
        'is_activate': true,
        'character': {'character_id': 1, 'name': 'Baba'},
        'days_of_week': ['MON'],
        if (!identical(callType, _absent)) 'call_type': callType,
      };

  test('chat 이면 자유대화, auto 면 학습', () {
    expect(AlarmDto.fromJson(json(callType: 'chat')).toEntity().callMode,
        AlarmCallMode.chat);
    expect(AlarmDto.fromJson(json(callType: 'auto')).toEntity().callMode,
        AlarmCallMode.learn);
  });

  test('키가 없거나 모르는 값이면 학습 — 서버 기본값과 같다', () {
    expect(AlarmDto.fromJson(json()).toEntity().callMode, AlarmCallMode.learn);
    expect(AlarmDto.fromJson(json(callType: 'normal')).toEntity().callMode,
        AlarmCallMode.learn);
  });

  test('추가(POST)·수정(PUT) 본문에 call_type 이 서버 값 그대로 실린다', () {
    final a = AlarmDto.fromJson(json(callType: 'chat')).toEntity();
    expect(AlarmDto.createBody(a)['call_type'], 'chat');
    expect(AlarmDto.updateBody(a.copyWith(callMode: AlarmCallMode.learn))['call_type'],
        'auto');
  });

  test('와이어 값은 서버 Literal["auto","chat"] 과 글자 그대로', () {
    expect(AlarmCallMode.values.map((m) => m.wireValue).toList(), ['auto', 'chat']);
  });
}

const Object _absent = Object();
