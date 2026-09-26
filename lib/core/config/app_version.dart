import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 설치된 빌드의 표기 — `v1.0.0 (41)`.
///
/// QA F031(09-26): 설정 하단이 빌드와 무관하게 `v1.0.0` 으로 박혀 있어, 베타 피드백을
/// 어느 빌드에서 겪었는지 화면만 보고는 가를 수 없었다. 버전명은 베타 내내 같으므로
/// 빌드 번호(`--build-number`)까지 붙인다.
///
/// 못 읽으면(시험 환경 등 플랫폼 채널 없음) null — 화면은 앱 이름만 그린다.
final appVersionLabelProvider = FutureProvider<String?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return formatAppVersion(info.version, info.buildNumber);
  } catch (e) {
    debugPrint('[app-version] 읽기 실패 → 표기 생략: $e');
    return null;
  }
});

/// `1.0.0` + `41` → `v1.0.0 (41)`. 빌드 번호가 비면 버전명만.
@visibleForTesting
String formatAppVersion(String version, String buildNumber) =>
    buildNumber.isEmpty ? 'v$version' : 'v$version ($buildNumber)';
