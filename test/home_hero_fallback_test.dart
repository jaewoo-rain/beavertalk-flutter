import 'dart:async';

import 'package:beavertalk/components/atoms/skeleton.dart';
import 'package:beavertalk/components/molecules/hero_avatar.dart';
import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 홈 히어로(아바타 · 이름) — 캐릭터를 못 정하면 셔머로 영영 남지 않는다.
///
/// QA F009(09-26): 카탈로그 조회 실패 · 대표 캐릭터 id 없음 · 카탈로그에 없는 id 가 전부
/// 「로딩 중」으로 읽혀 셔머가 끝나지 않았다. 카탈로그 provider 는 autoDispose 가 아니라
/// 오류가 캐시되고, 홈에는 다시 부를 길이 없었다(앱 재시작 필요).
Member _member({int? characterId = 10}) => Member(
      memberId: 1,
      email: 'qa@example.com',
      name: 'QA',
      language: 'en',
      targetLanguage: 'ko',
      characterId: characterId,
      onboardingCompleted: true,
      createdAt: DateTime(2026, 3, 1),
    );

const _rara = Character(
  id: 10,
  productKey: 'rara',
  name: 'Rara',
  price: 1199,
  effectivePrice: 1199,
  isOwned: true,
  isUnlocked: true,
);

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required FutureOr<List<Character>> Function() catalog,
    Member? member,
  }) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        charactersProvider.overrideWith((ref) async => catalog()),
        myProfileProvider.overrideWith((ref) async => member ?? _member()),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
  }

  Finder avatarSkeleton() => find.byWidgetPredicate(
      (w) => w is SkeletonShimmer && w.child is Skeleton);

  testWidgets('카탈로그를 기다리는 동안은 셔머', (tester) async {
    await pump(tester, catalog: () => Completer<List<Character>>().future);
    expect(avatarSkeleton(), findsOneWidget);
    expect(find.byType(HeroAvatar), findsNothing);
  });

  testWidgets('카탈로그 조회 실패 — 기본 아바타 · 이름 없음', (tester) async {
    await pump(tester, catalog: () => throw const NetworkFailure());
    expect(avatarSkeleton(), findsNothing);
    expect(find.byType(HeroAvatar), findsOneWidget);
    expect(find.text('Rara'), findsNothing);
  });

  testWidgets('대표 캐릭터 id 가 카탈로그에 없음 — 기본 아바타', (tester) async {
    await pump(tester, catalog: () => const [_rara], member: _member(characterId: 99));
    expect(avatarSkeleton(), findsNothing);
    expect(find.byType(HeroAvatar), findsOneWidget);
  });

  // QA F019(09-26 · PM-DEC-026): 왼쪽 탭은 알람 목록을 연다 — 달력 아이콘 · 「Calendar」 가
  // 학습 달력(상단 칩)과 헷갈렸다. 오른쪽은 기록 목록인데 이름이 「Stats」 였다.
  testWidgets('하단 탭 접근성 이름 — 알람 · 통화 · 기록', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, catalog: () => const [_rara]);
    expect(find.bySemanticsLabel('Alarms'), findsOneWidget);
    expect(find.bySemanticsLabel('Records'), findsOneWidget);
    expect(find.bySemanticsLabel('Calendar'), findsNothing);
    expect(find.bySemanticsLabel('Stats'), findsNothing);
    handle.dispose();
  });

  testWidgets('대표 캐릭터가 있으면 그 이름', (tester) async {
    await pump(tester, catalog: () => const [_rara]);
    expect(find.byType(HeroAvatar), findsOneWidget);
    expect(find.text('Rara'), findsOneWidget);
  });
}
