import 'package:beavertalk/core/config/app_version.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'support/i18n_data_screens.dart';

/// 설정 하단 버전 — 설치된 빌드를 읽는다.
///
/// QA F031(09-26): 빌드와 무관하게 「v1.0.0」 으로 박혀 있었다. 베타는 버전명이 내내 같아
/// 빌드 번호가 있어야 피드백을 빌드와 맞춰 볼 수 있다.
void main() {
  test('표기 — 버전명 + 빌드 번호, 번호가 비면 버전명만', () {
    expect(formatAppVersion('1.0.0', '43'), 'v1.0.0 (43)');
    expect(formatAppVersion('1.0.0', ''), 'v1.0.0');
  });

  testWidgets('설정 맨 아래에 설치된 빌드가 나온다', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'BeaverTalk',
      packageName: 'im.beavertalk.beavertalk',
      version: '1.0.0',
      buildNumber: '43',
      buildSignature: '',
    );
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: settingsDataHost(premium: true),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    expect(find.text('v1.0.0 (43)'), findsOneWidget);
    expect(find.text('v1.0.0'), findsNothing);
  });
}
