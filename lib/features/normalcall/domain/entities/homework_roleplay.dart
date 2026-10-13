/// 역할극 숙제 통화의 상황·역할 — 서버 `homework_roleplay` 프레임(PM-DEC-622·624).
///
/// 역할극 숙제 통화에서만 `call_started` 뒤 한 번 온다. 값은 교사가 쓴 한국어 원문이고
/// `*Translation` 은 회원 언어 번역이다(없으면 null — 번역 줄만 숨긴다).
/// 통화 화면 GNB 왼쪽 i 버튼이 이 값으로 안내 시트를 연다.
class HomeworkRoleplay {
  const HomeworkRoleplay({
    this.topic,
    this.situation,
    this.aiRole,
    this.learnerRole,
    this.situationTranslation,
    this.aiRoleTranslation,
    this.learnerRoleTranslation,
  });

  final String? topic;
  final String? situation;
  final String? aiRole;
  final String? learnerRole;
  final String? situationTranslation;
  final String? aiRoleTranslation;
  final String? learnerRoleTranslation;

  /// 상황 카드 값 — 상황이 없으면 주제.
  String? get scene => situation ?? topic;

  /// 보여 줄 것이 하나라도 있는가. 없으면 i 버튼을 띄우지 않는다.
  bool get isEmpty => scene == null && aiRole == null;

  static String? _text(Object? v) =>
      v is String && v.trim().isNotEmpty ? v.trim() : null;

  /// 프레임을 읽는다. 모양이 어긋난 칸은 버린다.
  factory HomeworkRoleplay.fromJson(Map<String, dynamic> json) =>
      HomeworkRoleplay(
        topic: _text(json['topic']),
        situation: _text(json['situation']),
        aiRole: _text(json['ai_role']),
        learnerRole: _text(json['learner_role']),
        situationTranslation: _text(json['situation_translation']),
        aiRoleTranslation: _text(json['ai_role_translation']),
        learnerRoleTranslation: _text(json['learner_role_translation']),
      );
}
