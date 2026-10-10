import 'package:flutter_test/flutter_test.dart';

/// 자막 유지 규약 회귀 — **화면이 비는 순간은 통화 전체에서 0** 이어야 한다.
///
/// 사장님 지시(2026-08-15):
///   "새 대사로 완전 바뀌는거지 이전 대사 지우고 새 대사로 처음부터 전사되도록해줘,
///    stt로 중간에 끊거나 다 말했으면 근야 계속 보여주게해줘"
///
/// ⛔ 예전엔 `turn_start` 에서 자막을 비웠다. 그런데 `turn_start` 는 서버 불변식 I2 상
///   **첫 오디오보다 먼저** 온다(실측 `turn_start` ~1.0초 / 첫 소리 ~2.35초).
///   ⇒ 약 1.3초 화면이 완전히 빈다. 그게 사장님이 「자막이 사라진다」고 하신 것이다.
///
/// ## ⚠ 이 스위트가 검사하는 것과 **안 하는 것**
/// 검사한다: **쓰기 규칙**(첫 글자에서 교체 · 그 뒤 누적 · 교체는 턴당 1회).
///   그 규칙이 깨지면 「이전 대사 뒤에 새 대사가 붙는」 버그가 그대로 나간다.
/// ⛔ **안 한다**: 「`turn_start` 가 화면을 안 지운다」와 「끼어들기가 화면을 안 지운다」는
///   *쓰지 않는다*는 성질이라 단위 테스트로 못 잡는다. 그건 **작성자가 코드로 확인했다** —
///   `beaverSubtitle` 을 쓰는 자리는 컨트롤러에 셋뿐이고(`_advanceReveal` · `turn_start` ·
///   `output_transcript`), `_clearPlayback`(barge-in)은 드러내기 버퍼·마커만 비운다.
///   ⇒ 그 셋이 늘어나면 이 주석이 낡는다. 늘릴 때 여기를 같이 보라.
void main() {
  /// 컨트롤러의 자막 쓰기 규칙을 그대로 옮긴 것.
  /// `turn_start` 가 세운 플래그가 **첫 쓰기에서만** 교체하고 스스로 내려간다.
  ({String subtitle, bool replaceNext}) write({
    required String subtitle,
    required bool replaceNext,
    required String delta,
  }) =>
      (subtitle: replaceNext ? delta : subtitle + delta, replaceNext: false);

  test('⭐ 새 대사 첫 글자에서 **통째로 교체**된다 — 이어붙이면 안 된다', () {
    final r =
        write(subtitle: '이전 턴 대사입니다', replaceNext: true, delta: '새 대사');
    expect(r.subtitle, '새 대사');
    expect(r.subtitle, isNot(contains('이전 턴')));
  });

  test('첫 글자 뒤부터는 누적이다 — 토큰마다 갈아치우면 한 글자씩만 보인다', () {
    var st = write(subtitle: '이전', replaceNext: true, delta: '새');
    st = write(subtitle: st.subtitle, replaceNext: st.replaceNext, delta: ' 대사');
    st = write(subtitle: st.subtitle, replaceNext: st.replaceNext, delta: '입니다');
    expect(st.subtitle, '새 대사입니다');
  });

  test('⛔ 교체는 턴당 한 번뿐이다 — 두 번째 델타가 또 갈아치우면 안 된다', () {
    final first = write(subtitle: '이전', replaceNext: true, delta: 'A');
    expect(first.replaceNext, isFalse);
    final second = write(
        subtitle: first.subtitle, replaceNext: first.replaceNext, delta: 'B');
    expect(second.subtitle, 'AB');
  });

  test('플래그가 안 섰으면 이전 대사에 그대로 이어진다 — 턴 안에서는 누적이 기본이다', () {
    final r = write(subtitle: '앞부분', replaceNext: false, delta: '뒷부분');
    expect(r.subtitle, '앞부분뒷부분');
  });
}
