import 'dart:typed_data';

/// 합성된 mp3 를 **텍스트 + 캐릭터** 기준으로 들고 있는 인메모리 LRU 캐시.
///
/// 왜 있나: 백엔드 요청이다(2026-09-04 — "캐싱도 부탁드려요"). `POST /tts/speech` 는
/// 부를 때마다 실제로 합성이 돌아 **요금이 나간다.** 같은 힌트 예시를 다시 눌렀을 때
/// 또 왕복하면 그 돈이 그냥 새는 것이고, 재생도 그만큼 늦다.
///
/// 캐릭터를 키에 넣는 이유: 같은 문장이라도 **캐릭터가 다르면 다른 목소리**다. 텍스트만
/// 키로 쓰면 캐릭터를 바꾼 뒤에도 이전 목소리가 재생된다.
///
/// ⚠ 캐릭터는 **요청에는 안 실린다** — 목소리는 서버가 회원 정보로 정한다. 여기서만
/// 키로 쓴다. 즉 이 키는 "서버가 무엇을 줄 것인가"의 앱 쪽 추정이고, 그 추정이 바뀌는
/// 순간(=캐릭터 변경) 캐시가 갈리게 하는 것이 목적이다.
///
/// 프로세스 메모리에만 산다(앱을 끄면 사라진다). 짧은 문장 mp3 는 수십 KB 수준이라
/// [maxEntries] 만큼 들고 있어도 1MB 안쪽이다. 디스크 캐시는 필요해지면 그때 붙인다.
class SpeechCache {
  SpeechCache({this.maxEntries = 32});

  /// 보관할 최대 항목 수. 넘으면 **가장 오래 안 쓴 것**부터 버린다.
  final int maxEntries;

  // 삽입 순서를 유지하는 Map — 맨 앞이 가장 오래 안 쓴 항목이다.
  final Map<String, Uint8List> _entries = <String, Uint8List>{};

  /// 캐시 키. 텍스트는 앞뒤 공백을 털어 같은 문장이 두 벌로 캐시되지 않게 한다.
  static String keyFor(String text, int? characterId) =>
      '${characterId ?? '-'}|${text.trim()}';

  /// 저장된 음성, 없으면 null. 꺼내 쓴 항목은 **가장 최근 사용**으로 올린다.
  Uint8List? get(String key) {
    final hit = _entries.remove(key);
    if (hit == null) return null;
    _entries[key] = hit; // 맨 뒤로 재삽입 = 최근 사용
    return hit;
  }

  /// [bytes] 를 [key] 로 저장한다. 빈 바이트는 저장하지 않는다 — 실패를 캐시해 두면
  /// 서버가 복구된 뒤에도 계속 실패한 것처럼 보인다.
  void put(String key, Uint8List bytes) {
    if (bytes.isEmpty) return;
    _entries.remove(key);
    _entries[key] = bytes;
    while (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }
  }

  /// 보관 중인 항목 수(테스트·디버깅용).
  int get length => _entries.length;

  /// 전부 버린다. 로그아웃처럼 사용자가 바뀌는 자리에서 쓴다.
  void clear() => _entries.clear();
}
