import 'package:flutter/material.dart';

import '../../../components/molecules/empty_state.dart';

/// 학습 화면들이 `sound_key` 를 받는 방법 — 생성자 주입 우선, 없으면 라우트 인자.
///
/// 라우트 테이블이 `WidgetBuilder`(인자 없음)라 화면이 직접 `settings.arguments` 를
/// 읽는 것이 이 앱의 관례다(`assignment_detail.dart` · `join_code.dart` 와 같은 방식).
/// 테스트·갤러리에서는 생성자로 바로 넣는다.
///
/// 키가 없으면 빈 문자열이 아니라 **null** 을 돌려준다. 빈 문자열로 내려가면 서버에
/// `/weak-sounds//lesson` 을 때리고 404 가 「없는 소리」처럼 보인다 — 실제로는 앱이
/// 인자를 못 받은 것이다.
String? resolveSoundKey(BuildContext context, String? injected) {
  if (injected != null && injected.isNotEmpty) return injected;
  final arg = ModalRoute.of(context)?.settings.arguments;
  if (arg is String && arg.isNotEmpty) return arg;
  return null;
}

/// `sound_key` 없이 열린 학습 화면 — 라우팅 실수의 표지.
///
/// 흰 화면이나 404 로 내려앉지 않고 **무엇이 잘못됐는지** 보인다. 사용자에게는 돌아갈
/// 길을, 개발자에게는 원인을 준다.
class MissingSoundKey extends StatelessWidget {
  const MissingSoundKey({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: EmptyBlock(
              title: '학습할 소리를 찾지 못했어요',
              body: '목록에서 다시 선택해 주세요.',
              ctaText: '목록으로',
              onCta: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      );
}
