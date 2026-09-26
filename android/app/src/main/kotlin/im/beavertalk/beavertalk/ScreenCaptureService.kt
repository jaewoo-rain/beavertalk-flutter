package im.beavertalk.beavertalk

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder

/**
 * mediaProjection 형식의 포그라운드 서비스.
 *
 * Android 10(API 29)부터 `MediaProjectionManager.getMediaProjection()` 은
 * **이 형식의 포그라운드 서비스가 이미 떠 있을 때만** 허용된다(targetSdk ≥ Q ·
 * android10-release `MediaProjectionManagerService.requiresForegroundService()`).
 * 없으면 SecurityException("Media projections require a foreground service of type
 * ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION") 이 난다. 이 서비스가
 * 없어서 발음 챌린지가 내놓는 산출물인 클립이 안 나왔다.
 *
 * ⚠ 한때 이 서비스를 API 34+ 에서만 띄웠다 — Android 10~13 기기(Note20 = API 29)에서
 *   예외가 나 결과 화면에 녹화 카드가 안 떴다(QA F056 · Play 수정요청 A3, 09-26 → 29 로 정정).
 *
 * 서비스 자체는 아무 일도 하지 않는다 — 캡처는 액티비티가 쥔 `MediaProjection`
 * 이 한다. 이 서비스의 존재 이유는 **권한 상태를 만드는 것**뿐이다. 그래서
 * 녹화가 끝나면 바로 내린다([MainActivity.teardown]).
 *
 * ## 시작 완료를 왜 콜백으로 알리는가
 * `startForegroundService()` 는 비동기다. 곧바로 `getMediaProjection()` 을
 * 부르면 서비스가 아직 `startForeground()` 를 못 부른 상태라 같은 예외가 난다.
 * [onForeground] 는 `startForeground()` 직후에 호출되며, `onStartCommand` 가
 * 메인 스레드에서 도는 덕에 액티비티 쪽 이어받기도 메인 스레드에서 일어난다.
 */
class ScreenCaptureService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        ensureChannel()
        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle(TITLE)
            .setContentText(TEXT)
            .setSmallIcon(applicationInfo.icon)
            .setOngoing(true)
            .build()
        try {
            if (Build.VERSION.SDK_INT >= 29) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION,
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            // 알림 권한 거부·형식 제한 등. 콜백을 비우고 조용히 내려간다 —
            // 액티비티 쪽 타임아웃이 받아서 클립 없이 게임을 계속한다.
            onForeground = null
            stopSelf()
            return START_NOT_STICKY
        }
        val callback = onForeground
        onForeground = null
        callback?.invoke()
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        onForeground = null
        super.onDestroy()
    }

    private fun ensureChannel() {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            // 녹화 중임을 알리는 상태 표시일 뿐이다 — 소리·헤드업 배너는 게임을 가린다.
            NotificationManager.IMPORTANCE_LOW,
        )
        channel.setShowBadge(false)
        manager.createNotificationChannel(channel)
    }

    companion object {
        private const val CHANNEL_ID = "beavertalk_screen_capture"
        private const val CHANNEL_NAME = "화면 녹화"
        private const val NOTIFICATION_ID = 0xB3A8
        private const val TITLE = "발음 챌린지 녹화 중"
        private const val TEXT = "플레이 영상을 저장하고 있어요"

        /**
         * `startForeground()` 직후 한 번 호출되고 즉시 비워진다. 서비스가 실제로
         * 포그라운드로 올라간 시점을 액티비티에 알리는 유일한 신호다.
         */
        @JvmStatic
        var onForeground: (() -> Unit)? = null

        /** 서비스를 띄운다. 실제 시작 완료는 [onForeground] 로 통지된다. */
        @JvmStatic
        fun start(context: Context) {
            val intent = Intent(context, ScreenCaptureService::class.java)
            if (Build.VERSION.SDK_INT >= 26) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        /** 서비스를 내린다. 멱등. */
        @JvmStatic
        fun stop(context: Context) {
            onForeground = null
            context.stopService(Intent(context, ScreenCaptureService::class.java))
        }
    }
}
