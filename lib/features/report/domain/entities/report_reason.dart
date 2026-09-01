import '../../../../l10n/app_localizations.dart';

/// 사용자가 고르는 신고 사유.
///
/// Google Play 생성형 AI 정책은 "AI로 콘텐츠를 생성하는 앱은 사용자가 **앱을
/// 벗어나지 않고** 불쾌한 콘텐츠를 신고할 수 있어야 한다"고 요구한다. 비버톡은
/// AI 캐릭터와 음성으로 대화하는 앱이라 이 정책의 정면 대상이고, 신고 경로가
/// 없으면 첫 릴리스가 정책 반려된다.
///
/// [code]는 DB(`public.content_report.reason`)에 그대로 들어가는 안정 식별자다.
/// **한 번 배포한 뒤에는 바꾸지 마라** — 이미 저장된 신고와 대조가 깨진다.
/// 표시 문구는 [label]로 30개 로케일에서 번역된다.
enum ReportReason {
  /// 성적인 내용.
  sexual('sexual'),

  /// 혐오·차별 발언.
  hate('hate'),

  /// 폭력적이거나 위협적인 내용.
  violence('violence'),

  /// 자해·자살을 조장하는 내용.
  selfHarm('self_harm'),

  /// 사실과 다른 정보.
  misinformation('misinformation'),

  /// 위 어디에도 없는 사유. 자유 입력과 함께 쓰라고 안내한다.
  other('other');

  const ReportReason(this.code);

  /// DB에 저장되는 불변 코드.
  final String code;

  /// 화면에 보이는 번역 문구.
  String label(AppLocalizations l10n) => switch (this) {
        ReportReason.sexual => l10n.reportReasonSexual,
        ReportReason.hate => l10n.reportReasonHate,
        ReportReason.violence => l10n.reportReasonViolence,
        ReportReason.selfHarm => l10n.reportReasonSelfHarm,
        ReportReason.misinformation => l10n.reportReasonMisinfo,
        ReportReason.other => l10n.reportReasonOther,
      };
}

/// 신고가 시작된 화면. 어디서 눌렀는지가 분류에 필요하다.
enum ReportSource {
  /// 통화 종료 화면.
  callFinish('call_finish'),

  /// 대화 기록 목록.
  recordList('record_list');

  const ReportSource(this.code);

  /// DB에 저장되는 불변 코드.
  final String code;
}
