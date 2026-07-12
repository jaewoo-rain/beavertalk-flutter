package im.beavertalk.beavertalk

import android.app.Activity
import android.content.Context
import android.content.Intent
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
    private var projectionCallback: MediaProjection.Callback? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var recorder: MediaRecorder? = null
    private var outputPath: String? = null
    private var pendingStart: MethodChannel.Result? = null
    private var tearingDown = false

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
}
