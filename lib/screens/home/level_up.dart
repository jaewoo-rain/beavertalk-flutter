import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 레벨업 축하 — Figma `screen/level_up` Mobile `6410:42174` · Tablet `6410:42233`
/// (09-25 사장님 확정 「V1 · 축포」, app designer 세션 · 시안 기록 Workspace `6409:4268`).
///
/// 전체 화면 페이지(창이 아니다). 구조는 [OnboardingDoneScreen] 과 같다:
/// ```
/// (가운데 정렬 · 간격 28)
///   [그림 320×236 — 별 셋 · 리본 「LEVEL UP」 · 색종이]
///   종합 레벨        ← overallLevel 16 Bold Primary/Heavy
///   (4)
///   N단계            ← levelStage 40 Bold Label/Strong
/// [          확인          ]  ← confirm primary_fill 60
/// ```
/// - 태블릿(콘텐츠 폭 600)은 그림 ×1.35(432×319) · 글자 20 · 48.
/// - 새 번역 키가 없다. 리본 「LEVEL UP」 은 그림(윤곽선)이라 번역하지 않는다.
/// - 그림 색은 Atomic 고정값이라 라이트 · 다크가 같다. 정지 화면(애니메이션 없음).
/// - 시스템 뒤로도 「확인」과 같다 — 이 페이지는 분석 화면으로 가는 길목이다.
class LevelUpScreen extends StatelessWidget {
  /// Creates the level-up page.
  const LevelUpScreen({super.key, required this.level, required this.onConfirm});

  /// 새 레벨(단계).
  final int level;

  /// 「확인」 — 대화 분석 화면으로.
  final VoidCallback onConfirm;

  static const _art = 'assets/images/level_up.svg';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onConfirm();
      },
      child: AppScaffold(
        background: c.backgroundNormalNormal,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, box) {
                // 태블릿 = 콘텐츠가 캡(600)에 닿는 폭. 기기를 묻지 않고 가용 폭을 본다(adaptive.dart).
                final wide = box.maxWidth >= AppLayout.content + 2 * AppLayout.gutter;
                final scale = wide ? 1.35 : 1.0;
                return ContentColumn.narrow(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(_art, width: 320 * scale, height: 236 * scale),
                          const SizedBox(height: 28),
                          Text(
                            l10n.overallLevel,
                            textAlign: TextAlign.center,
                            style: (wide ? AppType.heading2 : AppType.body1)
                                .b
                                .copyWith(color: c.primaryHeavy),
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            l10n.levelStage(level),
                            textAlign: TextAlign.center,
                            // 40 · 48 Bold — 앱 타이포에 없는 크기라 Title 1 을 Figma 크기로 늘린다.
                            style: AppType.title1.b.copyWith(
                              fontSize: wide ? 48 : 40,
                              height: 1.3,
                              color: c.labelStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.confirm,
                onPressed: onConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 레벨이 올랐나 — 기기에 남긴 「마지막으로 본 레벨」과 서버 레벨을 비교한다(서버 변경 없이).
///
/// 서버는 프리토킹 통화가 끝나 다음 차시로 넘어갈 때 레벨을 올린다(통화로는 내려가지 않는다).
/// 통화 뒤 대화 분석으로 가는 길목에서 한 번 묻는다.
/// - 기준이 없으면(첫 확인) 지금 레벨을 기준으로 남기고 축하하지 않는다 — 원래 레벨을
///   「올랐다」고 하지 않는다.
/// - 내려갔으면(재측정) 기준만 낮춘다.
/// - 못 물어보면(네트워크 · 레벨 없음) 축하하지 않고 기준도 그대로 둔다 — 분석을 막지 않는다.
/// - 기준은 회원별로 둔다(한 기기 여러 계정).
abstract final class LevelUpCheck {
  static String _key(int memberId) => 'level_up.last_seen.$memberId';

  /// 새로 오른 레벨, 아니면 null. 기준을 갱신한다.
  static Future<int?> newLevel(AuthRepository repo, {required int memberId}) async {
    try {
      final level = (await repo.getMyLevel().timeout(const Duration(seconds: 3))).level;
      if (level == null) return null;
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(_key(memberId));
      await prefs.setInt(_key(memberId), level);
      if (last == null) return null;
      return level > last ? level : null;
    } catch (_) {
      return null;
    }
  }
}
