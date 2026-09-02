import 'package:shared_preferences/shared_preferences.dart';

/// 참여한 반 id 를 기기에 남긴다.
///
/// **왜 필요한가** — `GET /classrooms/my/assignments` 가 `classroom_id` 를 주지
/// 않는다(2026-09-02 서버 실측). 그런데 반 나가기는
/// `DELETE /classrooms/{id}/leave` 로 id 를 요구한다. 참여할 때는 id 를 알고
/// 있으므로 그때 적어 둔다.
///
/// **한계 — 재설치하면 사라진다.** 그때는 나가기 버튼이 대상을 못 찾는다.
/// 서버가 목록 응답에 `classroom_id` 를 넣어 주면 이 파일은 지워도 된다.
class JoinedClassStore {
  /// 저장소를 만든다. [prefs] 를 주면 그것을 쓴다(테스트용).
  const JoinedClassStore({SharedPreferences? prefs}) : _injected = prefs;

  final SharedPreferences? _injected;

  /// 저장 키. 계정별로 나누지 않는다 — 반 참여는 계정 하나에 하나다.
  static const String key = 'classroom.joined_id';

  Future<SharedPreferences> get _prefs async =>
      _injected ?? await SharedPreferences.getInstance();

  /// 참여 직후 부른다.
  Future<void> save(int classroomId) async {
    final p = await _prefs;
    await p.setInt(key, classroomId);
  }

  /// 저장된 반 id. 없으면 null 이다.
  Future<int?> read() async {
    final p = await _prefs;
    return p.getInt(key);
  }

  /// 나간 뒤 지운다. 남겨 두면 이미 나간 반을 또 나가려 한다.
  Future<void> clear() async {
    final p = await _prefs;
    await p.remove(key);
  }
}
