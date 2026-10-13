import 'package:shared_preferences/shared_preferences.dart';

/// 모국어 공개 재동의·처리방침 개정 안내를 **한 번만** 띄우려고 기기에 남긴다
/// (PM-DEC-543).
///
/// 동의 여부 자체는 서버(`language_share_version`)가 정본이다. 여기에는 「이미
/// 물었다」만 남긴다 — 거절한 반은 서버 값이 그대로라 이것 없이는 매번 다시 묻는다.
class ClassroomConsentStore {
  /// 저장소를 만든다. [prefs] 를 주면 그것을 쓴다(테스트용).
  const ClassroomConsentStore({SharedPreferences? prefs}) : _injected = prefs;

  final SharedPreferences? _injected;

  /// 재동의에 답한 반 id 목록.
  static const String answeredKey = 'classroom.language_consent_v2_answered';

  /// 처리방침 개정(2026-10-20) 안내를 봤는지.
  static const String noticeKey = 'classroom.privacy_notice_2026_10_20_seen';

  Future<SharedPreferences> get _prefs async =>
      _injected ?? await SharedPreferences.getInstance();

  /// 재동의에 답한 반 id.
  Future<Set<int>> answered() async {
    final p = await _prefs;
    return (p.getStringList(answeredKey) ?? const <String>[])
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
  }

  /// [classroomId] 에 답했다고 남긴다(동의·거절 모두).
  Future<void> markAnswered(int classroomId) async {
    final p = await _prefs;
    final ids = {...await answered(), classroomId};
    await p.setStringList(answeredKey, [for (final id in ids) '$id']);
  }

  /// 개정 안내를 봤는지.
  Future<bool> noticeSeen() async {
    final p = await _prefs;
    return p.getBool(noticeKey) ?? false;
  }

  /// 개정 안내를 봤다고 남긴다.
  Future<void> markNoticeSeen() async {
    final p = await _prefs;
    await p.setBool(noticeKey, true);
  }
}
