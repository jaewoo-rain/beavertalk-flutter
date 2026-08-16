import 'package:flutter_test/flutter_test.dart';

/// 봉투 큐 ↔ 마커 발화 시점 회귀.
///
/// ## 무엇을 막는 테스트인가
/// 마커(자막·표정)는 `at: _envAdded` 에 꽂히고 `_envPlayed >= at` 일 때 터진다.
/// 두 카운터는 **통화 스코프 절대값**이라, 큐에서 N칸을 없애면서 `_envPlayed` 를 안 올리면
/// 그 차이가 **영구히** 벌어지고 **이후 모든 마커가 N×25ms 늦게** 터진다.
/// 끼어들 때마다 누적된다.
///
/// 실제로 그랬다(2026-08-16): 폭주 캡 경로는 계상했는데(주석까지 있었다) **취소 경로가 빠졌다.**
/// 실측 `discarded=33120 inFrames` = 1.38초 ⇒ 그 통화 후반 자막이 1.4초 늦었다.
/// ⚠ 입모양은 큐 **값** 으로 도는 별개 경로라 안 늦는다 ⇒ 「입은 맞는데 자막만 늦는」 모양.
///
/// ## ⛔ 숫자가 아니라 **성질**을 고정한다
/// 「취소 후 지연이 0이다」만 검사하면 **세 번째 경로**가 생길 때 또 샌다.
/// 그래서 「큐를 비우는 **모든** 연산 뒤에 불변식이 성립한다」를 검사한다.
///     불변식:  added == played + queueLength
/// 컨트롤러의 봉투 회계를 그대로 옮긴 모형.
/// ⭐ 컨트롤러도 **모든 제거를 `dropFront` 하나로** 모았다 — 여기서도 같다.
///   그 구조가 「한 경로만 고치고 다른 경로는 잊는」 사고를 막는다.
final class Env {
  int added = 0;
  int played = 0;
  int queue = 0;

  void add(int n) {
    queue += n;
    added += n;
  }

  void dropFront(int n) {
    if (n <= 0) return;
    queue -= n;
    played += n; // ← 이 한 줄이 빠진 것이 결함이었다
  }

  void clear() => dropFront(queue);
  void pop() {
    if (queue == 0) return;
    queue -= 1;
    played += 1;
  }

  bool get invariant => added == played + queue;
}

void main() {
  test('⛔ 큐를 비우는 모든 경로 뒤에 불변식이 성립한다', () {
    final e = Env();
    void check(String step) =>
        expect(e.invariant, isTrue, reason: '$step 뒤에 깨졌다');

    e.add(100);
    check('add');
    e.pop();
    check('pop');
    e.dropFront(20); // 폭주 캡 경로
    check('dropFront(캡)');
    e.clear(); // 취소 경로
    check('clear(취소)');
    e.add(40);
    check('add(새 턴)');
    e.clear(); // 통화 종료 경로
    check('clear(종료)');
  });

  test('⭐ 취소 직후 새 마커는 **지연 0** 으로 대상이 된다', () {
    final e = Env()..add(200);
    e.pop(); // 조금 재생됨
    e.clear(); // 끼어들기로 통째 폐기

    // 새 턴의 첫 마커는 지금 위치에 꽂힌다.
    final at = e.added;
    // 취소가 제대로 계상됐으면 **이미 발화 대상**이다 = 다음 재생 틱에 바로 터진다.
    expect(at <= e.played, isTrue,
        reason: '취소분을 계상 안 하면 남은 큐 길이만큼 늦게 터진다');
  });

  test('⛔ 계상을 빠뜨리면 지연이 **누적**된다 — 결함을 재현해 고정한다', () {
    // 결함판: clear 가 played 를 안 올린다.
    const played = 0; // 옛 코드에서는 취소로 절대 안 늘었다
    var added = 0, queue = 0;
    void add(int n) {
      queue += n;
      added += n;
    }

    void brokenClear() => queue = 0; // ← 옛 `_envQueue.clear()`

    add(100);
    brokenClear();
    final lagAfterOne = added - played;
    add(80);
    brokenClear();
    final lagAfterTwo = added - played;
    expect(queue, 0); // 큐는 비웠는데도 지연이 남는다는 게 요점이다

    expect(lagAfterOne, 100);
    // 끼어들 때마다 **누적**된다 — 한 번 어긋나고 마는 게 아니다.
    expect(lagAfterTwo, 180);
    expect(lagAfterTwo, greaterThan(lagAfterOne));
  });
}
