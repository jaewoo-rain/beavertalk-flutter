package im.beavertalk.beavertalk

import android.app.Activity
import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.util.DisplayMetrics
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
    private val screenCaptureRequest = 0xB3A7

    private var projectionManager: MediaProjectionManager? = null
    private var projection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var recorder: MediaRecorder? = null
    private var outputPath: String? = null
    private var pendingStart: MethodChannel.Result? = null

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
        // Background alarm scheduling (fires even when the app is killed).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "beavertalk/alarm_scheduler")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "syncAlarms" -> {
                        AlarmReceiver.syncAlarms(this, call.argument<String>("alarms") ?: "[]")
                        result.success(true)
                    }
                    "canScheduleExact" -> {
                        val am = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        result.success(Build.VERSION.SDK_INT < 31 || am.canScheduleExactAlarms())
                    }
                    "requestExactPermission" -> {
                        if (Build.VERSION.SDK_INT >= 31) {
                            try {
                                startActivity(
                                    Intent(
                                        Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                                        Uri.parse("package:$packageName"),
                                    ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                                )
                            } catch (_: Exception) {}
                        }
                        result.success(true)
                    }
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
        rec.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        rec.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        rec.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        rec.setVideoSize(width, height)
        rec.setVideoFrameRate(30)
        rec.setVideoEncodingBitRate(6_000_000)
        rec.setOutputFile(file.absolutePath)
        rec.prepare()

        val proj = manager.getMediaProjection(resultCode, data) ?: return false
        proj.registerCallback(object : MediaProjection.Callback() {
            override fun onStop() {
                teardown()
            }
        }, null)
        val vd = proj.createVirtualDisplay(
            "beavertalk_challenge",
            width, height, metrics.densityDpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            rec.surface, null, null,
        )
        rec.start()
        projection = proj
        virtualDisplay = vd
        recorder = rec
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
        result.success(if (hadRecorder && path != null && File(path).exists()) path else null)
    }

    private fun teardown() {
        try { recorder?.reset() } catch (_: Exception) {}
        try { recorder?.release() } catch (_: Exception) {}
        try { virtualDisplay?.release() } catch (_: Exception) {}
        try { projection?.stop() } catch (_: Exception) {}
        recorder = null
        virtualDisplay = null
        projection = null
    }
}
