import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/report/domain/entities/report_reason.dart';
import 'package:beavertalk/features/report/domain/repositories/report_repository.dart';
import 'package:beavertalk/features/report/presentation/report_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/report/report_content.dart';

/// 제출을 가로채는 가짜 리포지토리. [fail] 이면 [AppException] 을 던진다.
class _FakeReportRepository implements ReportRepository {
  _FakeReportRepository({this.fail = false});

  final bool fail;

  /// 마지막으로 접수된 인자 — 화면이 무엇을 넘겼는지 검사한다.
  ({ReportReason reason, ReportSource source, int? callId, String? detail})?
      last;

  @override
  Future<void> submit({
    required ReportReason reason,
    required ReportSource source,
    int? callId,
    String? detail,
  }) async {
    last = (reason: reason, source: source, callId: callId, detail: detail);
    if (fail) throw const ServerFailure();
  }
}

Widget _app(_FakeReportRepository repo, {ReportArgs? args}) {
  return ProviderScope(
    overrides: [reportRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ReportContentScreen(args: args),
    ),
  );
}

/// 사유를 고른다.
///
/// 사유가 6개라 좁은 화면에서는 아래쪽이 접힌다(실기기에서도 스크롤한다).
/// [WidgetTester.tap] 은 화면 밖 좌표를 그냥 빗나가고 경고만 남기므로 —
/// 그래서 이 테스트가 처음에 "사유를 안 골랐다"는 엉뚱한 실패로 나왔다 —
/// 먼저 보이는 위치까지 스크롤한다.
Future<void> _pickReason(WidgetTester tester, String label) async {
  final finder = find.text(label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  // 코드값은 DB(`public.content_report`)에 그대로 저장된다. 이름을 바꾸면 이미
  // 저장된 신고와 대조가 깨지므로 상수로 고정해 둔다.
  test('신고 사유·출처 코드는 DB 계약이라 바뀌면 안 된다', () {
    expect(
      ReportReason.values.map((r) => r.code).toList(),
      ['sexual', 'hate', 'violence', 'self_harm', 'misinformation', 'other'],
    );
    expect(
      ReportSource.values.map((s) => s.code).toList(),
      ['call_finish', 'record_list'],
    );
  });

  testWidgets('사유를 고르기 전에는 접수 버튼이 눌리지 않는다', (tester) async {
    final repo = _FakeReportRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    expect(repo.last, isNull, reason: '사유 없이 접수되면 안 된다');
  });

  testWidgets('사유를 고르고 접수하면 인자가 그대로 넘어가고 완료 안내가 뜬다',
      (tester) async {
    final repo = _FakeReportRepository();
    await tester.pumpWidget(
      _app(repo, args: (callId: 42, source: ReportSource.callFinish)),
    );
    await tester.pumpAndSettle();

    await _pickReason(tester, 'Hate or discrimination');
    await tester.enterText(find.byType(TextField), '캐릭터가 차별 발언을 했어요');
    await tester.pump();

    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    expect(repo.last?.reason, ReportReason.hate);
    expect(repo.last?.source, ReportSource.callFinish);
    expect(repo.last?.callId, 42, reason: '통화 id 가 붙어야 검토가 가능하다');
    expect(repo.last?.detail, '캐릭터가 차별 발언을 했어요');

    // 접수는 앱 안에서 끝난다 — 외부 앱으로 나가지 않고 같은 화면이 완료로 바뀐다.
    expect(find.text('Your report has been received'), findsOneWidget);
    expect(find.text('Submit report'), findsNothing);
  });

  testWidgets('기록 목록에서 들어오면 통화 id 없이 접수된다', (tester) async {
    final repo = _FakeReportRepository();
    await tester.pumpWidget(
      _app(repo, args: (callId: null, source: ReportSource.recordList)),
    );
    await tester.pumpAndSettle();

    await _pickReason(tester, 'Something else');
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    expect(repo.last?.source, ReportSource.recordList);
    expect(repo.last?.callId, isNull);
  });

  testWidgets('접수에 실패하면 화면을 유지하고 입력을 지우지 않는다', (tester) async {
    final repo = _FakeReportRepository(fail: true);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await _pickReason(tester, 'False information');
    await tester.enterText(find.byType(TextField), '사실과 다른 말을 했어요');
    await tester.pump();
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    // 완료로 넘어가지 않는다.
    expect(find.text('Your report has been received'), findsNothing);
    // 사용자가 쓴 내용이 남아 있어야 다시 시도할 수 있다.
    expect(find.text('사실과 다른 말을 했어요'), findsOneWidget);
    // 폴백 문구는 하드코딩 한국어라, 서버가 쓴 게 아니면 로케일 문구를 쓴다.
    expect(
      find.text("Couldn't submit your report. Please try again."),
      findsOneWidget,
    );
  });
}
