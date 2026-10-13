import 'entities/classroom_membership.dart';

/// 반 참여 동의 화면의 모국어 공개 문구 버전(PM-DEC-542 U9 · PM-DEC-543).
///
/// 1 = 모국어 비공개(10-13 전 동의 화면) · 2 = '공유돼요'에 모국어가 있는 화면.
/// 교사 명단의 모국어는 이 값이 2 이상인 학습자에게만 채워진다(b2b-api).
/// 동의 화면 문구를 다시 바꾸면 이 값을 올린다.
const int kLanguageShareVersion = 2;

/// 개인정보처리방침 개정 시행일(PM-DEC-543). 안내 문구의 `{date}` 에 그대로 넣는다.
const String kPrivacyRevisionDate = '2026-10-20';

/// 반 화면에 들어갈 때 한 번 띄울 것.
sealed class ClassroomConsentPrompt {
  const ClassroomConsentPrompt();
}

/// 띄울 것 없음.
class NoConsentPrompt extends ClassroomConsentPrompt {
  /// 상수 인스턴스.
  const NoConsentPrompt();
}

/// [classroom] 에 모국어 공개를 다시 묻는다. 시트가 처리방침 개정 안내도 겸한다.
class LanguageReconsentPrompt extends ClassroomConsentPrompt {
  /// 물을 반을 담는다.
  const LanguageReconsentPrompt(this.classroom);

  /// 아직 새 문구에 동의하지 않은 반.
  final JoinedClassroom classroom;
}

/// 처리방침 개정 안내만 띄운다(이미 새 문구로 동의한 학습자).
class PrivacyNoticePrompt extends ClassroomConsentPrompt {
  /// 상수 인스턴스.
  const PrivacyNoticePrompt();
}

/// 무엇을 띄울지 고른다.
///
/// - 반이 없거나 서버가 동의 버전을 안 주면(옛 서버) 아무것도 띄우지 않는다 —
///   동의 여부를 모르는 채 물으면 이미 동의한 학습자에게 또 묻는다.
/// - 새 문구에 아직 답하지 않은 반이 있으면 그 반에 다시 묻는다. [answered] 는
///   이 기기에서 이미 답한(동의·거절) 반 id 다. 거절해도 다시 묻지 않는다.
/// - 다 답했고 안내를 아직 안 봤으면 안내만 띄운다.
ClassroomConsentPrompt pickClassroomConsentPrompt(
  List<JoinedClassroom> rooms, {
  required Set<int> answered,
  required bool noticeSeen,
}) {
  if (rooms.isEmpty || rooms.any((r) => !r.reportsLanguageShare)) {
    return const NoConsentPrompt();
  }
  for (final r in rooms) {
    if ((r.languageShareVersion ?? 0) < kLanguageShareVersion &&
        !answered.contains(r.classroomId)) {
      return LanguageReconsentPrompt(r);
    }
  }
  return noticeSeen ? const NoConsentPrompt() : const PrivacyNoticePrompt();
}
