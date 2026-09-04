// 참여 코드 화면 — **이미 그 반의 학습자면 이름·동의를 건너뛴다.**
//
// 서버 `join()` 은 이미 명단에 있으면 기존 행을 그대로 돌려준다. 그런데 앱은
// 그걸 모른 채 이름을 다시 물었고, 학습자는 「기존 이름을 덮어쓸까」를 스스로
// 판단해야 했다. 반 목록은 앱이 이미 갖고 있으므로 서버에 더 묻지 않는다.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/classroom/data/datasources/classroom_remote_data_source.dart';
import 'package:beavertalk/features/classroom/data/repositories/classroom_repository_impl.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/join_code.dart';

/// 경로마다 다른 본문을 준다 — 미리보기와 반 목록을 한 화면이 같이 쓴다.
class _RoutedAdapter implements HttpClientAdapter {
  _RoutedAdapter(this.bodies);

  final Map<String, Object?> bodies;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = bodies.keys.firstWhere(
      (k) => options.path.contains(k),
      orElse: () => '',
    );
    return ResponseBody.fromString(
      jsonEncode(bodies[key] ?? const <String, dynamic>{}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _preview = {
  'classroom_id': 1,
  'name': '가족센터 테스트방',
  'target_grade': 1,
  'learner_count': 1,
  'capacity': 30,
};

Future<List<String>> _run(WidgetTester tester, {required bool joined}) async {
  final dio = Dio(BaseOptions(baseUrl: 'https://b2b.test/api/v1'))
    ..httpClientAdapter = _RoutedAdapter({
      'preview': _preview,
      'classrooms/my': <Object>[],
    });
  final repo = ClassroomRepositoryImpl(ClassroomRemoteDataSource(dio));
  final pushed = <String>[];

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        classroomRepositoryProvider.overrideWithValue(repo),
        // ⚠ 반 목록은 provider 로 준다. `myClassroomsProvider` 는 B2B 주소가 없는
        //   빌드에서 빈 목록으로 끊는데(검사 하네스가 그 상태다) 그러면 이 화면의
        //   판단이 아니라 환경이 결과를 정하게 된다.
        myClassroomsProvider.overrideWith(
          (ref) async => joined
              ? const [JoinedClassroom(classroomId: 1, name: '가족센터 테스트방')]
              : const <JoinedClassroom>[],
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const JoinCodeScreen(initialCode: 'B5BY7H'),
        onGenerateRoute: (settings) {
          pushed.add(settings.name ?? '');
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(body: SizedBox.shrink()),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byType(Button).last, warnIfMissed: false);
  await tester.pumpAndSettle();
  return pushed;
}

void main() {
  testWidgets('이미 그 반의 학습자면 숙제 목록으로 바로 간다', (tester) async {
    final pushed = await _run(tester, joined: true);

    expect(pushed, contains(Routes.assignments));
    expect(pushed, isNot(contains(Routes.classroomJoinConfirm)));
  });

  testWidgets('처음 들어오는 반이면 참여 흐름을 그대로 탄다', (tester) async {
    final pushed = await _run(tester, joined: false);

    expect(pushed, contains(Routes.classroomJoinConfirm));
    expect(pushed, isNot(contains(Routes.assignments)));
  });
}
