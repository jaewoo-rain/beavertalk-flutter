// 마이페이지 「내 반」 카드 — 반 소속이 바뀔 때 카드가 따라오는지 본다.
//
// 🔴 2026-09-04 실측 사고. 나가기가 과제 캐시만 버려서, 서버에서는 이미 나갔는데
//    (`left_at` 기록됨) 카드가 반 목록의 옛 값을 들고 **반 이름을 계속 보여줬다.**
//    눌러 들어가면 숙제만 사라져 있었다 — 「나갔는데 안 나가진」 화면이다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/widgets/homework_class_card.dart';

const _room = JoinedClassroom(classroomId: 1, name: '가족센터 테스트방');

/// 서버가 들고 있는 상태. 테스트가 이 값을 바꾸고 무효화를 태운다.
List<JoinedClassroom> _rooms = const [_room];
List<ClassroomAssignment> _items = const [];

Widget _host(void Function(WidgetRef) capture) {
  return ProviderScope(
    overrides: [
      myClassroomsProvider.overrideWith((ref) async => _rooms),
      myAssignmentsProvider.overrideWith((ref) async => _items),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Consumer(
          builder: (ctx, ref, _) {
            capture(ref);
            return const HomeworkClassCard();
          },
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    _rooms = const [_room];
    _items = const [];
  });

  testWidgets('반에 있으면 반 이름을 보여준다', (tester) async {
    await tester.pumpWidget(_host((_) {}));
    await tester.pumpAndSettle();

    expect(find.text('가족센터 테스트방'), findsOneWidget);
  });

  testWidgets('나가면 참여 코드 입력으로 돌아간다', (tester) async {
    late WidgetRef captured;
    await tester.pumpWidget(_host((ref) => captured = ref));
    await tester.pumpAndSettle();
    expect(find.text('가족센터 테스트방'), findsOneWidget);

    // 서버에서 나갔다. 화면은 두 축을 같이 버려야 한다.
    _rooms = const [];
    _items = const [];
    invalidateClassroomMembership(captured);
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text('가족센터 테스트방'), findsNothing);
    expect(find.text(l10n.hwClassEmptyTitle), findsOneWidget);
    expect(find.text(l10n.hwClassEmptyCta), findsOneWidget);
  });

  testWidgets('과제 캐시만 버리면 반 이름이 남는다 — 이것이 그 사고다', (tester) async {
    late WidgetRef captured;
    await tester.pumpWidget(_host((ref) => captured = ref));
    await tester.pumpAndSettle();

    _rooms = const [];
    _items = const [];
    captured.invalidate(myAssignmentsProvider); // ⛔ 하나만 버린다
    await tester.pumpAndSettle();

    // 반 이름이 그대로다. `invalidateClassroomMembership` 이 필요한 이유의 증거다.
    expect(find.text('가족센터 테스트방'), findsOneWidget);
  });
}
