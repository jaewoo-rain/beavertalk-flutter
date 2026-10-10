import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/datasources/weak_sound_remote_data_source.dart';
import '../data/repositories/weak_sound_repository_impl.dart';
import '../domain/entities/sound_lesson.dart';
import '../domain/entities/weak_sound_item.dart';
import '../domain/repositories/weak_sound_repository.dart';

/// 데이터소스 — 설정된 [dioProvider] 에 묶는다.
final weakSoundRemoteDataSourceProvider =
    Provider<WeakSoundRemoteDataSource>((ref) {
  return WeakSoundRemoteDataSource(ref.watch(dioProvider));
});

/// 취약 발음 리포지토리(도메인 인터페이스).
final weakSoundRepositoryProvider = Provider<WeakSoundRepository>((ref) {
  return WeakSoundRepositoryImpl(
    remote: ref.watch(weakSoundRemoteDataSourceProvider),
  );
});

/// 취약 발음 목록.
///
/// 평가를 마치면 결과 화면이 `ref.invalidate(weakSoundListProvider)` 로 이걸 버린다 —
/// 목록으로 돌아갔을 때 62 가 84 로 바뀌어 있어야 하기 때문이다(Figma 18번).
final weakSoundListProvider = FutureProvider<WeakSoundList>((ref) {
  return ref.watch(weakSoundRepositoryProvider).list();
});

/// 소리 1개의 4단계 콘텐츠. `sound_key` 로 가족(family)을 가른다.
///
/// `autoDispose` 를 쓰지 않는다 — 학습 4단계가 화면을 갈아타며 같은 과를 계속 보기
/// 때문이다. autoDispose 면 단계 전환 중 구독이 0이 되는 순간 콘텐츠가 버려지고 다음
/// 화면에서 다시 받아 온다(자동진행이 네트워크를 기다리게 된다).
final soundLessonProvider =
    FutureProvider.family<SoundLesson, String>((ref, soundKey) {
  return ref.watch(weakSoundRepositoryProvider).lesson(soundKey);
});
