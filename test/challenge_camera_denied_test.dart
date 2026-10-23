import 'package:beavertalk/features/pronunciation_challenge/data/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:beavertalk/features/pronunciation_challenge/presentation/pronunciation_challenge_screen.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// 권한을 거부하는 카메라 플랫폼 — 몇 번 물었는지 센다.
class _DenyingCamera extends CameraPlatform with MockPlatformInterfaceMixin {
  int asked = 0;

  @override
  Future<List<CameraDescription>> availableCameras() async => const [
        CameraDescription(name: 'front', lensDirection: CameraLensDirection.front, sensorOrientation: 0),
      ];

  @override
  Future<int> createCameraWithSettings(CameraDescription d, MediaSettings s) async {
    asked++;
    throw CameraException('CameraAccessDenied', 'denied');
  }

  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() => const Stream.empty();

  @override
  Future<int> createCamera(CameraDescription d, ResolutionPreset? r, {bool enableAudio = false}) async {
    asked++;
    throw CameraException('CameraAccessDenied', 'denied');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PM-DEC-1036 — camera permission denied is remembered: no second prompt in this screen', () async {
    final fake = _DenyingCamera();
    CameraPlatform.instance = fake;
    final cam = ChallengeCameraService();
    expect(await cam.init(), isFalse);
    expect(cam.permissionDenied, isTrue);
    expect(cam.status.value, CameraStatus.unavailable);
    final askedOnce = fake.asked;
    expect(await cam.init(), isFalse); // 복귀 때 다시 불러도
    expect(fake.asked, askedOnce); // 권한 창을 다시 띄우지 않는다
    expect(cam.initInFlight, isFalse);
    await cam.dispose();
  });

  testWidgets('PM-DEC-1036 — after a denial, app pause/resume (permission sheet) does not re-ask the camera', (tester) async {
    final fake = _DenyingCamera();
    CameraPlatform.instance = fake;
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PronunciationChallengeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 50));
    final askedAfterStart = fake.asked;
    expect(askedAfterStart, greaterThanOrEqualTo(1));
    for (var i = 0; i < 3; i++) {
      // 권한 창이 뜨고 닫힐 때마다 앱이 비활성 → 복귀한다(빌드 93: 그때마다 다시 물어 창이 안 닫혔다).
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(fake.asked, askedAfterStart);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  });
}
