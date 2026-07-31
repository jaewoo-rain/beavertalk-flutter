/// 인바운드 콜(비버가 거는 전화)의 순수 도메인 페이로드.
///
/// "누가/어떤 캐릭터로 전화가 왔는지"를 담는 값 객체다. 지금은 로컬 트리거
/// (`simulateIncomingCall`)로만 만들지만, 나중에 서버 푸시(FCM data / APNs VoIP)의
/// data 맵도 [IncomingCallPayloadDto]를 통해 이 타입으로 매핑해 그대로 재사용한다.
///
/// 플랫폼/패키지에 의존하지 않는 순수 Dart(테스트·재사용 용이).
class IncomingCallPayload {
  /// 페이로드를 생성한다.
  const IncomingCallPayload({
    required this.callUuid,
    required this.characterId,
    this.characterName,
    this.imageUrl,
  });

  /// CallKit 세션 식별자(멱등 키). 같은 전화의 중복 이벤트/재전송을 dedup하는 기준.
  final String callUuid;

  /// 수신 화면(CallKit)에 얼굴을 그리기 위한 캐릭터 id.
  ///
  /// ⚠ **통화 상대를 정하는 값이 아니다.** 통화 캐릭터는 서버가 [callUuid] 로
  /// 알람을 되짚어 정한다 — 앱이 id 를 보내면 그게 곧 "클라가 캐릭터를 고르는"
  /// 통로가 되고, 실제로 그래서 미구매 유료 캐릭터로도 통화가 열렸다.
  final int characterId;

  /// 수신 화면에 표시할 발신자 이름(예: 'Annoying Beaver'). 없으면 서비스가 기본값 사용.
  final String? characterName;

  /// Android 수신 화면에 표시할 캐릭터 이미지 URL(서버 필드명 `image_url`).
  /// 없으면 표시 안 함.
  final String? imageUrl;
}
