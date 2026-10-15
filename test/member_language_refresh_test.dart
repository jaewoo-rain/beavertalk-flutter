// QA S3(2026-10-16) — 모국어를 바꾸면 홈 /cur/me·차시 목록을 다시 받는다(앱을 다시 켜기 전까지 이전 언어로 남던 결함).
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _CountingRepo implements NormalcallRepository {
  int me = 0;
  int lessons = 0;
  String translation = 'Hello';

  @override
  Future<CurMe> getCurMe() async {
    me++;
    return CurMe.fromJson({
      'lesson': {'no': 1, 'code': 'L1-S01-1', 'level_no': 1, 'situation': '인사하기', 'situation_translation': translation},
      'items_total': 1, 'items_drilled': 0, 'open': {'expression': true}, 'next_course': 'expression',
    });
  }

  @override
  Future<List<CurLessonRow>> getCurLessons({int? level}) async {
    lessons++;
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName}');
}

void main() {
  test('언어 저장 뒤 무효화하면 /cur/me·차시 목록을 새로 받아 새 언어 번역이 보인다', () async {
    final repo = _CountingRepo();
    final c = ProviderContainer(overrides: [normalcallRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(c.dispose);
    final subMe = c.listen(curMeProvider, (_, _) {});
    final subLessons = c.listen(curLessonsProvider(1), (_, _) {});
    addTearDown(subMe.close);
    addTearDown(subLessons.close);

    expect((await c.read(curMeProvider.future)).lesson.situationTranslation, 'Hello');
    await c.read(curLessonsProvider(1).future);
    expect((repo.me, repo.lessons), (1, 1));

    repo.translation = 'Xin chào';          // 서버 member.language 가 vi 로 바뀐 뒤의 응답
    expect((await c.read(curMeProvider.future)).lesson.situationTranslation, 'Hello',
        reason: '무효화 전에는 캐시 그대로(결함 재현)');

    invalidateMemberLanguageData(c.invalidate);
    expect((await c.read(curMeProvider.future)).lesson.situationTranslation, 'Xin chào');
    await c.read(curLessonsProvider(1).future);
    expect((repo.me, repo.lessons), (2, 2));
  });
}
