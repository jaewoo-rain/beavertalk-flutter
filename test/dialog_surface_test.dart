import 'package:beavertalk/components/organisms/dialog_basic.dart';
import 'package:beavertalk/components/organisms/dialog_confirm_icon.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 확인창 카드 면 — Light 에서 흰색이어야 한다.
///
/// 09-26 퇴행(통합 세션 실기기 · `e36222e`): Light `backgroundElevatedNormal` 을 Figma 값
/// #CBCCD3 으로 바꾸자, 그 토큰을 카드 면으로 쓰던 Dialog/Basic(통화 종료 확인창 등)이 진회색이
/// 됐다. 면은 `Background/Elevated/Dialog`(Light #FFFFFF · Dark #2F3340)다.
void main() {
  Future<Color?> surfaceOf(WidgetTester tester, Widget dialog, AppColorTokens tokens) async {
    // 새 키 — 같은 MaterialApp 에 테마만 바꾸면 AnimatedTheme 이 전환 첫 프레임을 그린다.
    await tester.pumpWidget(MaterialApp(
      key: UniqueKey(),
      theme: ThemeData(extensions: [tokens]),
      home: Scaffold(body: Center(child: dialog)),
    ));
    return tester
        .widget<Material>(find
            .ancestor(of: find.text('End this call?'), matching: find.byType(Material))
            .first)
        .color;
  }

  final basic = DialogBasic(
    title: 'End this call?',
    actions: [
      DialogAction(label: 'End call', onPressed: () {}),
      DialogAction(label: 'Keep talking', onPressed: () {}),
    ],
  );

  testWidgets('Dialog/Basic 면 — Light 흰색 · Dark #2F3340', (tester) async {
    expect(await surfaceOf(tester, basic, AppColorTokens.light), const Color(0xFFFFFFFF));
    expect(await surfaceOf(tester, basic, AppColorTokens.dark), const Color(0xFF2F3340));
  });

  testWidgets('Dialog/Confirm-Icon 도 같은 면', (tester) async {
    final confirm = DialogConfirmIcon(
      icon: const SizedBox(width: 48, height: 48),
      title: 'End this call?',
      actions: [DialogAction(label: 'OK', onPressed: () {})],
    );
    expect(await surfaceOf(tester, confirm, AppColorTokens.light),
        AppColorTokens.light.backgroundElevatedDialog);
  });
}
