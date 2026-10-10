/// 서버가 말하는 「이 통화를 이어갈 수 있는가」 — `GET /calls/{id}/resume-status`.
///
/// ## 왜 서버에 물어보나
///
/// 상한은 클라도 계산할 수 있다([CallAllowance]). 문제는 **누가 유료인지**에 대한
/// 판단이 서로 다를 수 있다는 것이다. 실제로 그래서 하루를 날렸다(2026-08-24):
///
/// ```
/// 앱  : 「나는 Pro 다」  → 「Keep going?」 을 띄우고 이어가기를 요청
/// 서버: 「너는 Free 다」  → 조각 상한 소진 → 조용히 **새 통화**로 떨어뜨림
/// 화면: 멀쩡히 이어진 것처럼 보이고, 비버만 앞 대화를 잊는다
/// ```
///
/// ⛔ **에러가 나지 않는다.** 서버가 일부러 그렇게 설계했다(백엔드 문서: "검증에 걸려도
///   통화는 열립니다 — 거절이 아닙니다"). 그래서 화면만 봐서는 원인이 안 드러난다.
///   물어보는 쪽이 유일하게 정직한 길이다.
library;

/// `GET /calls/{call_id}/resume-status` 의 응답.
class CallResumeStatus {
  /// Creates a status snapshot.
  const CallResumeStatus({
    required this.ready,
    required this.canResume,
    required this.fragmentCount,
    required this.maxFragments,
    required this.analyzing,
  });

  /// 다음 조각에 넘길 **요약이 준비됐는가**.
  ///
  /// ⚠ **잠금이 아니라 신호다.** false 인 채 이어가도 동작한다 — 서버가 그 자리에서
  ///   요약을 만들 뿐이고, 그만큼 통화 시작이 늦는다. 그래서 「기다리면 더 좋다」는
  ///   뜻이지 「기다려야 한다」가 아니다. 여기서 무한정 기다리면 **누를 수 있는 버튼을
  ///   눌렀는데 통화가 안 열리는** 상태가 된다.
  final bool ready;

  /// 조각 상한이 **남았는가**. 이게 false 면 이어가기를 권하면 안 된다.
  final bool canResume;

  /// 지금까지 쓴 조각 수.
  final int fragmentCount;

  /// 이 회원의 조각 상한 — Free 1 / Pro·Max 3.
  ///
  /// ⭐ **서버가 아는 플랜**으로 계산된 값이다. 앱이 아는 플랜과 다를 수 있고,
  ///   다를 때는 **이쪽이 맞다** — 이어가기를 실제로 허락하는 쪽이 서버라서다.
  final int maxFragments;

  /// 아직 요약을 만드는 중인가.
  final bool analyzing;

  /// 서버 JSON 에서 만든다. 필드가 빠졌으면 **보수적인 쪽**으로 채운다 —
  /// 없는 값을 낙관해서 이어가기를 권하면 오늘의 그 버그가 되돌아온다.
  factory CallResumeStatus.fromJson(Map<String, dynamic> json) =>
      CallResumeStatus(
        ready: json['ready'] as bool? ?? false,
        canResume: json['can_resume'] as bool? ?? false,
        fragmentCount: (json['fragment_count'] as num?)?.toInt() ?? 0,
        maxFragments: (json['max_fragments'] as num?)?.toInt() ?? 0,
        analyzing: json['analyzing'] as bool? ?? false,
      );

  @override
  String toString() => 'CallResumeStatus(ready: $ready, canResume: $canResume, '
      'fragments: $fragmentCount/$maxFragments, analyzing: $analyzing)';
}
