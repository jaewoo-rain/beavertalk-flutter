import '../../domain/entities/incoming_call_payload.dart';

/// [IncomingCallPayload]의 파싱 도우미.
///
/// 임의의 `Map`(로컬 트리거로 만든 CallKit 콜 맵, 그리고 나중의 FCM `data` 맵)을
/// 도메인 엔티티로 변환한다. 값이 **문자열/정수 어느 쪽으로 와도** 방어적으로 읽는다
/// (FCM data는 전부 String, 로컬 extra는 int 등 섞여 오기 때문).
///
/// 키는 camelCase(`characterId`)와 snake_case(`character_id`)를 모두 허용하고,
/// callUuid는 `callUuid` / `call_uuid` / CallKit 콜 맵의 최상위 `id`까지 폴백한다.
abstract final class IncomingCallPayloadDto {
  /// [map]에서 [IncomingCallPayload]를 만든다. 필수값이 없으면 안전한 기본값으로 채운다
  /// (callUuid='' , characterId=1). CallKit 콜 맵의 `extra`(중첩)도 함께 훑는다.
  static IncomingCallPayload fromMap(Map<dynamic, dynamic> map) {
    // CallKit 콜 맵은 characterId를 최상위가 아니라 extra 안에 담는다.
    final extra = map['extra'];
    final extraMap = extra is Map ? extra : const <dynamic, dynamic>{};

    return IncomingCallPayload(
      callUuid:
          asString(map['callUuid'] ?? map['call_uuid'] ?? map['id']) ?? '',
      characterId: asInt(
            map['characterId'] ??
                map['character_id'] ??
                extraMap['characterId'] ??
                extraMap['character_id'],
          ) ??
          1,
      characterName: asString(
        map['characterName'] ??
            map['character_name'] ??
            map['nameCaller'] ??
            extraMap['characterName'],
      ),
      avatarUrl: asString(
        map['avatarUrl'] ?? map['avatar_url'] ?? map['avatar'],
      ),
    );
  }

  /// 정수 방어 파싱: int/num/문자열("3") 모두 처리, 실패 시 null.
  static int? asInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  /// 문자열 방어 파싱: 빈 문자열은 null로 취급.
  static String? asString(Object? value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }
}
