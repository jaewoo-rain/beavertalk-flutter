import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/join_preview.dart';

/// 참여 5화면(A1~A5)이 함께 쓰는 초안.
///
/// 화면을 넘어가며 모으는 값이라 화면 하나에 둘 수 없다. 참여가 끝나거나 흐름을
/// 벗어나면 [JoinDraftNotifier.clear] 로 비운다 — 남겨 두면 다음 참여 때 남의
/// 이름이 미리 채워진다.
class JoinDraft {
  /// 초안을 만든다.
  const JoinDraft({
    this.code = '',
    this.preview,
    this.rosterName = '',
    this.studentNo = '',
    this.consent = false,
  });

  /// 입력한 6자리 참여 코드.
  final String code;

  /// A2 에서 확인한 반. null 이면 아직 조회 전이다.
  final JoinPreview? preview;

  /// 반에서 쓸 이름.
  final String rosterName;

  /// 학번(선택).
  final String studentNo;

  /// 공유 동의 여부. **false 면 서버가 400 으로 거절한다** — 화면이 먼저 막는다.
  final bool consent;

  /// 일부만 바꾼 사본.
  JoinDraft copyWith({
    String? code,
    JoinPreview? preview,
    String? rosterName,
    String? studentNo,
    bool? consent,
  }) {
    return JoinDraft(
      code: code ?? this.code,
      preview: preview ?? this.preview,
      rosterName: rosterName ?? this.rosterName,
      studentNo: studentNo ?? this.studentNo,
      consent: consent ?? this.consent,
    );
  }
}

/// 참여 흐름 동안 [JoinDraft] 를 들고 있는다.
final joinDraftProvider = NotifierProvider<JoinDraftNotifier, JoinDraft>(
  JoinDraftNotifier.new,
);

/// [JoinDraft] 갱신기.
class JoinDraftNotifier extends Notifier<JoinDraft> {
  @override
  JoinDraft build() => const JoinDraft();

  /// A1 에서 확인한 코드와 그 코드로 조회한 반을 함께 넣는다.
  ///
  /// 둘을 따로 넣지 않는 이유 — 코드만 바뀌고 미리보기가 남으면 A2 가 옛 반을
  /// 보여준다.
  void setPreview(String code, JoinPreview preview) {
    state = state.copyWith(code: code, preview: preview);
  }

  /// A3 의 이름·학번.
  void setProfile({required String rosterName, required String studentNo}) {
    state = state.copyWith(rosterName: rosterName, studentNo: studentNo);
  }

  /// A4 의 동의 체크.
  void setConsent(bool value) => state = state.copyWith(consent: value);

  /// 초안을 비운다. 참여를 마쳤거나 흐름을 벗어날 때 부른다.
  void clear() => state = const JoinDraft();
}
