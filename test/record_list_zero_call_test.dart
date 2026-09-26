import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/record/record_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 기록 목록 — 0초 통화는 올리지 않는다.
///
/// QA F048(09-26 · PM-DEC-030): 「대화 기록 · 0분 0초」 카드가 일반 통화와 같은 모양으로 올라왔고,
/// 열면 전부 「-%」 인 빈 분석이었다.
CallSummary _call(int id, int? seconds, String summary) => CallSummary(
      callId: id,
      character: const CallCharacterBrief(characterId: 10, name: 'Rara'),
      callDate: DateTime(2026, 9, 26, 21, 40),
      totalTime: seconds,
      summary: summary,
    );

class _List extends CallListNotifier {
  _List(this._items);
  final List<CallSummary> _items;

  @override
  Future<CallListState> build() async => CallListState(items: _items, hasMore: false);
}

void main() {
  test('0초만 뺀다 — 길이를 모르면(null) 남긴다', () {
    expect(isListedCall(_call(1, 0, '')), isFalse);
    expect(isListedCall(_call(2, 10, '')), isTrue);
    expect(isListedCall(_call(3, null, '')), isTrue);
  });

  Future<void> pump(WidgetTester tester, List<CallSummary> items) async {
    tester.view.physicalSize = const Size(360, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [callListProvider.overrideWith(() => _List(items))],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const RecordListScreen(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
  }

  testWidgets('0초 통화 카드는 목록에 없다', (tester) async {
    await pump(tester, [_call(1, 82, 'Weekend chat'), _call(2, 0, 'Empty call')]);
    expect(find.text('Weekend chat'), findsOneWidget);
    expect(find.text('Empty call'), findsNothing);
  });

  testWidgets('0초 통화뿐이면 빈 상태', (tester) async {
    await pump(tester, [_call(2, 0, 'Empty call')]);
    expect(find.text('Empty call'), findsNothing);
    expect(find.text('No call records yet'), findsOneWidget);
  });
}
