package im.beavertalk.beavertalk

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.AudioAttributes
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Native gameplay screen recorder for the Pronunciation Challenge.
 *
 * Exposed to Dart via the `beavertalk/challenge_recorder` MethodChannel and
 * driven by `ChallengeRecorder`. Uses `MediaProjection` + a `MediaRecorder`
 * SURFACE video source to capture the composited screen (live camera texture +
 * game canvas) — the one path that captures external textures, which
 * `RenderRepaintBoundary.toImage()` cannot. Video only, by design: opening the
 * mic here would contend with the Vosk STT capture that drives the game.
 *
 * Works on API 26–33 without a foreground service. API 34+ additionally
 * requires a mediaProjection foreground service before `getMediaProjection`;
 * that path is not wired yet (TODO) — on 34+ `start` fails gracefully and the
 * game falls back to the score-card image share.
 */
class MainActivity : FlutterActivity() {
    private val channelName = "beavertalk/challenge_recorder"
    private val lockscreenChannelName = "beavertalk/lockscreen"

    /**
     * iOS 는 이 채널로 라우팅 제어(routeToSpeaker 등)를 받지만 Android 에는 핸들러가
     * 아예 없었다. barge-in 진행도 보고가 "어느 출력으로 나가던 중이었나"를 실어야
     * 해서 여기에 신설한다.
     *
     * ⚠ Android 에서는 `getAudioRoute` 하나만 구현한다. 기존 iOS 전용 메서드들
     * (routeToSpeaker / stopCallAudioRouting / isHeadsetConnected / logAudioState)은
     * Dart 쪽에서 `defaultTargetPlatform == iOS` 로 막혀 있어 여기로 오지 않는다.
     */
    private val audioChannelName = "beavertalk/audio"
    private val screenCaptureRequest = 0xB3A7

    /**
     * 이번 통화가 **잠긴 화면에서 수락된 것**인가.
     *
     * 켜져 있는 동안 이 액티비티는 키가드 **위에** 그려진다(비번 없이 통화). 통화가
     * 끝나면 반드시 내려야 한다 — 켜진 채로 두면 잠금화면에서 앱을 그냥 열 수 있다.
     */
    private var lockscreenCall = false

