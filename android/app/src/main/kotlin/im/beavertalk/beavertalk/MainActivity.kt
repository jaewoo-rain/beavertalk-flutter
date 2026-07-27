package im.beavertalk.beavertalk

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
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
