import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/home_mode.dart';

/// 홈 모드(학습·대화) — 헤더 토글이 바꾼다. 앱을 켜 둔 동안만 기억한다.
///
/// 로그아웃 때 지운다(`userScopedProviders`) — 다음 회원은 학습 모드로 시작한다.
final homeModeProvider = StateProvider<HomeMode>((_) => HomeMode.learn);