    private var projectionManager: MediaProjectionManager? = null
    private var projection: MediaProjection? = null
    private var projectionCallback: MediaProjection.Callback? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var recorder: MediaRecorder? = null
    private var outputPath: String? = null
    private var pendingStart: MethodChannel.Result? = null
    private var tearingDown = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyLockscreenCallMode(intent)
    }

    /**
     * 수락으로 이 액티비티가 다시 앞으로 올 때(기존 인스턴스 재사용)도 판정한다.
     *
     * 정상 경로는 대부분 이쪽이다: `launchMode=singleTop` + CLEAR_TOP|SINGLE_TOP 이라
     * 앱이 이미 살아 있으면 [onCreate] 가 아니라 여기로 들어온다.
     */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        applyLockscreenCallMode(intent)
    }

    /**
     * 통화 수락으로 뜬 것이고 화면이 잠겨 있으면 **키가드 위에** 그리도록 전환한다.
     *
     * 판정을 Dart 가 아니라 여기서 하는 이유: Flutter 엔진이 뜨고 채널이 연결될 때까지
     * 기다리면 그 사이 키가드가 한 번 깜빡이고 비번 화면이 보인다. 인텐트만 보면 되므로
     * 액티비티 진입 즉시 결정할 수 있다.
     *
     * `EXTRA_CALLKIT_CALL_DATA` 는 flutter_callkit_incoming 의 `AppUtils.getAppIntent`
     * 가 수락 시 넣어 주는 extra 다. 런처 아이콘으로 연 경우에는 없으므로, **통화로 열린
     * 경우에만** 이 모드가 켜진다.
     *
     * `requestDismissKeyguard()` 는 쓰지 않는다 — 그건 비번을 묻는 API 라 목적과 정반대다.
     */
    private fun applyLockscreenCallMode(intent: Intent?) {
        if (intent == null || !intent.hasExtra(EXTRA_CALLKIT_CALL_DATA)) return
        val keyguard = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager ?: return
        if (!keyguard.isKeyguardLocked) return

        lockscreenCall = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        // 통화 중 화면이 꺼지면 마이크가 끊길 수 있다(이 앱엔 포그라운드 서비스가 없다).
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    /**
     * 잠금화면 통화를 끝내고 잠금화면으로 돌려보낸다.
     *
     * 반환값 = "앱을 뒤로 보냈다". Dart 는 true 면 화면 전환을 하지 않는다.
     *
     * 종료 시점에 **다시** 잠금 여부를 본다. 통화 중에 사용자가 스스로 잠금을 풀었다면
     * 잠금화면으로 돌려보내는 건 엉뚱하므로, 모드만 해제하고 false 를 준다 — 그러면 Dart 가
     * 평소대로 통화 요약 화면으로 간다.
     *
     * `finishAndRemoveTask()` 대신 [moveTaskToBack] 을 쓴다. 태스크를 죽이면 다음 통화가
     * 콜드스타트가 되어 비버의 첫 마디가 그만큼 늦어진다. 앱은 살려 두고 뒤로만 보낸다.
     */
    private fun exitLockscreenCall(result: MethodChannel.Result) {
        if (!lockscreenCall) {
            result.success(false)
            return
        }
        lockscreenCall = false

        val keyguard = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        val stillLocked = keyguard?.isKeyguardLocked ?: false

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            @Suppress("DEPRECATION")
            window.clearFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        if (stillLocked) {
            moveTaskToBack(true)
        }
        result.success(stillLocked)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        projectionManager =
            getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "start" -> onStart(result)
                    "stop" -> onStop(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, lockscreenChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isLockscreenCall" -> result.success(lockscreenCall)
                    "exitIfLocked" -> exitLockscreenCall(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, audioChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAudioRoute" -> result.success(currentAudioRoute())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * 비버 오디오가 **지금 실제로 나가고 있는 출력**의 종류.
     *
     * 서버가 barge-in 측정을 해석할 때 쓴다 — 같은 결과라도 스피커폰이냐 이어폰이냐에
     * 따라 의미가 정반대가 된다(스피커폰은 에코 최악 조건, 이어폰은 음향 결합이 거의 없다).
     *
     * ⚠ **모르면 빈 문자열이다. "speaker" 로 떨어뜨리지 마라.** 서버가 "못 읽음"과
     *   "스피커였음"을 구분해야 하는데, 기본값을 speaker 로 두면 그 구분이 사라지고
     *   측정 못 한 기기가 전부 스피커폰 통계에 섞인다.
     */
    private fun currentAudioRoute(): String {
        val am = getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return ""
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // API 31+ 만 "이 속성으로 재생하면 어디로 나가는가"를 직접 답해준다.
                //
                // ⚠ 속성은 재생 트랙과 **같아야** 한다. flutter_pcm_sound 의 AudioTrack 이
                //   지금 USAGE_MEDIA/CONTENT_TYPE_MUSIC 이라 여기도 그렇게 묻는다. 통화
                //   경로(USAGE_VOICE_COMMUNICATION)로 물으면 라우팅이 달라질 수 있어
                //   (예: 미디어는 스피커, 통화는 리시버) 실제와 다른 답이 나온다.
                //   AEC 정비로 트랙 속성을 바꾸면 **여기도 같이 바꿔야 한다.**
                val attrs = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
                val type = am.getAudioDevicesForAttributes(attrs).firstOrNull()?.type
                if (type != null) return mapDeviceType(type)
            }
            // API 26~30 폴백: "지금 활성 라우트"를 직접 묻는 API 가 없어 우선순위로 좁힌다.
            // Android 라우팅 우선순위(SCO > A2DP > 유선 > 스피커)를 따른다.
            //
            // 마지막 분기가 추측이 아닌 이유: 헤드셋·BT 가 하나도 안 붙어 있고 스피커폰도
            // 꺼져 있으면 USAGE_MEDIA 오디오는 **내장 스피커로 간다**. 리시버로는 안 간다
            // (그건 통화 usage 의 경로다). 그래서 내장 스피커 존재만 확인해 speaker 로
            // 답하고, 없으면 빈 문자열로 떨어진다.
            @Suppress("DEPRECATION")
            return when {
                am.isBluetoothScoOn || am.isBluetoothA2dpOn || am.isWiredHeadsetOn -> "headset"
                am.isSpeakerphoneOn -> "speaker"
                else -> hasOutput(am, AudioDeviceInfo.TYPE_BUILTIN_SPEAKER)
            }
        } catch (_: Throwable) {
            // 진단이 통화를 죽이면 안 된다. 모르면 모른다고 답한다.
            return ""
        }
    }

    private fun hasOutput(am: AudioManager, type: Int): String {
        val found = am.getDevices(AudioManager.GET_DEVICES_OUTPUTS).any { it.type == type }
        return if (found) mapDeviceType(type) else ""
    }

    /**
     * AudioDeviceInfo 타입 → 서버 계약 문자열. **speaker / headset 두 값만** 낸다.
     *
     * 서버는 이 값을 분류표가 아니라 **그룹 키**로 쓴다 — "이 라우트에서 hal_drained 가
     * 한 번이라도 나왔나", "라우트가 바뀌었는데도 계속 0건인가" 를 보는 용도다. 그래서
     * 요구되는 성질은 정확한 분류명이 아니라 **같은 라우트엔 항상 같은 문자열**이다.
     * 세분화하면 오히려 해롭다: 같은 헤드셋이 SCO 를 물었다 놨다 하면서 두 키로 쪼개지면
     * "라우트가 바뀌었다"는 신호가 희석된다.
     *
     * ⚠ 모르는 타입은 빈 문자열이다. speaker 로 떨어뜨리면 서버가 "못 읽음"과
     *   "스피커였음"을 구분하지 못해, 못 읽은 기기가 전부 스피커폰 통계에 섞인다.
     *
     * ⚠ 리시버(귀에 대는 통화 스피커)는 **"receiver" 라는 제3의 값**이다. 스피커폰도
     *   헤드셋도 아니고(음향 결합이 스피커폰보다 훨씬 약하다), 그렇다고 빈 문자열도 아니다.
     *   빈 문자열은 서버가 "라우트 불명"으로 읽어 판정을 보류하고 "이어폰을 꽂았다 빼며
     *   재측정하라"는 처방을 낸다 — 우리가 **아는데** 모른다고 하면 측정하는 사람이
     *   헛수고한다. "모르면 빈 문자열"은 *추측으로 채우지 마라*는 뜻이지 *아는 것도
     *   숨겨라*가 아니다. 서버는 라우트를 그룹 키로만 쓰므로 새 값이 들어와도 동작한다.
     *   우리 재생은 USAGE_MEDIA 라 안드로이드에서는 리시버로 안 가지만, iOS 에서
     *   defaultToSpeaker 가 안 먹으면 나올 수 있다.
     *
     * 블루투스 A2DP/HFP 구분은 **일부러 하지 않는다**(나중 단계). 다만 그때 필요해진다 —
     * A2DP 는 출력만 블루투스이고 마이크는 폰 본체라 스피커폰과 같은 결합이 생기는데,
     * HFP 는 마이크도 헤드셋이라 결합이 없다. "블루투스 = 안전"이 아니다.
     */
    private fun mapDeviceType(type: Int): String = when (type) {
        AudioDeviceInfo.TYPE_BUILTIN_SPEAKER -> "speaker"
        AudioDeviceInfo.TYPE_BUILTIN_EARPIECE -> "receiver"
        AudioDeviceInfo.TYPE_WIRED_HEADSET,
        AudioDeviceInfo.TYPE_WIRED_HEADPHONES,
        AudioDeviceInfo.TYPE_BLUETOOTH_A2DP,
        AudioDeviceInfo.TYPE_BLUETOOTH_SCO,
        AudioDeviceInfo.TYPE_USB_HEADSET,
        AudioDeviceInfo.TYPE_USB_DEVICE,
        AudioDeviceInfo.TYPE_USB_ACCESSORY -> "headset"
        else -> ""
    }

    private fun onStart(result: MethodChannel.Result) {
        // API 34+ needs a mediaProjection foreground service first; not wired.
        if (Build.VERSION.SDK_INT >= 34) {
            result.success(false)
            return
        }
        if (recorder != null) {
            result.success(false)
            return
        }
        if (pendingStart != null) {
            // A consent dialog is already in flight; don't overwrite its
            // Result (would hang the first Dart await) or launch a second
            // consent Intent.
            result.success(false)
            return
        }
        val manager = projectionManager
        if (manager == null) {
            result.success(false)
            return
        }
        pendingStart = result
        startActivityForResult(manager.createScreenCaptureIntent(), screenCaptureRequest)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != screenCaptureRequest) return
        val pending = pendingStart
        pendingStart = null
        if (resultCode != Activity.RESULT_OK || data == null || pending == null) {
            pending?.success(false)
            return
        }
        val ok = try {
            beginRecording(resultCode, data)
        } catch (e: Exception) {
            teardown()
            false
        }
        pending.success(ok)
    }

    private fun beginRecording(resultCode: Int, data: Intent): Boolean {
        val manager = projectionManager ?: return false
        val metrics = DisplayMetrics().also { windowManager.defaultDisplay.getRealMetrics(it) }
        // Cap the long edge so the encoder stays within common H.264 limits and
        // keep both dimensions even.
        val longEdge = maxOf(metrics.widthPixels, metrics.heightPixels)
        val scale = if (longEdge > 1280) 1280.0 / longEdge else 1.0
        val width = (metrics.widthPixels * scale).toInt() and 0xFFFFFFFE.toInt()
        val height = (metrics.heightPixels * scale).toInt() and 0xFFFFFFFE.toInt()

        val file = File(cacheDir, "beavertalk_challenge.mp4")
        outputPath = file.absolutePath

        val rec = if (Build.VERSION.SDK_INT >= 31) {
            MediaRecorder(this)
        } else {
            @Suppress("DEPRECATION") MediaRecorder()
        }
        // Assign to the field immediately after each resource is created so
        // teardown()/the outer catch in onActivityResult can always release
        // whatever was allocated so far, even if a later step returns early
        // or throws.
        recorder = rec
        rec.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        rec.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        rec.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        rec.setVideoSize(width, height)
        rec.setVideoFrameRate(30)
        rec.setVideoEncodingBitRate(6_000_000)
        rec.setOutputFile(file.absolutePath)
        rec.prepare()

        val proj = manager.getMediaProjection(resultCode, data)
        if (proj == null) {
            // rec was already prepared (encoder allocated) — release it.
            teardown()
            return false
        }
        projection = proj
        val callback = object : MediaProjection.Callback() {
            override fun onStop() {
                teardown()
            }
        }
        proj.registerCallback(callback, null)
        projectionCallback = callback
        val vd = proj.createVirtualDisplay(
            "beavertalk_challenge",
            width, height, metrics.densityDpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            rec.surface, null, null,
        )
        virtualDisplay = vd
        rec.start()
        return true
    }

    private fun onStop(result: MethodChannel.Result) {
        val path = outputPath
        val hadRecorder = recorder != null
        try {
            recorder?.stop()
        } catch (_: Exception) {
        }
        teardown()
        // A truncated/near-empty MP4 (e.g. because stop() threw right after
        // start()) still passes File.exists() — also require a minimal size.
        val file = path?.let { File(it) }
        val minSizeBytes = 4_096L
        val ok = hadRecorder && file != null && file.exists() && file.length() > minSizeBytes
        result.success(if (ok) path else null)
    }

    private fun teardown() {
        // projection.stop() re-invokes the registered Callback's onStop(),
        // which calls back into teardown() re-entrantly; guard against that
        // and unregister the callback before stopping the projection.
        if (tearingDown) return
        tearingDown = true
        try {
            val proj = projection
            val cb = projectionCallback
            if (proj != null && cb != null) proj.unregisterCallback(cb)
        } catch (_: Exception) {}
        try { recorder?.reset() } catch (_: Exception) {}
        try { recorder?.release() } catch (_: Exception) {}
        try { virtualDisplay?.release() } catch (_: Exception) {}
        try { projection?.stop() } catch (_: Exception) {}
        recorder = null
        virtualDisplay = null
        projection = null
        projectionCallback = null
        tearingDown = false
    }

    private companion object {
        /**
         * flutter_callkit_incoming 이 수락 시 앱 인텐트에 넣는 extra 키
         * (`AppUtils.getAppIntent` → `FlutterCallkitIncomingPlugin.EXTRA_CALLKIT_CALL_DATA`).
         * 플러그인 상수를 직접 참조하지 않고 값을 복사한다 — 앱이 플러그인 내부 API 에
         * 컴파일 의존하지 않게 하기 위함이다. 플러그인 업데이트로 이 키가 바뀌면 잠금화면
         * 통화 모드가 조용히 꺼진다(비번을 다시 묻게 된다).
         */
        const val EXTRA_CALLKIT_CALL_DATA = "EXTRA_CALLKIT_CALL_DATA"
    }
}
