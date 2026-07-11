package im.beavertalk.beavertalk

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.hiennv.flutter_callkit_incoming.CallkitIncomingBroadcastReceiver
import com.hiennv.flutter_callkit_incoming.Data
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar
import java.util.UUID

/**
 * Background alarm delivery for learning-reminder calls.
 *
 * The in-app Riverpod scheduler only runs while the app is alive; this fires
 * even when the app is killed. `AlarmManager.setAlarmClock` (Doze-exempt, exact)
 * triggers this receiver at the scheduled minute; on fire we build the same
 * CallKit `Data` the Dart side uses and broadcast it to
 * [CallkitIncomingBroadcastReceiver] so the full-screen incoming-call UI shows
 * with no live Flutter engine. Weekly repeats reschedule the next occurrence on
 * each fire; a BOOT_COMPLETED receiver reschedules everything after a reboot.
 *
 * Alarms are mirrored from Dart via `AlarmScheduler.syncAlarms` and persisted
 * here (SharedPreferences) purely so the boot handler can rebuild them.
 */
class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            "android.intent.action.LOCKED_BOOT_COMPLETED",
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            -> rescheduleAll(context)
            ACTION_ALARM_FIRE -> onFire(context, intent)
        }
    }

    private fun onFire(context: Context, intent: Intent) {
        val id = intent.getIntExtra(EXTRA_ID, -1)
        if (id < 0) return
        val name = intent.getStringExtra(EXTRA_NAME) ?: "BeaverTalk"
        val avatar = intent.getStringExtra(EXTRA_AVATAR) ?: ""
        val characterId = intent.getIntExtra(EXTRA_CHARACTER_ID, 1)
        showIncomingCall(context, name, avatar, characterId)
        // Weekly repeat: schedule the next occurrence of this same alarm.
        val hour = intent.getIntExtra(EXTRA_HOUR, -1)
        val minute = intent.getIntExtra(EXTRA_MINUTE, -1)
        val days = intent.getBooleanArrayExtra(EXTRA_DAYS)
        if (hour in 0..23 && minute in 0..59 && days != null) {
            scheduleNext(context, id, hour, minute, days, characterId, name, avatar)
        }
    }

    private fun showIncomingCall(context: Context, name: String, avatar: String, characterId: Int) {
        val data = Data(
            mapOf(
                "id" to UUID.randomUUID().toString(),
                "nameCaller" to name,
                "appName" to "BeaverTalk",
                "avatar" to avatar,
                "handle" to "한국어 통화",
                "type" to 0,
                "duration" to 60000L,
                "extra" to hashMapOf<String, Any?>("characterId" to characterId),
                "android" to hashMapOf<String, Any?>(
                    "isCustomNotification" to true,
                    "isShowFullLockedScreen" to true,
                    "ringtonePath" to "system_ringtone_default",
                    "backgroundColor" to "#000000",
                    "actionColor" to "#4CAF50",
                    "textColor" to "#ffffff",
                ),
            ),
        )
        val incoming = CallkitIncomingBroadcastReceiver.getIntentIncoming(context, data.toBundle())
        context.sendBroadcast(incoming)
    }

    companion object {
        const val ACTION_ALARM_FIRE = "im.beavertalk.beavertalk.ALARM_FIRE"
        private const val PREFS = "bt_native_alarms"
        private const val KEY_ALARMS = "alarms"

        private const val EXTRA_ID = "id"
        private const val EXTRA_HOUR = "hour"
        private const val EXTRA_MINUTE = "minute"
        private const val EXTRA_DAYS = "days"
        private const val EXTRA_CHARACTER_ID = "characterId"
        private const val EXTRA_NAME = "name"
        private const val EXTRA_AVATAR = "avatar"

        /**
         * Replaces all scheduled alarms with [jsonArray] (from Dart). Each item:
         * `{id, hour, minute, days:[7 bools, Sun=0], characterId, name, avatar}`.
         * Cancels previously-scheduled alarms, persists the new set, schedules
         * each active alarm's next occurrence.
         */
        fun syncAlarms(context: Context, jsonArray: String) {
            cancelAllStored(context)
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit().putString(KEY_ALARMS, jsonArray).apply()
            val arr = try { JSONArray(jsonArray) } catch (_: Exception) { return }
            for (i in 0 until arr.length()) {
                val o = arr.optJSONObject(i) ?: continue
                scheduleFromJson(context, o)
            }
        }

        private fun rescheduleAll(context: Context) {
            val stored = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .getString(KEY_ALARMS, null) ?: return
            val arr = try { JSONArray(stored) } catch (_: Exception) { return }
            for (i in 0 until arr.length()) {
                val o = arr.optJSONObject(i) ?: continue
                scheduleFromJson(context, o)
            }
        }

        private fun scheduleFromJson(context: Context, o: JSONObject) {
            val id = o.optInt("id", -1)
            if (id < 0) return
            val hour = o.optInt("hour", -1)
            val minute = o.optInt("minute", -1)
            if (hour !in 0..23 || minute !in 0..59) return
            val daysArr = o.optJSONArray("days")
            val days = BooleanArray(7) { idx -> daysArr?.optBoolean(idx, false) ?: false }
            if (days.none { it }) return
            scheduleNext(
                context, id, hour, minute, days,
                o.optInt("characterId", 1),
                o.optString("name", "BeaverTalk"),
                o.optString("avatar", ""),
            )
        }

        private fun scheduleNext(
            context: Context,
            id: Int,
            hour: Int,
            minute: Int,
            days: BooleanArray,
            characterId: Int,
            name: String,
            avatar: String,
        ) {
            val triggerAt = nextTriggerMillis(hour, minute, days) ?: return
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val fire = Intent(context, AlarmReceiver::class.java).apply {
                action = ACTION_ALARM_FIRE
                putExtra(EXTRA_ID, id)
                putExtra(EXTRA_HOUR, hour)
                putExtra(EXTRA_MINUTE, minute)
                putExtra(EXTRA_DAYS, days)
                putExtra(EXTRA_CHARACTER_ID, characterId)
                putExtra(EXTRA_NAME, name)
                putExtra(EXTRA_AVATAR, avatar)
            }
            val pi = PendingIntent.getBroadcast(
                context, id, fire,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            // Exact + Doze-exempt when allowed; inexact fallback if the exact
            // permission isn't held (Android 12+ without it).
            val canExact = Build.VERSION.SDK_INT < 31 || am.canScheduleExactAlarms()
            if (canExact) {
                val show = PendingIntent.getActivity(
                    context, id,
                    Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                am.setAlarmClock(AlarmManager.AlarmClockInfo(triggerAt, show), pi)
            } else {
                am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pi)
            }
        }

        private fun cancel(context: Context, id: Int) {
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val fire = Intent(context, AlarmReceiver::class.java).apply {
                action = ACTION_ALARM_FIRE
            }
            val pi = PendingIntent.getBroadcast(
                context, id, fire,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            am.cancel(pi)
        }

        private fun cancelAllStored(context: Context) {
            val stored = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .getString(KEY_ALARMS, null) ?: return
            val arr = try { JSONArray(stored) } catch (_: Exception) { return }
            for (i in 0 until arr.length()) {
                val id = arr.optJSONObject(i)?.optInt("id", -1) ?: -1
                if (id >= 0) cancel(context, id)
            }
        }

        /** Nearest future epoch-millis matching [hour]:[minute] on an enabled
         * weekday ([days] Sun=0..Sat=6), scanning today + the next 7 days. */
        fun nextTriggerMillis(hour: Int, minute: Int, days: BooleanArray): Long? {
            val now = Calendar.getInstance()
            for (offset in 0..7) {
                val c = Calendar.getInstance().apply {
                    add(Calendar.DAY_OF_YEAR, offset)
                    set(Calendar.HOUR_OF_DAY, hour)
                    set(Calendar.MINUTE, minute)
                    set(Calendar.SECOND, 0)
                    set(Calendar.MILLISECOND, 0)
                }
                // Calendar.DAY_OF_WEEK: Sunday=1..Saturday=7 → index 0..6.
                val dayIndex = c.get(Calendar.DAY_OF_WEEK) - 1
                if (dayIndex in days.indices && days[dayIndex] && c.timeInMillis > now.timeInMillis) {
                    return c.timeInMillis
                }
            }
            return null
        }
    }
}
