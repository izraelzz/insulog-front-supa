package com.example.insulog

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.Calendar

class AlarmScheduler(private val context: Context) {
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    private val repository = AlarmRepository(context)

    fun canScheduleExactAlarms(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager.canScheduleExactAlarms()
    }

    fun schedule(alarm: AlarmData): Boolean {
        cancelSystemAlarm(alarm.id)
        if (!alarm.active) {
            repository.remove(alarm.id)
            return true
        }

        repository.save(alarm)
        if (!canScheduleExactAlarms()) return false

        val triggerAtMillis = nextOccurrence(alarm, System.currentTimeMillis())
        val operation = alarmPendingIntent(alarm)
        val showIntent = PendingIntent.getActivity(
            context,
            alarm.id,
            AlarmActivity.intent(context, alarm),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.setAlarmClock(
            AlarmManager.AlarmClockInfo(triggerAtMillis, showIntent),
            operation
        )
        return true
    }

    fun cancel(id: Int) {
        cancelSystemAlarm(id)
        repository.remove(id)
    }

    fun sync(alarms: List<AlarmData>): Boolean {
        val previousIds = repository.getAll().mapTo(mutableSetOf()) { it.id }
        val activeAlarms = alarms.filter { it.active }
        val currentIds = activeAlarms.mapTo(mutableSetOf()) { it.id }
        (previousIds - currentIds).forEach(::cancelSystemAlarm)
        repository.replaceAll(activeAlarms)

        if (!canScheduleExactAlarms()) return false
        activeAlarms.forEach {
            cancelSystemAlarm(it.id)
            schedule(it)
        }
        return true
    }

    fun rescheduleStored(): Boolean {
        val alarms = repository.getAll()
        if (!canScheduleExactAlarms()) return false
        alarms.forEach {
            cancelSystemAlarm(it.id)
            schedule(it)
        }
        return true
    }

    fun scheduleNextAfterTrigger(id: Int) {
        repository.get(id)?.let(::schedule)
    }

    private fun alarmPendingIntent(alarm: AlarmData): PendingIntent {
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            action = ACTION_FIRE_ALARM
            putExtra(EXTRA_ALARM_ID, alarm.id)
        }
        return PendingIntent.getBroadcast(
            context,
            alarm.id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun cancelSystemAlarm(id: Int) {
        val intent = Intent(context, AlarmReceiver::class.java).apply { action = ACTION_FIRE_ALARM }
        val operation = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (operation != null) {
            alarmManager.cancel(operation)
            operation.cancel()
        }
    }

    private fun nextOccurrence(alarm: AlarmData, nowMillis: Long): Long {
        val now = Calendar.getInstance().apply { timeInMillis = nowMillis }
        val validCalendarDays = alarm.days.mapNotNull(DAY_TO_CALENDAR::get).toSet()

        for (dayOffset in 0..7) {
            val candidate = (now.clone() as Calendar).apply {
                add(Calendar.DAY_OF_YEAR, dayOffset)
                set(Calendar.HOUR_OF_DAY, alarm.hour)
                set(Calendar.MINUTE, alarm.minute)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            val dayMatches = validCalendarDays.isEmpty() || candidate.get(Calendar.DAY_OF_WEEK) in validCalendarDays
            if (dayMatches && candidate.timeInMillis > nowMillis + MINIMUM_RESCHEDULE_DELAY_MS) {
                return candidate.timeInMillis
            }
        }

        return (now.clone() as Calendar).apply {
            add(Calendar.DAY_OF_YEAR, 7)
            set(Calendar.HOUR_OF_DAY, alarm.hour)
            set(Calendar.MINUTE, alarm.minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
    }

    companion object {
        const val ACTION_FIRE_ALARM = "com.example.insulog.FIRE_ALARM"
        const val EXTRA_ALARM_ID = "alarm_id"
        private const val MINIMUM_RESCHEDULE_DELAY_MS = 1_000L
        private val DAY_TO_CALENDAR = mapOf(
            "DOM" to Calendar.SUNDAY,
            "SEG" to Calendar.MONDAY,
            "TER" to Calendar.TUESDAY,
            "QUA" to Calendar.WEDNESDAY,
            "QUI" to Calendar.THURSDAY,
            "SEX" to Calendar.FRIDAY,
            "SAB" to Calendar.SATURDAY
        )
    }
}
