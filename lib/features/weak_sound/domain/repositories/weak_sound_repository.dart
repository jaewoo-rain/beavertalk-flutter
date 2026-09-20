import 'dart:typed_data';

import '../entities/sound_lesson.dart';
import '../entities/sound_result.dart';
import '../entities/weak_sound_item.dart';

/// 취약 발음 학습이 서버에 기대하는 것. data 계층이 구현한다.
///
/// 엔티티를 돌려주고 실패는 `AppException`(`core/error/app_exception.dart`)으로 던진다.
/// dio/JSON 이 여기로 새지 않는다.
///
/// ⚠️ 연습 단계(단어·문장)에는 메서드가 없다 — **무채점·자동진행이라 서버가 알 일이 없다.**
/// 점수는 [assess] 한 번으로만 움직인다.
abstract interface class WeakSoundRepository {
  /// 목록 — 국적별 5 + 내 취약 5 + 추천 1개.
  ///
  /// 억양 정보나 발음 기록이 없어도 성공한다(빈 목록). 진입 버튼이 회원 상태에 따라
  /// 실패하면 안 된다.
  Future<WeakSoundList> list();

  /// 4단계 콘텐츠 전량. 없는 소리면 `AppException`(404).
  Future<SoundLesson> lesson(String soundKey);

  /// 평가 단계 녹음 제출 → **서버 채점** 결과.
  ///
  /// [wavBytes] 는 완전한 WAV(PCM16/16kHz/mono)다 — 복습 경로와 같은 포맷이라
  /// `ReviewAudioRecorder` + `pcm16ToWav` 를 그대로 재사용한다.
  Future<SoundResult> assess(String soundKey, Uint8List wavBytes);
}
